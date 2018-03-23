#import "Comment.h"

@implementation Comment

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _commentId = dictionary[@"id"];
        _authorChannelId = dictionary[@"snippet"][@"authorChannelId"];
        _authorDisplayName = dictionary[@"snippet"][@"authorDisplayName"];
        _authorProfileImageUrl = dictionary[@"snippet"][@"authorProfileImageUrl"];
        _textDisplay = dictionary[@"snippet"][@"textDisplay"];
        
    }
    
    return self;
}

@end
