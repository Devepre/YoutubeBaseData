#import "NSString+ToDate.h"

@implementation NSString (ToDate)

- (NSDate *)dateWithJSONString {
    [NSDateFormatter setDefaultFormatterBehavior: NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setCalendar:[[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:self];
    return date;
    
}

@end
