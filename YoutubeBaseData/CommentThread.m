#import "CommentThread.h"
#import "Comment.h"

@implementation CommentThread

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _Id = dictionary[@"id"];
        _videoId = dictionary[@"snippet"][@"videoId"];
//        _topLevelComment = dictionary[@"snippet"][@"topLevelComment"];
        _topLevelComment = [[Comment alloc] initWithDictionary:dictionary[@"snippet"][@"topLevelComment"]];
    }
    
    return self;
}

@end
