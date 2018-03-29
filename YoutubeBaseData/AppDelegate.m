//
//  AppDelegate.m
//  YoutubeBaseData
//
//  Created by User on 3/16/18.
//  Copyright © 2018 DEL. All rights reserved.
//

#import "AppDelegate.h"
#import <GTLRYouTube.h> //for scopes

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.clientID = @"405503343976-d1bppmkerltkgi2lg3i83d7iujdqb214.apps.googleusercontent.com";
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeYouTubeForceSsl, @"https://www.googleapis.com/auth/plus.login", nil];
    signIn.delegate = self;*/

    // Use Firebase library to configure APIs
    [FIRApp configure];

    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].scopes = [NSArray arrayWithObjects:kGTLRAuthScopeYouTubeForceSsl, nil];
    [GIDSignIn sharedInstance].delegate = self;

    return YES;
}

#pragma mark - Added Methods
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
   /*
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;

    NSDictionary *statusText = @{@"googleUser":user};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification"
                                                        object:nil
                                                      userInfo:statusText];*/

    if (error == nil) {
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];

        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      if (error) {
                                          NSLog(@"Error %@", error);
                                          return;
                                      }
                                      // User successfully signed in. Get user data from the FIRUser object
                                      NSLog(@"Success");
//                                      [self leaveComment];
                                  }];

        NSDictionary *statusText = @{@"googleUser":user};
//        NSDictionary *statusText = @{@"statusText": [NSString stringWithFormat:@"Signed in user: %@", fullName]};
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ToggleAuthUINotification"
         object:nil
         userInfo:statusText];
    } else {
        NSLog(@"ERROR %@", error);
    }
}

// This callback is triggered after the disconnect call that revokes data access to the user's resources has completed.
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.

    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

/*
- (void)leaveComment {
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
//    service.APIKey = apiKey;
    [service executeQuery:query completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
        NSLog(@"object: %@\nError: %@", object, callbackError);
    }];
}*/

@end
