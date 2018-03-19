#import <Foundation/Foundation.h>

@interface VideoManager : NSObject

- (void)getVideosForChannel:(NSString *)channelID completionBlock:(void (^)(NSMutableArray *))completionBlock;

@end
