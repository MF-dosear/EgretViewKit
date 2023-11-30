//
//  EgretViewController+clearCache.m
//  LatterCarp
//
//  Created by 程小康 on 2021/11/25.
//  Copyright © 2021 黄飞鸿. All rights reserved.
//

#import "EgretViewController+clearCache.h"

@implementation EgretViewController (clearCache)

/**
 清理缓存
 */
- (void)clearCache{
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >8) {
        if (@available(iOS 9.0, *)) {
            NSArray * types = @[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
            NSSet *websiteDataTypes = [NSSet setWithArray:types];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                
            }];
        }
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}


@end
