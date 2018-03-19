#import "VideoManager.h"
#import "Video.h"

@implementation VideoManager

- (void)getVideosFor:(NSString *)searchQ andChannelID:(NSString *)channelID completionBlock:(void (^)(NSMutableArray *))completionBlock {
    NSString *apiKey = @"AIzaSyBBo21dMkwP6JcxVZ022YFACVvcStF-ICw";
    NSString *baseURL = @"https://www.googleapis.com/youtube/v3";
//    NSString *searchPhrase = @"objective-c";
    NSInteger maxResults = 20;
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
    
    printf("start URL\n");
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *errorJSON = nil;
            NSDictionary *receivedDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorJSON];
            if (!errorJSON) {
                printf("<Received object>\n%s\n<End of received object>\n", [[receivedDictionary description] UTF8String]);

                NSArray *videos = (NSArray *)[receivedDictionary objectForKey:@"items"];
                NSMutableArray *videoList = [[NSMutableArray alloc] init];
                
                dispatch_group_t dispatchGroup = dispatch_group_create();
                
                for (NSDictionary *videoDetail in videos) {
                    if (videoDetail[@"id"][@"videoId"]) {
                        Video *newVideo = [[Video alloc]initWithDictionary:videoDetail];
                        
                        //loading image thumbnails
                        NSString *imageURLString = videoDetail[@"snippet"][@"thumbnails"][@"high"][@"url"];
                        dispatch_group_enter(dispatchGroup);
                        [self dowloadImageWithURL:imageURLString andDispatch:dispatchGroup completionBlock:^(UIImage *downloadedImage) {
                            newVideo.thumbnailImage = downloadedImage;
                        }];
                        
                        [videoList addObject:newVideo];
                    }
                }
                
                dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
                    // pass the array of video objects back to user of VideoManager
                    completionBlock(videoList);
                });

            } else {
                NSLog(@"Error pasing JSON:\n%@", error);
            }
        } else {
            NSLog(@"Error retreiving data:\n%@", error);
        }
    }];
    [downloadTask resume];
    
}

- (void)dowloadImageWithURL:(NSString *)imageURLString andDispatch:(dispatch_group_t) dispatchGroup completionBlock:(void (^)(UIImage *))completionBlock{
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            UIImage *downloadedImage = [UIImage imageWithData:data];
            NSLog(@"image downloaded: %@", downloadedImage);
            dispatch_group_leave(dispatchGroup);
            
            completionBlock(downloadedImage);
        } else  {
            NSLog(@"Error retreiving data:\n%@", error);
        }
    }];
    [downloadTask resume];
    
}

@end
