#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveToggleAuthUINotification:)
     name:@"ToggleAuthUINotification"
     object:nil];
    [self toggleAuthUI];
    self.statusText.text = @"Google Sign in\niOS Demo";
}

- (void)toggleAuthUI {
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {// Not signed in
        self.statusText.text = @"Google Sign in";
        self.signInButton.hidden = NO;
        self.signOutButton.hidden = YES;
        self.disconnectButton.hidden = YES;
    } else {// Signed in
        self.signInButton.hidden = YES;
        self.signOutButton.hidden = NO;
        self.disconnectButton.hidden = NO;
    }
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    NSLog(@"Customer details: %@ %@ %@ %@", userId, idToken, name, email);
    // ...
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"ToggleAuthUINotification"
     object:nil];
    
}

- (void)receiveToggleAuthUINotification:(NSNotification *) notification {
    if ([notification.name isEqualToString:@"ToggleAuthUINotification"]) {
        [self toggleAuthUI];
        self.statusText.text = notification.userInfo[@"statusText"];
    }
}

// Signs the user out of the application for scenarios such as switching profiles
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
    [self toggleAuthUI];
}

// Note: Disconnect revokes access to user data and should only be called in scenarios such as when the user deletes their account. More information
// on revocation can be found here: https://goo.gl/Gx7oEG.
- (IBAction)didTapDisconnect:(id)sender {
    [[GIDSignIn sharedInstance] disconnect];
}

- (IBAction)leaveComment:(UIButton *)sender {
    NSString *channelId = @"UCreShqen9F2H2UgoQHm-EEg";
    NSString *videoId = @"DvfByOGygt4";
    NSString *text = @"нло прилетело и опубликовало эту надпись здесь";
    
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
    GTLRYouTubeService *service = [[GTLRYouTubeService alloc] init];
    static NSString *apiKey = @"405503343976-d1bppmkerltkgi2lg3i83d7iujdqb214.apps.googleusercontent.com";
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    NSLog(@"AUTH: %@", signIn.currentUser.authentication);
    service.APIKey = apiKey;
    [service executeQuery:query completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
        NSLog(@"object: %@\nError: %@", object, callbackError);
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
