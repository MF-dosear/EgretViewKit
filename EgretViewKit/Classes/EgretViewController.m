//
//  EgretViewController.m
//  Tkitter
//
//  Created by Paul on 2022/9/7.
//  Copyright © 2022 Paul. All rights reserved.
//

#import "EgretViewController.h"
#import "EgretViewController+location.h"
#import "EgretViewController+checkNet.h"
#import "EgretViewController+online.h"
#import "EgretViewController+clearCache.h"
#import "EgretWebViewLib.h"

@interface EgretViewController ()

@property (nonatomic, copy) NSString *name;

@end

@implementation EgretViewController

- (WKWebView *)webView{
    if (_webView == nil) {

        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[WKWebView class]]) {
                _webView = (WKWebView *)view;
                break;
            }
        }
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 检查网络
    [self checkNet];

    // 常亮
    [UIApplication sharedApplication].idleTimerDisabled = true;

    // 加载
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [EgretWebViewLib initialize:@"/egretGame/preload/"];
    });

    // 广告初始化
    BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
    configuration.appID = [[NSBundle mainBundle] infoDictionary][@"AdAppID"]; //除appid外，其他参数配置按照项目实际需求配置即可。
    configuration.secretKey = [[NSBundle mainBundle] infoDictionary][@"AdSecretKey"];
//    configuration.privacyProvider = [[BUDPrivacyProvider alloc] init];//520x版本开始新增canUseWiFiBSSID字段，表示是否获取WiFi BSSID，默认为YES；
    configuration.appLogoImage = [UIImage imageNamed:@"AppIcon"];
    
    [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
//            if (success) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                //请求广告逻辑处理
//                });
//            }
    }];
}

- (BOOL)prefersStatusBarHidden{
    return true;
}

- (void)loadUrl{
    
//    __weak typeof(self) weakself = self;
//    [RSManager apiWithAppleID:AppleID result:^(BOOL isSuccess, NSString * _Nonnull api) {
//        
//        if (isSuccess == true) {
//            [weakself loadOnlineWithApi:api];
//        } else {
//            [weakself loadOnlineWithApi:@"https://sqcdn.ayouhuyu.com/stoneage_shanhai_release/index_ios_xmwioskdbl_https.html?os=ios&pf=xmwioskdbl&td_channelid=xmwioskdbl"];
//        }
//    }];
}

- (void)addFuncName:(NSString *)funcName result:(void (^)(NSString * _Nonnull))result{
    [EgretWebViewLib setExternalInterface:funcName Callback:result];
}

- (void)callFuncName:(NSString *)name value:(NSString *)value{
    [EgretWebViewLib callExternalInterface:name Value:value];
}

@end
