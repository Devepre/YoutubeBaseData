#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, strong) NSString  *commentId;
@property (nonatomic, strong) NSString  *authorChannelId;
@property (nonatomic, strong) NSString  *authorDisplayName;
@property (nonatomic, strong) NSString  *authorProfileImageUrl;
@property (nonatomic, strong) NSString  *textDisplay;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
