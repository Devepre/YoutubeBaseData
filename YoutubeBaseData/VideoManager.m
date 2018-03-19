#import "VideoManager.h"
#import "Video.h"

@implementation VideoManager

- (void)getVideosForChannel:(NSString *)channelID completionBlock:(void (^)(NSMutableArray *))completionBlock {
    NSString *apiKey = @"AIzaSyBBo21dMkwP6JcxVZ022YFACVvcStF-ICw";
    NSString *baseURL = @"https://www.googleapis.com/youtube/v3";
    NSString *searchPhrase = @"objective-c";
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
                     baseURL, (long)maxResults, searchPhrase, apiKey, optionalChannelParams];
    NSURL *URL = [NSURL URLWithString:stringURL];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *errorJSON = nil;
            NSDictionary *receivedDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorJSON];
            if (!errorJSON) {
                printf("<Received object>\n%s\n<End of received object>\n", [[receivedDictionary description] UTF8String]);

                NSArray *videos = (NSArray *)[receivedDictionary objectForKey:@"items"];
                NSMutableArray *videoList = [[NSMutableArray alloc] init];
                
                for (NSDictionary *videoDetail in videos) {
                    if (videoDetail[@"id"][@"videoId"]){
                        [videoList addObject:[[Video alloc]initWithDictionary:videoDetail]];
                    }
                }
                
                // pass the array of video objects back to user of VideoManager
                completionBlock(videoList);
            } else {
                NSLog(@"Error pasing JSON:\n%@", error);
            }
        } else {
            NSLog(@"Error retreiving data:\n%@", error);
        }
    }];
    [downloadTask resume];
    
}

@end
