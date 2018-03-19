#import <Foundation/Foundation.h>

@interface VideoManager : NSObject

- (void)getVideosFor:(NSString *)searchQ andChannelID:(NSString *)channelID completionBlock:(void (^)(NSMutableArray *))completionBlock;

@end
