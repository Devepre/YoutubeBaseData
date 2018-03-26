#import "ViewController.h"
@class Video;

@interface VideoViewController : ViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet YTPlayerView *videoPlayer;
@property (weak, nonatomic) Video *video;
@property (weak, nonatomic) IBOutlet UITableView *commentsTable;

@end
