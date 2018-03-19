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

@end
