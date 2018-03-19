#import "ViewController.h"
#import "VideoManager.h"
#import "Video.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performYTTask];
}

- (void)performYTTask {
    __block NSMutableArray *ytVideos = [[NSMutableArray alloc] init];
    
    VideoManager *videoManager = [[VideoManager alloc] init];
    
    [videoManager getVideosForChannel:nil
                      completionBlock:^(NSMutableArray *videoList) {
                          NSSortDescriptor *sortingDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate"
                                                                                            ascending:NO];
                          ytVideos = [[videoList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortingDescriptor]] mutableCopy];
                          Video *video = [ytVideos objectAtIndex:0];
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
//                              YTPlayerView *videoPlayerView = [[YTPlayerView alloc] initWithFrame:
//                                                               CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.width - 20)];
//                              [videoPlayerView loadWithVideoId:video.videoID];
//                              [self.view addSubview:videoPlayerView];
                              [self.playerView loadWithVideoId:video.videoID];
                              self.descriptionLabel.text = video.videoDescription;
                              
                          });
                          
                          //another way to do work on Main Thread
                          /*
                          Video *video = [ytVideos objectAtIndex:0];
                          NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                              [self.playerView loadWithVideoId:video.videoID];
                          }];
                          NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
                          [mainQueue addOperation:operation]; */
                          
                      }];
    
}

@end
