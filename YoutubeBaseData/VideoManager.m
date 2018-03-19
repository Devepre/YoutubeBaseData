#import "VideoManager.h"
#import "Video.h"

@implementation VideoManager

- (void)getVideos:(NSString *)channelID completionBlock:(void (^)(NSMutableArray *))completionBlock {
    // The API Key you registered for earlier
    NSString *apiKey = @"AIzaSyBBo21dMkwP6JcxVZ022YFACVvcStF-ICw";
    // only used if we want to limit search by channel
    NSString *optionalParams = @"";
    
    // if channel ID provided, create the paramter
    if(channelID) {
        optionalParams = [NSString stringWithFormat:@"&channelId=%@", channelID];
    }
    
    // format the URL request to the YouTube API:
    // max results set to 20, language set to english,
    // order by most relevant
    NSString *URL = [NSString
                     stringWithFormat:@"https://www.googleapis.com/youtube"
                     @"/v3/search?part=snippet&regionCode=US"
                     @"&relevanceLanguage=en&$type=video&order=relevance"
                     @"&maxResults=20&q=%@&key=%@&alt=json%@",
                     @"objective-c", apiKey, optionalParams];
    
    printf("URL is: %s\n", [URL UTF8String]);
    
    /*NSURL *url = [NSURL URLWithString:URL];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              if (!error) {
                                                  NSObject *obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                  NSLog(@"%@", obj);
                                                  
                                              }
                                          }];
    [downloadTask resume];
    */
    
    
    // initialize the request with the encoded URL
    NSURLRequest *request = [[NSURLRequest alloc]
                             initWithURL:[NSURL URLWithString:[URL
                                                               stringByAddingPercentEncodingWithAllowedCharacters:
                                                               [NSCharacterSet URLQueryAllowedCharacterSet]]]];
    
    
    // create a session and start the request
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    if (!error) {
                        NSObject *obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        NSLog(@"%@", obj);
                        
                        Video *vid = [[Video alloc] init];
                        
                        // create an array of Video objects from
                        // the JSON received
                        [vid getVideoList:[NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:0 error:nil] completionBlock:
                         ^(NSMutableArray *videoList) {
                             // return the final list
                             completionBlock(videoList);
                         }];
                    }
                    else {
                        // TODO: better error handling
                        NSLog(@"error = %@", error);
                    }
                }] resume];
}

@end
