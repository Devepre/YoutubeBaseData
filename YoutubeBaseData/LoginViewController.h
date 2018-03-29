//https://developers.google.com/identity/sign-in/ios/start-integrating
//https://github.com/googlesamples/google-services/tree/master/ios/signin

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRYouTube.h>

@interface LoginViewController : UIViewController <GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton        *signOutButton;
@property (weak, nonatomic) IBOutlet UIButton        *disconnectButton;
@property (weak, nonatomic) IBOutlet UILabel         *statusText;
@property (weak, nonatomic) IBOutlet UIButton        *leaveCommentButton;

@end
