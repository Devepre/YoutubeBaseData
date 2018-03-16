#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, strong) NSString *videoTitle;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) NSString *channelTitle;
@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *videoDescription;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSDate *pubDate;

/**
 * create array of video objects
 * using the JSON data passed in the
 * dictionary parameter
 *
 * @param videoData JSON data from API
 * @param completionBlock array of video objects
 */
- (void)getVideoList:(NSDictionary *)videoData
     completionBlock:(void (^)(NSMutableArray *))completionBlock;

@end
