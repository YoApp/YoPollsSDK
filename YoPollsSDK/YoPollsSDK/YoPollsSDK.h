//
//  YoPollsSDK.h
//  YoPollsSDK
//
//  Created by mac on 2/4/16.
//  Copyright © 2016 Life Before Us, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YoPollsSDK : NSObject

+ (void)initWithAPIToken:(NSString *)apiToken;

+ (void)askUserForPushPermissions;

@end
