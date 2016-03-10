//
//  YoPollsSDK.m
//  YoPollsSDK
//
//  Created by mac on 2/4/16.
//  Copyright © 2016 Life Before Us, Inc. All rights reserved.
//

#import "YoPollsSDK.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "SimpleNetworking.h"

//#define BASE_URL @"https://api.justyo.co/"
#define BASE_URL @"http://yo.ngrok.io/"

static NSString *appToken = nil;

@interface YoPollsSDK ()

@end

@implementation YoPollsSDK

+ (void)initWithAPIToken:(NSString *)apiToken {
    (void)[[self sharedInstance] initWithAPIToken:apiToken];
}

+ (instancetype)sharedInstance {
    static YoPollsSDK *_sharedInstance = nil;
    static dispatch_once_t once_predicate;
    dispatch_once(&once_predicate, ^{
        _sharedInstance = [[YoPollsSDK alloc] init];
        [_sharedInstance swizzle];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    });
    return _sharedInstance;
}

- (id)initWithAPIToken:(NSString *)apiToken {
    if (self = [super init]) {
        appToken = apiToken;
    }
    return self;
}

+ (void)askUserForPushPermissions {
    [[self sharedInstance] askUserForPushPermissions];
}

- (void)askUserForPushPermissions {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"No"];
        [action1 setIdentifier:@"No"];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"Yes"];
        [action2 setIdentifier:@"Yes"];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:@"No.Yes"];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        
        UIUserNotificationType types = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }
}

#pragma mark - API Calls

//- (void)fetchPollsWithCompletionBlock:() {

//}

#pragma mark -

/*
 *  1. -application:didRegisterForRemoteNotificationsWithDeviceToken:
 *  2. -application:didFailToRegisterForRemoteNotificationsWithError:
 *  3. -application:didReceiveRemoteNotification:
 *  4. -application:didReceiveRemoteNotification:fetchCompletionHandler:
 */

- (void)swizzle {
    
    Class class = [[[UIApplication sharedApplication] delegate] class];
    
    SEL originalSelector = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
    SEL swizzledSelector = @selector(yp_application:didRegisterForRemoteNotificationsWithDeviceToken:);
    
    [self swizzleMethodForClass:class originalSelector:originalSelector swizzledSelector:swizzledSelector];
    
    originalSelector = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
    swizzledSelector = @selector(yp_application:didFailToRegisterForRemoteNotificationsWithError:);
    
    [self swizzleMethodForClass:class originalSelector:originalSelector swizzledSelector:swizzledSelector];
    
    originalSelector = @selector(application:didReceiveRemoteNotification:);
    swizzledSelector = @selector(yp_application:didReceiveRemoteNotification:);
    
    [self swizzleMethodForClass:class originalSelector:originalSelector swizzledSelector:swizzledSelector];
    
    originalSelector = @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:);
    swizzledSelector = @selector(yp_application:didReceiveRemoteNotification:fetchCompletionHandler:);
    
    [self swizzleMethodForClass:class originalSelector:originalSelector swizzledSelector:swizzledSelector];
    
    originalSelector = @selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:);
    swizzledSelector = @selector(yp_application:handleActionWithIdentifier:forRemoteNotification:completionHandler:);
    
    [self swizzleMethodForClass:class originalSelector:originalSelector swizzledSelector:swizzledSelector];
    
}

- (void)swizzleMethodForClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    Method emptyMethod = class_getInstanceMethod([self class], @selector(empty));
    
    // Try to add application:didRegisterForRemoteNotificationsWithDeviceToken: to app delegate class
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    // If it was added,
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(emptyMethod),
                            method_getTypeEncoding(emptyMethod));
    } else {
        class_addMethod(class,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
        
        class_replaceMethod(class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
    }
}

#pragma mark - Method Swizzling

- (void)yp_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    
    [self yp_application:application didRegisterForRemoteNotificationsWithDeviceToken:newDeviceToken];
    
    NSString *deviceToken = [[[[newDeviceToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (deviceToken) {
        params[@"push_token"] = deviceToken;
        params[@"app_token"] = @"co.justyo.polls.ios.sdk.test";//appToken;
        
        [SimpleNetworking postToURL:[NSString stringWithFormat:@"%@%@", BASE_URL, @"polls/devices/"]
                              param:params
                           returned:^(id responseObject, NSError *error) {
                               
                           }];
    }
}

- (void)empty {
    
}


- (void)yp_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // do something
    [self yp_application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)yp_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // do something
    [self yp_application:application didReceiveRemoteNotification:userInfo];
}

- (void)yp_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    [self yp_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    // do something
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)yp_application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
    [self yp_application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
    // do something
    
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
