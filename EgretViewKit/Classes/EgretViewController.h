//
//  EgretViewController.h
//  Tkitter
//
//  Created by Paul on 2022/9/7.
//  Copyright © 2022 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EgretViewController : UIViewController

/// 网页webView
@property (nonatomic, strong) WKWebView *webView;

/// 链接
@property (nonatomic, copy) NSString *api;

/// 是否加载成功
@property (nonatomic, assign) BOOL isDidLoadWK;

/// 是否初始化
@property (nonatomic, assign) BOOL isInit;

/// 加载链接
- (void)loadUrl;

/// 加载本地网页
/// - Parameter path: 路径 @"baohuxiaoyang/index.html"
///   - isLandscape: 是否横屏
///   - isBanner: 是否有banner广告
- (void)loadLocation:(NSString *)path isLandscape:(BOOL)isLandscape isBanner:(BOOL)isBanner;

/// 加载线上网页
/// - Parameter api: api
- (void)loadOnlineWithApi:(NSString *)api;

/**
 清理缓存
 */
- (void)clearCache;

/// 添加交互事件
- (void)addFuncName:(NSString *)funcName result:(void(^)(NSString *msg))result;

/// 调用js
/// - Parameters:
///   - name: name
///   - value: value
- (void)callFuncName:(NSString *)name value:(NSString *)value;

/// 未实现
- (void)addFucns;

/// 初始化SDK
- (void)sdkInit;

/// 登录
- (void)sdkLogin;

/// 支付
/// - Parameter params: 参数
- (void)sdkPsy:(NSDictionary *)params;

/// 上传角色
/// - Parameter params: 参数
- (void)sdkSubmitRoleInfo:(NSDictionary *)params;

/// 登出
/// - Parameter flag: 是否弹出登录框
- (void)sdkLoginOut:(BOOL)flag;

/// 分享
/// - Parameter params: 参数
- (void)sdkShareWithMessage:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
