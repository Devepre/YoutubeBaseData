//
//  GlobalContainer.m
//  YoutubeBaseData
//
//  Created by User on 3/29/18.
//  Copyright © 2018 DEL. All rights reserved.
//

#import "GlobalContainer.h"

@implementation GlobalContainer

static GlobalContainer *singleInstance;

+ (void)initialize
{
    if (self == [GlobalContainer class]) {
        singleInstance = [[GlobalContainer alloc] init];
    }
}

+ (GlobalContainer *)sharedInstance {
    return singleInstance;
}

@end
