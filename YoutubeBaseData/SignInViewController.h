#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRYouTube.h>

@interface SignInViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) IBOutlet GIDSignInButton  *signInButton;
@property (weak, nonatomic) IBOutlet UIButton           *signOutButton;
@property (weak, nonatomic) IBOutlet UIButton           *disconnectButton;
@property (weak, nonatomic) IBOutlet UILabel            *statusLabel;

@end
