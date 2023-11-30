//
//  EgretViewController+location.m
//  Runner
//
//  Created by Paul on 2022/8/18.
//

#import "EgretViewController+location.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "EgretWebViewLib.h"
#import <objc/message.h>

@implementation EgretViewController (location)

- (void)setBannerView:(BUNativeExpressBannerView *)bannerView{
    objc_setAssociatedObject(self, @"bannerView", bannerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BUNativeExpressBannerView *)bannerView{
    return objc_getAssociatedObject(self, @"bannerView");
}

- (void)setSplashAd:(BUSplashAd *)splashAd{
    objc_setAssociatedObject(self, @"splashAd", splashAd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BUSplashAd *)splashAd{
    return objc_getAssociatedObject(self, @"splashAd");
}

/// 加载本地网页
/// - Parameter path: 路径 @"baohuxiaoyang/index.html"
///   - isLandscape: 是否横屏
///   - isBanner: 是否有banner广告
- (void)loadLocation:(NSString *)path isLandscape:(BOOL)isLandscape isBanner:(BOOL)isBanner{
    
    [EgretWebViewLib startLocalServerFromResource];
    [EgretWebViewLib startGame:path Host:@"http://locahost" SuperView:self.view];
    
    if (isLandscape){
        [self handerWebView:self.webView];
    }
    
    if (@available(iOS 14, *)) {
        
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
        }];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self showSplashAdv];
    });
    
    if (isBanner){
        [self addBannerAdv];
    }
}

- (void)handerWebView:(WKWebView *)webView{
    // 横屏
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    webView.transform = transform;
    webView.frame = self.view.bounds;
    
    // 代理
//    webView.UIDelegate = self;
//    webView.navigationDelegate = self;
//    webView.scrollView.scrollEnabled = false;
}

#pragma mark -- banner
- (void)addBannerAdv{
    
    NSString *SlotID;
    CGFloat sp = 0.15;
    CGSize size_v = [UIScreen mainScreen].bounds.size;
    CGFloat rote = size_v.height / size_v.width;
    if (rote > 1.78) {
        SlotID = [[NSBundle mainBundle] infoDictionary][@"AdBannerID2"];
        sp = 0.33;
    } else {
        SlotID = [[NSBundle mainBundle] infoDictionary][@"AdBannerID1"];
        sp = 0.13;
    }

    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = w * 0.32;
    CGSize size = CGSizeMake(w, h);
    BUNativeExpressBannerView *bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:SlotID rootViewController:self adSize:(CGSize)size];

    bannerView.delegate = self;
    [bannerView loadAdData];
    
    self.bannerView = bannerView;
    self.bannerView.frame = CGRectMake(0, self.view.bounds.size.height - h, w, h);
    [self.view addSubview:bannerView];
}

#pragma mark -- BUNativeExpressBannerViewDelegate
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView{
    
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error{
    
}

/// 展示开屏广告
- (void)showSplashAdv{
    
    NSString *AdvSplashID = [[NSBundle mainBundle] infoDictionary][@"AdvSplashID"];
    self.splashAd = [[BUSplashAd alloc] initWithSlotID:AdvSplashID adSize:self.view.frame.size];
    // 设置开屏广告代理
    self.splashAd.delegate = self;
    // 加载广告
    [self.splashAd loadAdData];
}

#pragma mark -- BUSplashAdDelegate
- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *)error{
    
}

- (void)splashAdLoadSuccess:(BUSplashAd *)splashAd{
    
}


@end
