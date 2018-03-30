#import "SignInViewController.h"
#import "GlobalContainer.h"

@interface SignInViewController ()

@property (nonatomic, strong) GIDSignIn *signIn;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the service object.
    [[GlobalContainer sharedInstance] setService:[[GTLRYouTubeService alloc] init]];
    
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
        [GlobalContainer sharedInstance].service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        [GlobalContainer sharedInstance].service.authorizer = user.authentication.fetcherAuthorizer;
    }
    [self toggleAuthorizeUI];
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
