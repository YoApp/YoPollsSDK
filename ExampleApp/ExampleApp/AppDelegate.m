//
//  AppDelegate.m
//  ExampleApp
//
//  Created by mac on 2/4/16.
//  Copyright © 2016 Life Before Us, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <YoPollsSDK/YoPollsSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [YoPollsSDK initWithAPIToken:@""];
    
    return YES;
}

@end
