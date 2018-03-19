#import "ViewController.h"
#import "VideoManager.h"
#import "Video.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self original];
}

- (void)test {
    // 1
    NSString *dataUrl = @"https://www.googleapis.com/youtube/v3/search?part=snippet&regionCode=US&relevanceLanguage=en&$type=video&order=relevance&maxResults=20&q=programming&key=AIzaSyBBo21dMkwP6JcxVZ022YFACVvcStF-ICw&alt=json";
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    // 2
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              if (!error) {
                                                  NSObject *obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                  NSLog(@"%@", obj);
                                                  
                                              }
                                          }];
    
    // 3
    [downloadTask resume];
}

- (void)original {
    __block NSMutableArray *ytVideos = [[NSMutableArray alloc] init];
    
    VideoManager *vidManager = [[VideoManager alloc] init];
    
    [vidManager getVideos:nil
          completionBlock:^(NSMutableArray *videoList) {
              ytVideos = [[videoList sortedArrayUsingDescriptors:[NSArray
                                                                  arrayWithObject:[[NSSortDescriptor alloc]
                                                                                   initWithKey:@"pubDate" ascending:NO]]]
                          mutableCopy];
              
              NSLog(@"Arrayy: %@", ytVideos);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  Video *video = [ytVideos objectAtIndex:0];
                  YTPlayerView *videoPlayerView = [[YTPlayerView alloc] initWithFrame:
                                                   CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.width - 20)];
                  
                  [videoPlayerView loadWithVideoId:video.videoID];
                  [self.view addSubview:videoPlayerView];
              });
              
//              Video *video = [ytVideos objectAtIndex:0];
//              [self.playerView loadWithVideoId:video.videoID];
//              YTPlayerView *videoPlayerView = [[YTPlayerView alloc] initWithFrame:
//                                               CGRectMake(0, 0, 375, 320)];
//
//              [videoPlayerView loadWithVideoId:video.videoID];
//              [self.view addSubview:videoPlayerView];
          }];
    
//    YouTubeView *youTubeView = [[YouTubeView alloc]
//                                initWithStringAsURL:@"http://www.youtube.com/watch?v=gczw0WRmHQU"
//                                frame:CGRectMake(100, 170, 120, 120)];
//    [[self view] addSubview:youTubeView];
    
//    sleep(3);
    
    //
//    Video *video = [ytVideos objectAtIndex:0];
//    YTPlayerView *videoPlayerView = [[YTPlayerView alloc] initWithFrame:
//                                     CGRectMake(0, 0, 375, 320)];
//
//    [videoPlayerView loadWithVideoId:video.videoID];
//    [self.view addSubview:videoPlayerView];
}

@end
