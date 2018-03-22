#import "VideoManager.h"
#import "Video.h"
#import "Channel.h"

static NSString *baseURL = @"https://www.googleapis.com/youtube/v3";
static NSString *apiKey = @"AIzaSyBBo21dMkwP6JcxVZ022YFACVvcStF-ICw";

// https://www.googleapis.com/youtube/v3/
//  channels?part=snippet%2CcontentDetails%2Cstatistics
//  &id=UC_x5XG1OV2P6uZZ5FSM9Ttw
//  &key={YOUR_API_KEY}

@implementation VideoManager

- (void)getImageForChannel: (NSString *)channelName  completionBlock:(void (^)(UIImage *))completionBlock {
    NSString *stringURL = [NSString stringWithFormat:@"%@"
                           @"/channels?part=snippet%%2CcontentDetails%%2Cstatistics"
                           @"&id=%@"
                           @"&key=%@",
                           baseURL, channelName, apiKey];
    
    NSURL *URL = [NSURL URLWithString:stringURL];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *errorJSON = nil;
            NSDictionary *receivedDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorJSON];
            if (!errorJSON) {
                printf("%s\n", [[receivedDictionary description] UTF8String]);
                
                NSArray *channels = (NSArray *)[receivedDictionary objectForKey:@"items"];
                if (channels) {
                    Channel *channel = [[Channel alloc] initWithDictionary:[channels objectAtIndex:0]];
                    [self dowloadImageWithURL:channel.thumbnailURL completionBlock:^(UIImage *downloadedImage) {
                        channel.thumbnailImage = downloadedImage;
                        completionBlock(channel.thumbnailImage);
                    }];
                } else {
                    NSLog(@"Error during getting video list occured. Response is %@", receivedDictionary);
                }
            } else {
                NSLog(@"Error pasing JSON:\n%@", error);
            }
        } else {
            NSLog(@"Error retreiving data:\n%@", error);
        }
    }];
    [downloadTask resume];
}

- (void)getVideosFor:(NSString *)searchQ andChannelID:(NSString *)channelID andMaxResults:(NSInteger)maxResults completionBlock:(void (^)(NSMutableArray *))completionBlock {
    NSURL *URL = [self generateURLWithSearchQuestion:searchQ andChannelID:channelID andMaxResults:maxResults];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *errorJSON = nil;
            NSDictionary *receivedDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorJSON];
            if (!errorJSON) {
                NSArray *videos = (NSArray *)[receivedDictionary objectForKey:@"items"];
                if (videos) {
                    [self downloadImagesFromArray:videos completionBlock:^(NSMutableArray *videos) {
                        completionBlock(videos);
                    }];
                } else {
                    NSLog(@"Error during getting video list occured. Response is %@", receivedDictionary);
                }
            } else {
                NSLog(@"Error pasing JSON:\n%@", error);
            }
        } else {
            NSLog(@"Error retreiving data:\n%@", error);
        }
    }];
    [downloadTask resume];
    
}

- (NSURL *)generateURLWithSearchQuestion:(NSString *)searchQ andChannelID:(NSString *) channelID andMaxResults:(NSInteger)maxResults{
    NSString *optionalChannelParams = @"";
    if(channelID) {
        optionalChannelParams = [NSString stringWithFormat:@"&channelId=%@", channelID];
    }
    
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

- (void)downloadImagesFromArray: (NSArray *)array completionBlock:(void (^)(NSMutableArray *))completionBlock {
    NSMutableArray *resullt = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    for (NSDictionary *videoDetail in array) {
        if (videoDetail[@"id"][@"videoId"]) {
            Video *newVideo = [[Video alloc]initWithDictionary:videoDetail];
            
            //loading image thumbnails
            NSString *imageURLString = videoDetail[@"snippet"][@"thumbnails"][@"high"][@"url"];
            
            NSString *channelName = newVideo.channelID;
            __block UIImage *channelImage;
            dispatch_group_enter(dispatchGroup);
            [self getImageForChannel:channelName completionBlock:^(UIImage *img) {
                channelImage = img;
                newVideo.channelThumbnailImage = channelImage;
                dispatch_group_leave(dispatchGroup);
            }];
            
            dispatch_group_enter(dispatchGroup);
            [self dowloadImageWithURL:imageURLString completionBlock:^(UIImage *downloadedImage) {
                newVideo.thumbnailImage = downloadedImage;
                dispatch_group_leave(dispatchGroup);
            }];
            
            [resullt addObject:newVideo];
        }
    }
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        completionBlock(resullt);
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

@end
