//
//  GlobalContainer.h
//  YoutubeBaseData
//
//  Created by User on 3/29/18.
//  Copyright © 2018 DEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GTLRYouTube.h>

@interface GlobalContainer : NSObject

@property (strong, nonatomic) GTLRYouTubeService *service;

+ (GlobalContainer *)sharedInstance;

@end
