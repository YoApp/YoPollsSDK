//
//  SimpleNetworking.m
//  SimpleNetworking
//
//  Created by Bibo on 5/30/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import "SimpleNetworking.h"

@interface SimpleNetworking () <NSURLSessionDelegate>
{
  NSURLSession *session;
  NSMutableDictionary *allNetworkCacheURLs;
}

@end

@implementation SimpleNetworking

+ (SimpleNetworking *)shared {
  static SimpleNetworking *shared;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[[self class] alloc] init];
  });
  return shared;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.headerFields = [NSDictionary new];
    
    [SimpleNetworking setCacheSizeMemoryCapacityInMB:320 diskCapacity:640];
    session =
    [NSURLSession sessionWithConfiguration:
     [NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:self
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    [self setupCaching];
  }
  return self;
}

+(void)setHeaderFieldsWithDictionary:(NSDictionary *)dict {
  [self shared].headerFields = dict;
}

+ (void)setCacheSizeMemoryCapacityInMB:(int)memoryCapacityInMB diskCapacity:(int)diskCapacityInMB {
  int memoryCapacity = memoryCapacityInMB*1024*1024;
  int diskCapacity = diskCapacityInMB*1024*1024;
  [NSURLCache setSharedURLCache:[[NSURLCache alloc]initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:nil]];
}

+ (void)getJsonCachedFromURL:(NSString *)urlString param:(NSDictionary *)param cacheExpireInSeconds:(NSTimeInterval)cacheExpireInSeconds returned:(void (^)(id responseObject, NSError *error))callback {
  [[self shared] callNSURLSessionWithType:RESTfulTypeGET url:urlString param:param isCached:YES cacheExpireInSeconds:cacheExpireInSeconds isImage:NO imageName:@"" imageExtension:@"" imageInNSData:nil returned:^(NSData *data, NSError *error) {
    if (error) {
      callback (nil, error);
    }
    else {
      NSError *jsonError;
      callback([NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:&jsonError], nil);
    }
  }];
}

+ (void)getJsonCachelessFromURL:(NSString *)urlString
                          param:(NSDictionary *)param
                       returned:(void (^)(id responseObject,
                                          NSError *error))callback {
  [[self shared] callNSURLSessionWithType:RESTfulTypeGET url:urlString param:param isCached:NO cacheExpireInSeconds:0 isImage:NO imageName:@"" imageExtension:@"" imageInNSData:nil returned:^(NSData *data, NSError *error) {
    if (error) {
      callback (nil, error);
    }
    else {
      NSError *jsonError;
      callback([NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:&jsonError], nil);
    }
  }];
}

+(void)getImageCachedFromURL:(NSString *)urlString param:(NSDictionary *)param cacheExpireInSeconds:(NSTimeInterval)cacheExpireInSeconds returned:(void (^)(UIImage *, NSError *))callback {
  [[self shared] callNSURLSessionWithType:RESTfulTypeGET url:urlString param:param isCached:YES cacheExpireInSeconds:cacheExpireInSeconds isImage:NO imageName:@"" imageExtension:@"" imageInNSData:nil returned:^(NSData *data, NSError *error) {
    if (error) {
      callback (nil, error);
    }
    else {
      callback ([UIImage imageWithData:data], nil);
    }
  }];
}

+ (void)getImageCachelessFromURL:(NSString *)urlString param:(NSDictionary *)param returned:(void (^)(UIImage *responseImage, NSError *error))callback {
  [[self shared] callNSURLSessionWithType:RESTfulTypeGET url:urlString param:param isCached:NO cacheExpireInSeconds:0 isImage:NO imageName:@"" imageExtension:@"" imageInNSData:nil returned:^(NSData *data, NSError *error) {
    if (error) {
      callback (nil, error);
    }
    else {
      callback ([UIImage imageWithData:data], nil);
    }
  }];
}

+(void)postToURL:(NSString *)urlString param:(NSDictionary *)param returned:(void (^)(id, NSError *))callback {
  [[self shared] callNSURLSessionWithType:RESTfulTypePOST url:urlString param:param isCached:NO cacheExpireInSeconds:0 isImage:NO imageName:@"" imageExtension:@"" imageInNSData:nil returned:^(NSData *data, NSError *error) {
    if (error) {
      callback (nil, error);
    }
    else {
      NSError *jsonError;
      callback([NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:&jsonError], nil);
    }
  }];
}

+(void)postImageToURL:(NSString *)urlString param:(NSDictionary *)param imageInNSData:(NSData *)imageInNSData imageName:(NSString *)imageName imageExtension:(NSString *)imageExtension returned:(void (^)(id, NSError *))callback {
  [[self shared] callNSURLSessionWithType:RESTfulTypePOST url:urlString param:param isCached:NO cacheExpireInSeconds:0 isImage:YES imageName:imageName imageExtension:imageExtension imageInNSData:imageInNSData returned:^(NSData *data, NSError *error) {
    if (error) {
      callback (nil, error);
    }
    else {
      NSError *jsonError;
      callback([NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:&jsonError], nil);
    }
  }];
}

+(void)putToURL:(NSString *)urlString param:(NSDictionary *)param returned:(void (^)(id, NSError *))callback {
  [[self shared] callNSURLSessionWithType:RESTfulTypePUT url:urlString param:param isCached:NO cacheExpireInSeconds:0 isImage:NO imageName:@"" imageExtension:@"" imageInNSData:nil returned:^(NSData *data, NSError *error) {
    if (error) {
      callback (nil, error);
    }
    else {
      NSError *jsonError;
      callback([NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:&jsonError], nil);
    }
  }];
}

+(void)deleteFromURL:(NSString *)urlString param:(NSDictionary *)param returned:(void (^)(id, NSError *))callback {
  [[self shared] callNSURLSessionWithType:RESTfulTypePUT url:urlString param:param isCached:NO cacheExpireInSeconds:0 isImage:NO imageName:@"" imageExtension:@"" imageInNSData:nil returned:^(NSData *data, NSError *error) {
    if (error) {
      callback (nil, error);
    }
    else {
      NSError *jsonError;
      callback([NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:&jsonError], nil);
    }
  }];
}

-(void)callNSURLSessionWithType:(RESTfulType)type url:(NSString *)urlString param:(NSDictionary *)param isCached:(BOOL)isCached cacheExpireInSeconds:(NSTimeInterval)cacheExpireInSeconds isImage:(BOOL)isImage imageName:(NSString *)imageName imageExtension:(NSString *)imageExtension imageInNSData:(NSData *)imageInNSData returned:(void (^)(NSData *data, NSError *error))callback {
  urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  [request setHTTPMethod:[self getRESTfulTypeStringForType:type]];
  
  if (self.headerFields.allKeys.count > 0) {
    for (int i = 0; i < (int)self.headerFields.allKeys.count; i++) {
      [request setValue:self.headerFields.allValues[i] forHTTPHeaderField:self.headerFields.allKeys[i]];
    }
  }

  if (type == RESTfulTypePUT || type == RESTfulTypeDELETE) {
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  }
  
  NSMutableData *jsonData = [NSMutableData data];
  
  if (isImage && type==RESTfulTypePOST) {
    NSString *boundary = @"uniqueNetworkingBoundary";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [jsonData appendData:[NSJSONSerialization dataWithJSONObject:@{@"":@""} options:0 error:nil]];
    
    [jsonData appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [jsonData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [jsonData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.%@\"\r\n", imageName, imageExtension] dataUsingEncoding:NSUTF8StringEncoding]];
    [jsonData appendData:[[NSString stringWithFormat:@"Content-Type: image/%@\r\n\r\n",imageExtension] dataUsingEncoding:NSUTF8StringEncoding]];
    [jsonData appendData:imageInNSData];
    [jsonData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [jsonData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = jsonData;
  }

  if (type != RESTfulTypeGET && param) {
    [jsonData appendData:[[self getParamInString:param] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = jsonData;
  }

  if (isCached) {
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    if ([allNetworkCacheURLs.allKeys containsObject:urlString]) {
      NSString *expirationTime = [NSString stringWithFormat:@"%@", allNetworkCacheURLs[urlString]];
      NSDate *expirationDate = [self getNSDateFromNSString:expirationTime whichIsInFormat:@"MMM dd yyyy HH:mm:ss:SSSS"];
      if ([self isPastTime:expirationDate]) {
        cachedResponse = nil;
      }
    }
    NSString *expireTime = [self getNSStringFromNSDate:[self addSeconds:cacheExpireInSeconds toNSDate:[NSDate date]] withFormat:@"MMM dd yyyy HH:mm:ss:SSSS"];
    [allNetworkCacheURLs setObject:expireTime forKey:urlString];

    if (cachedResponse.data) {
      callback(cachedResponse.data, nil);
      return;
    }
    else {
      [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
          callback(nil, error);
        } else {
          callback(data, nil);
          [[NSURLCache sharedURLCache] storeCachedResponse:[[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed] forRequest:request];
        }
      }] resume];
    }
  }
  else {
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        callback(nil, error);
      } else {
        callback(data, nil);
      }
    }] resume];
  }
}

- (NSString *)getRESTfulTypeStringForType:(RESTfulType)type {
  NSString *typeString = @"GET";
  if (type == RESTfulTypePUT) {
    typeString = @"PUT";
  }
  else if (type == RESTfulTypePOST) {
    typeString = @"POST";
  }
  else if (type == RESTfulTypeDELETE) {
    typeString = @"DELETE";
  }
  return typeString;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (BOOL)archive:(NSDictionary *)dict withKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = nil;
    if (dict) {
        data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    }
    [defaults setObject:data forKey:key];
    return [defaults synchronize];
}

- (NSDictionary *)unarchiveForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    NSDictionary *userDict = nil;
    if (data) {
        userDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return userDict;
}

-(NSString *)getParamInString:(NSDictionary *)param {
    NSMutableArray *parts = [NSMutableArray array];
    [param enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj != [NSNull null]) {
            [parts addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSString *addString = [parts componentsJoinedByString:@"&"];
    return addString;
}

-(void)setupCaching {
  if ([[NSUserDefaults standardUserDefaults]dictionaryForKey:@"SimpleNetworkingStoredCacheURLs"]) {
    allNetworkCacheURLs = [[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"SimpleNetworkingStoredCacheURLs"] mutableCopy];
  }
  else {
    allNetworkCacheURLs = [NSMutableDictionary new];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(saveCacheListToUserDefault)
                                               name:UIApplicationWillResignActiveNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(saveCacheListToUserDefault)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(saveCacheListToUserDefault)
                                               name:UIApplicationWillTerminateNotification
                                             object:nil];
  
}

-(void)saveCacheListToUserDefault {
  [[NSUserDefaults standardUserDefaults]setObject:allNetworkCacheURLs forKey:@"networkingStoredCache"];
  [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *) getNSStringFromNSDate:(NSDate *)date withFormat:(NSString *)format
{
    return [self selfFormatNSDate:date toStringWithFormat:format];
}

-(NSDate *) getNSDateFromNSString: (NSString *)dateString whichIsInFormat:(NSString *)format
{
    return [self selfGetNSDateFromString:dateString whichIsInFormat:format];
}

-(NSDate *) selfGetNSDateFromString:(NSString *)timeString whichIsInFormat:(NSString *)format
{
    NSDateFormatter *inputStringFormatter = [[NSDateFormatter alloc] init];
    [inputStringFormatter setDateFormat:format];
    NSDate *dateFromInputString = [[NSDate alloc] init];
    dateFromInputString = [inputStringFormatter dateFromString:timeString];
    
    return dateFromInputString;
}

-(NSString *) selfFormatNSDate:(NSDate *)date toStringWithFormat:(NSString *)format
{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:format];
    NSString *inputFormatString = [inputDateFormatter stringFromDate:date];
    
    return inputFormatString;
}

-(NSDate *) addSeconds:(int)seconds toNSDate:(NSDate *)date
{
    NSDate *newDate = [date dateByAddingTimeInterval:seconds];
    return newDate;
}

- (BOOL)isPastTime:(NSDate *) compareDate
{
    NSString *todayDateString = [self getCurrentTimeInNSStringWithFormat:@"MMM dd yyyy HH:mm:ss:SSSS"];
    NSDate *todayDate = [self selfGetNSDateFromString:todayDateString whichIsInFormat:@"MMM dd yyyy HH:mm:ss:SSSS"];
    
    return compareDate < todayDate;
}

- (NSString *) getCurrentTimeInNSStringWithFormat:(NSString *)format
{
    NSString *string = [self selfFormatNSDate:[NSDate date] toStringWithFormat:format];
    return string;
}

@end
