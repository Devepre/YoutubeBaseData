#import "VideoManager.h"
#import "Video.h"

static NSString *baseURL = @"https://www.googleapis.com/youtube/v3";
static NSString *apiKey = @"AIzaSyBBo21dMkwP6JcxVZ022YFACVvcStF-ICw";

@implementation VideoManager

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
