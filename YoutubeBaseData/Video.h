#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, strong) NSString  *videoTitle;
@property (nonatomic, strong) NSString  *videoID;
@property (nonatomic, strong) NSString  *channelTitle;
@property (nonatomic, strong) NSString  *channelID;
@property (nonatomic, strong) NSString  *videoDescription;
@property (nonatomic, strong) NSString  *thumbnailURL;
@property (nonatomic, strong) NSDate    *pubDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
