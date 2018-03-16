#import <Foundation/Foundation.h>

@interface VideoManager : NSObject

- (void)getVideos:(NSString *)channelID
  completionBlock:(void (^)(NSMutableArray *))completionBlock;

@end
