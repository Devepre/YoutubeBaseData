#import "ViewController.h"
@class Video;

@interface VideoViewController : ViewController

@property (weak, nonatomic) IBOutlet YTPlayerView *videoPlayer;
@property (weak, nonatomic) Video *video;

@end
