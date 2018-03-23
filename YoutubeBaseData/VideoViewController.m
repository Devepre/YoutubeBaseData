#import "VideoViewController.h"
#import "Video.h"
#import "VideoManager.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.video) {
        [self.videoPlayer loadWithVideoId:self.video.videoID];
    } else {
        NSLog(@"The video ID is absent!");
    }
   
}

- (void)performYTTask {
    VideoManager *videoManager = [[VideoManager alloc] init];
    [videoManager getCommentsThreadsForVideoID:self.video.videoID completionBlock:^(NSArray *commentThreads) {
        NSLog(@"Comment Thread:\n%@", commentThreads);
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
