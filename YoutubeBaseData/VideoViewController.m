#import "VideoViewController.h"
#import "Video.h"
#import "VideoManager.h"
#import "CommentThread.h"
#import "Comment.h"
#import <GTLRYouTube.h>
#import "GlobalContainer.h"

@interface VideoViewController ()

@property (nonatomic, strong) NSString              *commentString;
@property (nonatomic, strong) GTLRYouTubeService    *service;
@property NSArray                                   *commentThreads;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.video) {
        [self.videoPlayer loadWithVideoId:self.video.videoID];
        NSLog(@"Video: %@", self.video.videoID);
        NSLog(@"Channel id: %@", self.video.channelID);
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

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.commentString = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Buttons hadnling
- (IBAction)commentButton:(UIButton *)sender {
    [self leaveComment];
}

- (void)leaveComment {
    // Initialize the service object.
//    self.service = [[GTLRYouTubeService alloc] init];
    self.service = [GlobalContainer sharedInstance].service;
    
    NSString *channelId = self.video.channelID;
    NSString *videoId = self.video.videoID;
    
    // Create a comment snippet with text.
    GTLRYouTube_CommentSnippet *commentSnipet = [[GTLRYouTube_CommentSnippet alloc] init];
    [commentSnipet setTextOriginal:self.commentString];
    
    // Create a top-level comment with snippet.
    GTLRYouTube_Comment *topLevelComment = [[GTLRYouTube_Comment alloc] init];
    [topLevelComment setSnippet:commentSnipet];
    
    // Create a comment thread snippet with channelId and top-level comment.
    GTLRYouTube_CommentThreadSnippet *commentThreadSnippet = [[GTLRYouTube_CommentThreadSnippet alloc] init];
    [commentThreadSnippet setChannelId:channelId];
    [commentThreadSnippet setTopLevelComment:topLevelComment];
    [commentThreadSnippet setVideoId:videoId];
    
    // Create a comment thread with snippet.
    GTLRYouTube_CommentThread *commentThread = [[GTLRYouTube_CommentThread alloc] init];
    [commentThread setSnippet:commentThreadSnippet];
    
    // Call the YouTube Data API's commentThreads.insert method to create a comment.
    GTLRYouTubeQuery_CommentThreadsInsert *query = [GTLRYouTubeQuery_CommentThreadsInsert queryWithObject:commentThread part:@"snippet"];
    
    //execute
//    [self.service executeQuery:query
    [[GlobalContainer sharedInstance].service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayAddedComment:finishedWithObject:error:)];
}
- (void)displayAddedComment:(GTLRServiceTicket *)ticket
         finishedWithObject:(GTLRYouTubeQuery_CommentThreadsInsert *)comments
                      error:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSLog(@"Object: %@", comments);
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
