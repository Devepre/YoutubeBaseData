//
//  AppDelegate.h
//  YoutubeBaseData
//
//  Created by User on 3/16/18.
//  Copyright © 2018 DEL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

