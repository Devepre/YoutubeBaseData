#import "ViewController.h"
@class Video;

@interface VideoViewController : ViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet YTPlayerView   *videoPlayer;
@property (weak, nonatomic) Video                   *video;
@property (weak, nonatomic) IBOutlet UITableView    *commentsTable;
@property (weak, nonatomic) IBOutlet UITextField    *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton       *commentButton;

@end
