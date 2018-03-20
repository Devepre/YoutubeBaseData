/*
 Using webview manually: http://iosdevelopertips.com/video/display-youtube-videos-without-exiting-your-application.html
 Youtube key generation: https://developers.google.com/youtube/v3/quickstart/ios
 Youtube Player iOS helper: https://github.com/youtube/youtube-ios-player-helper
 CocoaPods tutorial for Swift: https://www.raywenderlich.com/156971/cocoapods-tutorial-swift-getting-started
 
 Additional
 Youtoube API3 - Objective-C wrapper: https://github.com/muhammadbassio/YouTubeAPI3-Objective-C-wrapper
 */

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchQuestionTextField;

@end

