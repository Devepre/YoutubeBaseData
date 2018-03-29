#import "SignInViewController.h"

@interface SignInViewController ()

@property (nonatomic, strong) GIDSignIn *signIn;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the service object.
    self.service = [[GTLRYouTubeService alloc] init];
    
    // Configure Google Sign-in.
    self.signIn = [GIDSignIn sharedInstance];
    self.signIn.delegate = self;
    self.signIn.uiDelegate = self;
    self.signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeYouTubeForceSsl, nil];
    [self.signIn signInSilently];

}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error) {
        NSLog(@"Error Sign in: %@", error.localizedDescription);
        self.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        self.service.authorizer = user.authentication.fetcherAuthorizer;
//        [self leaveComment];
    }
    [self toggleAuthorizeUI];
}

- (void)leaveComment {
    NSString *channelId = @"UCreShqen9F2H2UgoQHm-EEg";
    NSString *videoId = @"DvfByOGygt4";
    NSString *text = @"нло с iOS прилетело и опубликовало эту надпись здесь";
    
    // Create a comment snippet with text.
    GTLRYouTube_CommentSnippet *commentSnipet = [[GTLRYouTube_CommentSnippet alloc] init];
    [commentSnipet setTextOriginal:text];
    
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
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayAddedComment:finishedWithObject:error:)];
}
- (void)displayAddedComment:(GTLRServiceTicket *)ticket
         finishedWithObject:(GTLRYouTubeQuery_CommentThreadsInsert *)comments
                      error:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSLog(@"Object: %@", comments);
}

- (void)toggleAuthorizeUI {
    if (self.signIn.currentUser.authentication == nil) {// Not signed in
        self.statusLabel.text = @"You are not Authorized";
        self.signInButton.hidden = NO;
        self.signOutButton.hidden = YES;
        self.disconnectButton.hidden = YES;
    } else {// Signed in
        self.statusLabel.text = [NSString stringWithFormat:@"Signed in as: %@ %@", self.signIn.currentUser.profile.name, self.signIn.currentUser.profile.familyName ? self.signIn.currentUser.profile.familyName : @""];
        self.signInButton.hidden = YES;
        self.signOutButton.hidden = NO;
        self.disconnectButton.hidden = NO;
    }
}

#pragma mark - Buttons Handling
// Signs the user out of the application for scenarios such as switching profiles
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
    [self toggleAuthorizeUI];
}

// Note: Disconnect revokes access to user data and should only be called in scenarios such as when the user deletes their account. More information
// on revocation can be found here: https://goo.gl/Gx7oEG.
- (IBAction)didTapDisconnect:(id)sender {
    [[GIDSignIn sharedInstance] disconnect];
    [self toggleAuthorizeUI];
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
