//
//  EgretViewController+location.h
//  Runner
//
//  Created by Paul on 2022/8/18.
//

#import "EgretViewController.h"
#import <BUAdSDK/BUAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface EgretViewController (location)<BUNativeExpressBannerViewDelegate,BUSplashAdDelegate>

/// 加载本地网页
/// - Parameter path: 路径 @"baohuxiaoyang/index.html"
///   - isLandscape: 是否横屏
///   - isBanner: 是否有banner广告
- (void)loadLocation:(NSString *)path isLandscape:(BOOL)isLandscape isBanner:(BOOL)isBanner;

@end

NS_ASSUME_NONNULL_END
