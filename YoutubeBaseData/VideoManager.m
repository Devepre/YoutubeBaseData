#import "VideoManager.h"
#import "Video.h"
#import "Channel.h"

static NSString *baseURL = @"https://www.googleapis.com/youtube/v3";
static NSString *apiKey = @"AIzaSyBBo21dMkwP6JcxVZ022YFACVvcStF-ICw";

@implementation VideoManager

- (void)getVideosFor:(NSString *)searchQ andChannelID:(NSString *)channelID andMaxResults:(NSInteger)maxResults completionBlock:(void (^)(NSMutableArray *))completionBlock {
    NSURL *URL = [self generateURLWithSearchQuestion:searchQ andChannelID:channelID andMaxResults:maxResults];
    [self getArrayOfObjectsFromURL:URL forObjectKey:@"items" completionBlock:^(NSArray *videos) {
        if (videos) {
            [self downloadImagesForVideosArray:videos completionBlock:^(NSMutableArray *videos) {
                completionBlock(videos);
            }];
        } else {
            NSLog(@"Error during getting video list occured");
        }
    }];
}

- (void)getImageForChannel: (NSString *)channelName completionBlock:(void (^)(UIImage *))completionBlock {
    NSURL *URL = [self generateURLToFindChannel:channelName];
    
    [self getArrayOfObjectsFromURL:URL forObjectKey:@"items" completionBlock:^(NSArray *channels) {
        if (channels) {
            Channel *channel = [[Channel alloc] initWithDictionary:[channels objectAtIndex:0]];
            [self dowloadImageWithURL:channel.thumbnailURL completionBlock:^(UIImage *downloadedImage) {
                channel.thumbnailImage = downloadedImage;
                completionBlock(channel.thumbnailImage);
            }];
        } else {
            NSLog(@"Error during getting video list occured");
        }
    }];
    
}

- (void)getArrayOfObjectsFromURL: (NSURL *)URL forObjectKey: (NSString *)objectKey completionBlock:(void (^)(NSArray *))completionBlock {
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *errorJSON = nil;
            NSDictionary *receivedDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorJSON];
            if (!errorJSON) {
                NSArray *array = (NSArray *)[receivedDictionary objectForKey:objectKey];
                completionBlock(array);
            } else {
                NSLog(@"Error pasing JSON:\n%@", error);
            }
        } else {
            NSLog(@"Error retreiving data:\n%@", error);
        }
    }];
    [downloadTask resume];
}

- (void)downloadImagesForVideosArray: (NSArray *)array completionBlock:(void (^)(NSMutableArray *))completionBlock {
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    for (NSDictionary *videoDetail in array) {
        if (videoDetail[@"id"][@"videoId"]) {
            Video *video = [[Video alloc]initWithDictionary:videoDetail];
            
            //loading image thumbnails
            NSString *imageURLString = videoDetail[@"snippet"][@"thumbnails"][@"high"][@"url"];
            
            dispatch_group_enter(dispatchGroup);
            [self getImageForChannel:video.channelID completionBlock:^(UIImage *img) {
                video.channelThumbnailImage = img;
                dispatch_group_leave(dispatchGroup);
            }];
            
            dispatch_group_enter(dispatchGroup);
            [self dowloadImageWithURL:imageURLString completionBlock:^(UIImage *downloadedImage) {
                video.thumbnailImage = downloadedImage;
                dispatch_group_leave(dispatchGroup);
            }];
            
            [resultArray addObject:video];
        }
    }
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        completionBlock(resultArray);
    });
    
}

- (void)dowloadImageWithURL:(NSString *)imageURLString completionBlock:(void (^)(UIImage *))completionBlock {
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            UIImage *downloadedImage = [UIImage imageWithData:data];
            completionBlock(downloadedImage);
        } else {
            NSLog(@"Error retreiving data:\n%@", error);
        }
    }];
    [downloadTask resume];
    
}

#pragma mark - Formatting URL's

- (NSURL *)generateURLWithSearchQuestion:(NSString *)searchQ andChannelID:(NSString *) channelID andMaxResults:(NSInteger)maxResults{
    NSString *optionalChannelParams = channelID ? [NSString stringWithFormat:@"&channelId=%@", channelID] : @"";
    
    NSString *stringURL = [NSString stringWithFormat:@"%@"
                           @"/search?part=snippet"
                           @"&$type=video&order=relevance"
                           @"&maxResults=%ld"
                           @"&q=%@"
                           @"&key=%@"
                           @"&alt=json%@",
                           baseURL, (long)maxResults, searchQ, apiKey, optionalChannelParams];
    NSURL *URL = [NSURL URLWithString:stringURL];
    
    return URL;
}

- (NSURL *)generateURLToFindChannel:(NSString *)channelName {
    NSString *stringURL = [NSString stringWithFormat:@"%@"
                           @"/channels?part=snippet%%2CcontentDetails%%2Cstatistics"
                           @"&id=%@"
                           @"&key=%@",
                           baseURL, channelName, apiKey];
    
    NSURL *URL = [NSURL URLWithString:stringURL];
    return URL;
}

@end
