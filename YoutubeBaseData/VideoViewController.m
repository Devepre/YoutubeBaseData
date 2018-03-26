#import "VideoViewController.h"
#import "Video.h"
#import "VideoManager.h"
#import "CommentThread.h"
#import "Comment.h"

@interface VideoViewController ()

@property NSArray *commentThreads;

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
        self.commentThreads = commentThreads;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentsTable reloadData];
        });
    }];
    
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [self.commentThreads count];
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.commentsTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    CommentThread *commentThread = [self.commentThreads objectAtIndex:indexPath.row];
    Comment *topLevelComment = [commentThread topLevelComment];
    cell.textLabel.text = [topLevelComment textDisplay];
    
    return cell;
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
