#import "Video.h"
#import "NSString+ToDate.h"

@implementation Video

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _videoTitle = dictionary[@"snippet"][@"title"];
        _videoID = dictionary[@"id"][@"videoId"];
        _channelID = dictionary[@"snippet"][@"channelId"];
        _channelTitle = dictionary[@"snippet"][@"channelTitle"];
        _videoDescription = dictionary[@"snippet"][@"description"];
        _pubDate = [dictionary[@"snippet"][@"publishedAt"]dateWithJSONString];
        _thumbnailURL = dictionary[@"snippet"][@"thumbnails"]
        [@"high"][@"url"];
    }
    
    return self;
}

/**
 * create array of video objects
 * using the JSON data passed in the
 * dictionary parameter
 *
 * @param videoData JSON data from API
 * @param completionBlock array of video objects
 */
- (void)getVideoList:(NSDictionary *)videoData
     completionBlock:(void (^)(NSMutableArray *))completionBlock {
    
    // get the array of videos from the dictionary containing
    // the JSON data returned from the call to the YouTube API
    NSArray *videos = (NSArray *)[videoData objectForKey:@"items"];
    NSMutableArray *videoList = [[NSMutableArray alloc] init];
    
    // loop through each video in the array, if it has an ID
    // initialize an instance of self with the relative
    // properties
    for (NSDictionary *videoDetail in videos) {
        if (videoDetail[@"id"][@"videoId"]){
            [videoList addObject:[[Video alloc]initWithDictionary:videoDetail]];
        }
    }
    
    // pass the array of video objects back to VideoManager.m
    completionBlock(videoList);
}

@end
