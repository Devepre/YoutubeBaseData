#import "ViewController.h"
#import "VideoManager.h"
#import "Video.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *ytVideos;

@end

@implementation ViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.ytVideos = [[NSMutableArray alloc] init];
    
    [self performYTTask];
}

- (void)performYTTask {
//    __block NSMutableArray *ytVideos = [[NSMutableArray alloc] init];
    
    VideoManager *videoManager = [[VideoManager alloc] init];
    
    [videoManager getVideosForChannel:nil
                      completionBlock:^(NSMutableArray *videoList) {
                          NSSortDescriptor *sortingDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate"
                                                                                            ascending:NO];
                          self.ytVideos = [[videoList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortingDescriptor]] mutableCopy];
                          Video *video = [self.ytVideos objectAtIndex:0];
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
//                              YTPlayerView *videoPlayerView = [[YTPlayerView alloc] initWithFrame:
//                                                               CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.width - 20)];
//                              [videoPlayerView loadWithVideoId:video.videoID];
//                              [self.view addSubview:videoPlayerView];
//                              [self.playerView loadWithVideoId:video.videoID];
                              
                              NSLog(@"Reloading view");
                              [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                              
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

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ytVideos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UILabel *videoDescriptionLabel = (UILabel *)[cell viewWithTag:145];
    videoDescriptionLabel.text = [[self.ytVideos objectAtIndex:indexPath.row] videoDescription];
    
    YTPlayerView *ytVideoPlayerView = [cell viewWithTag:144];
    [ytVideoPlayerView loadWithVideoId:[[self.ytVideos objectAtIndex:indexPath.row] videoID]];
    
    return cell;
}

@end
