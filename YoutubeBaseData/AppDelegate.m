//
//  AppDelegate.m
//  YoutubeBaseData
//
//  Created by User on 3/16/18.
//  Copyright © 2018 DEL. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalContainer.h"

@interface AppDelegate ()

@property (nonatomic, strong) GIDSignIn *signIn;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Initialize the service object.
    [[GlobalContainer sharedInstance] setService:[[GTLRYouTubeService alloc] init]];
    
    // Configure Google Sign-in.
    self.signIn = [GIDSignIn sharedInstance];
    self.signIn.delegate = self;
    self.signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeYouTubeForceSsl, nil];
    [self.signIn signInSilently];
    
    return YES;
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error) {
        NSLog(@"Error Sign in: %@", error.localizedDescription);
        [GlobalContainer sharedInstance].service.authorizer = nil;
    } else {
        [GlobalContainer sharedInstance].service.authorizer = user.authentication.fetcherAuthorizer;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification"
                                                            object:nil
                                                          userInfo:nil];
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    NSLog(@"USER DISCONNECT");
    [GlobalContainer sharedInstance].service.authorizer = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification"
                                                        object:nil
                                                      userInfo:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

@end
