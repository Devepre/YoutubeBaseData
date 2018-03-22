#import <Foundation/Foundation.h>
@class UIImage;

@interface VideoManager : NSObject

- (void)getVideosFor:(NSString *)searchQ andChannelID:(NSString *)channelID andMaxResults:(NSInteger)maxResults completionBlock:(void (^)(NSMutableArray *))completionBlock;
- (void)getImageForChannel: (NSString *)channelName  completionBlock:(void (^)(UIImage *))completionBlock;

@end
