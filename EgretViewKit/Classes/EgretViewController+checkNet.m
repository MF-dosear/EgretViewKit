//
//  EgretViewController+checkNet.m
//  LatterCarp
//
//  Created by 程小康 on 2021/11/25.
//  Copyright © 2021 黄飞鸿. All rights reserved.
//

#import "EgretViewController+checkNet.h"
#import <AFNetworking/AFNetworking.h>

@implementation EgretViewController (checkNet)

- (void)checkNet{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        if (status == 1 || status == 2) {
            // 有网，重新加载
            if (self.isDidLoadWK == false) {
                [self loadUrl];
                self.isDidLoadWK = true;
            }
            UIViewController *vc = self;
            if ([vc isKindOfClass:[UIAlertController class]]) {
                UIAlertController *alert = (UIAlertController *)vc;
                if ([alert.title isEqualToString:@"网络异常"]) {
                    [alert dismissViewControllerAnimated:true completion:nil];
                }
            }
        } else {
            // 没网，展示拦截页
            [self alert];
        }
    }];
    [manager startMonitoring];
}

- (void)alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"您的当前网络存在异常，请去检查网络" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:true completion:nil];
}


@end
