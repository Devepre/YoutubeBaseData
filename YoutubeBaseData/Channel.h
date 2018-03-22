#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Channel : NSObject

@property (nonatomic, strong) NSString  *channellID;
@property (nonatomic, strong) NSString  *channelTitle;
@property (nonatomic, strong) NSString  *channelDescription;
@property (nonatomic, strong) NSString  *thumbnailURL;
@property (nonatomic, strong) NSDate    *pubDate;

@property (nonatomic, strong) UIImage   *thumbnailImage;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
