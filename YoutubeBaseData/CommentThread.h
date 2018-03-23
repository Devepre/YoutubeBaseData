#import <Foundation/Foundation.h>
@class Comment;

@interface CommentThread : NSObject

@property (nonatomic, strong) NSString  *Id;
@property (nonatomic, strong) NSString  *videoId;
@property (nonatomic, strong) Comment   *topLevelComment;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
