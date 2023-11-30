//
//  EgretViewController+online.m
//  LatterCarp
//
//  Created by 程小康 on 2021/11/25.
//  Copyright © 2021 黄飞鸿. All rights reserved.
//

#import "EgretViewController+online.h"
#import "EgretWebViewLib.h"

@implementation EgretViewController (online)

- (void)loadOnlineWithApi:(NSString *)api{
    
    self.api = api;
    
    // 启动游戏
    [EgretWebViewLib startGame:api SuperView:self.view];
    
    // 代理
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    // 添加事件
    [self addFucns];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURL *URL = navigationAction.request.URL;
    
    if ([URL.absoluteString isEqualToString:self.api]) {
        
        // 登出
        [self sdkLoginOut:false];
    }
    
    //判断URL是否符合自定义的URL Scheme
    if (![URL.scheme isEqualToString:@"https"] && ![URL.scheme isEqualToString:@"http"])
    {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @(false)};
        [[UIApplication sharedApplication] openURL:URL options:options completionHandler:nil];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

#pragma mark - WKNavigationDelegate0
// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    self.isDidLoadWK = true;

    NSString *jsStr = [NSString stringWithFormat:@"document.getElementById(\"txt\").innerHTML=\"%@\";",[[NSBundle mainBundle] infoDictionary][@"CFBundleName"]];

    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {

        NSLog(@"%@--%@",result,error);
    }];
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    self.isDidLoadWK = false;
}


@end
