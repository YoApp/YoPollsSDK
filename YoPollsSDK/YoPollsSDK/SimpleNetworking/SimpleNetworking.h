//
//  SimpleNetworking.h
//  SimpleNetworking
//
//  Created by Bibo on 5/30/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SimpleNetworking : NSObject

@property (nonatomic, strong) NSDictionary *headerFields;

+ (SimpleNetworking *)shared;

typedef NS_ENUM(NSInteger, RESTfulType) {
  RESTfulTypeGET,
  RESTfulTypePOST,
  RESTfulTypePUT,
  RESTfulTypeDELETE
};

+ (void)setHeaderFieldsWithDictionary:(NSDictionary *)dict;

+ (void)setCacheSizeMemoryCapacityInMB:(int)memoryCapacityInMB diskCapacity:(int)diskCapacityInMB;

+ (void)getJsonCachedFromURL:(NSString *)urlString param:(NSDictionary *)param cacheExpireInSeconds:(NSTimeInterval)cacheExpireInSeconds returned:(void (^)(id responseObject, NSError *error))callback;

+ (void)getJsonCachelessFromURL:(NSString *)urlString param:(NSDictionary *)param returned:(void (^)(id responseObject, NSError *error))callback;

+ (void)getImageCachedFromURL:(NSString *)urlString param:(NSDictionary *)param cacheExpireInSeconds:(NSTimeInterval)cacheExpireInSeconds returned:(void (^)(UIImage *responseImage, NSError *error))callback;

+ (void)getImageCachelessFromURL:(NSString *)urlString param:(NSDictionary *)param returned:(void (^)(UIImage *responseImage, NSError *error))callback;

+ (void)postToURL:(NSString *)urlString param:(NSDictionary *)param returned:(void (^)(id responseObject, NSError *error))callback;

+ (void)postImageToURL:(NSString *)urlString param:(NSDictionary *)param imageInNSData:(NSData *)imageInNSData imageName:(NSString *)imageName imageExtension:(NSString *)imageExtension returned:(void (^)(id responseObject, NSError *error))callback;

+ (void)putToURL:(NSString *)urlString param:(NSDictionary *)param returned:(void (^)(id responseObject, NSError *error))callback;

+ (void)deleteFromURL:(NSString *)urlString param:(NSDictionary *)param returned:(void (^)(id responseObject, NSError *error))callback;

@end
