#import <Foundation/Foundation.h>

@interface VideoManager : NSObject

- (void)getVideosFor:(NSString *)searchQ andChannelID:(NSString *)channelID andMaxResults:(NSInteger)maxResults completionBlock:(void (^)(NSMutableArray *))completionBlock;

@end
