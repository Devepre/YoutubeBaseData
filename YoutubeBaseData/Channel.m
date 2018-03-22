#import "Channel.h"
#import "NSString+ToDate.h"

@implementation Channel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _channellID = dictionary[@"id"];
        _channelTitle = dictionary[@"snippet"][@"title"];
        _channelDescription = dictionary[@"snippet"][@"description"];
        _thumbnailURL = dictionary[@"snippet"][@"thumbnails"][@"high"][@"url"];
        
        _pubDate = [dictionary[@"snippet"][@"publishedAt"]dateWithJSONString];
        
    }
    
    return self;
}

@end
