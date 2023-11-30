//
//  YXViewController.m
//  EgretViewKit
//
//  Created by 564057354@qq.com on 11/30/2023.
//  Copyright (c) 2023 564057354@qq.com. All rights reserved.
//

#import "YXViewController.h"
#import <RSDK/RSDK.h>
#import "Config.h"

@interface YXViewController ()<RSDelegate>

@end

@implementation YXViewController

// 加载页面
- (void)loadUrl{
    __weak typeof(self) weakself = self;
    [RSManager apiWithAppleID:AppleID result:^(BOOL isSuccess, NSString * _Nonnull api) {
        
        if (isSuccess == true) {
            [weakself loadOnlineWithApi:api];
        } else {
            [weakself loadLocation:@"" isLandscape:false isBanner:true];
        }
    }];
}

// 添加交互事件
- (void)addFucns{
    __weak typeof(self) weakself = self;
    [self addFuncName:@"sendToNative" result:^(NSString * _Nonnull msg) {
        
        NSLog(@"邹涛: %@", msg);
    }];
    
    [self addFuncName:@"regsuccess" result:^(NSString * _Nonnull msg) {
        
        [weakself sdkInit];
    }];
    
    [self addFuncName:@"login" result:^(NSString * _Nonnull msg) {
        
        [weakself sdkLogin];
    }];
    
    [self addFuncName:@"loadComplete" result:^(NSString * _Nonnull msg) {
        
//        NSLog(@"message: %@", msg);
    }];
    
    [self addFuncName:@"pay" result:^(NSString * _Nonnull msg) {
        
        NSDictionary *info = [msg jk_dictionaryValue];
        [weakself sdkPsy:info];
    }];
    
    [self addFuncName:@"upRole" result:^(NSString * _Nonnull msg) {

        NSDictionary *info = [msg jk_dictionaryValue];
        [weakself sdkSubmitRoleInfo:info];
    }];
    
    [self addFuncName:@"shareInfo" result:^(NSString * _Nonnull msg) {
        
        NSDictionary *info = [msg jk_dictionaryValue];
        [weakself sdkShareWithMessage:info];
    }];
    
    [self addFuncName:@"loginout" result:^(NSString * _Nonnull msg) {
        
        [weakself sdkLoginOut:true];
    }];
    
    [self addFuncName:@"bindPhone" result:^(NSString * _Nonnull msg) {
        
        [RSManager bindPhone];
    }];
    
    [self addFuncName:@"sdkEvent" result:^(NSString * _Nonnull msg) {
        
        NSDictionary *info = [msg jk_dictionaryValue];
        
        NSString *eventName = info.allKeys.firstObject;
        [RSManager uploadEvent:eventName properties:msg];
    }];
    
    [self addFuncName:@"sdkToBrowser" result:^(NSString * _Nonnull msg) {
        
        [RSManager openUrl:msg];
    }];
}

/// 初始化SDK
- (void)sdkInit{
        if (self.isInit) {
    
            [self callFuncName:@"initSuccess" value:@"initSuccess"];
            return;
        }

        RSInfos *info = [RSInfos sharedRSInfos];
        info.AppID  = SuperID;
        info.AppKey = SuperKey;

        info.OneLoginAppID = OneLoginAppID;
        info.link_suffix = LINK;
        
        info.AppleID = AppleID;

        [RSManager sdkInitWithInfo:info delegate:self];
}

/// 登录
- (void)sdkLogin{
    // 登录
    [RSManager sdkLoginWithAuto:true];
}

/// 支付
/// - Parameter params: 参数
- (void)sdkPsy:(NSDictionary *)params{
    RSInfos *info = [RSInfos sharedRSInfos];

    info.serverID    = [NSString stringWithFormat:@"%@",params[@"serverId"]];
    info.roleID      = [NSString stringWithFormat:@"%@",params[@"roleID"]];
    info.serverName  = [NSString stringWithFormat:@"%@",params[@"serverName"]];
    info.roleName    = [NSString stringWithFormat:@"%@",params[@"roleName"]];
    info.psyLevel    = [NSString stringWithFormat:@"%@",params[@"payLevel"]];
    info.roleLevel   = [NSString stringWithFormat:@"%@",params[@"roleLevel"]];

    info.cpOrder    = [NSString stringWithFormat:@"%@",params[@"cpOrder"]];
    info.price       = [NSString stringWithFormat:@"%@",params[@"price"]];
    info.goodsID    = [NSString stringWithFormat:@"%@",params[@"goodsId"]];
    info.goodsName  = [NSString stringWithFormat:@"%@",params[@"goodsName"]];

    [RSManager sdkPsy:info];
}

/// 上传角色
/// - Parameter params: 参数
- (void)sdkSubmitRoleInfo:(NSDictionary *)params{
    RSInfos *info = [RSInfos sharedRSInfos];

    info.roleName  = [NSString stringWithFormat:@"%@",params[@"roleName"]];
    info.roleID = [NSString stringWithFormat:@"%@",params[@"roleID"]];

    info.roleLevel  = [NSString stringWithFormat:@"%@",params[@"roleLevel"]];
    info.psyLevel = [NSString stringWithFormat:@"%@",params[@"payLevel"]];

    info.serverName  = [NSString stringWithFormat:@"%@",params[@"serverName"]];
    info.serverID = [NSString stringWithFormat:@"%@",params[@"serverId"]];

    [RSManager sdkSubmitRole:info];
}

/// 登出
/// - Parameter flag: 是否弹出登录框
- (void)sdkLoginOut:(BOOL)flag{
    // 退出SDK
    [RSManager sdkLoginOutBackFlag:flag];
}

/// 分享
/// - Parameter params: 参数
- (void)sdkShareWithMessage:(NSDictionary *)params{
    // 4 qq 5 wechat
    YXGAMEShareMode mode;
    NSString *type = params[@"type"];
    
    //  ([type isEqualToString:@"wx"])
    if ([type isEqualToString:@"qq"]){
        
        mode = YXGAMEShareModeQQ;
    } else {
        
        mode = YXGAMEShareModeWX;
    }
    
    NSString *url = params[@"url"];
    NSString *base64 = params[@"base64Image"];
    if (base64.length > 0) {
        
        NSURL *url = [NSURL URLWithString:base64];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [RSManager sdkShareWithMode:mode data:data];
        
    } else if (url.length > 0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [RSManager sdkShareWithMode:mode data:data];
            });
        });
    }
}

#pragma mark -- HRDelegate
- (void)sdkInitResult:(BOOL)flag{
    
    if (flag) {
        
        self.isInit = true;
        
        [self callFuncName:@"initSuccess" value:@"initSuccess"];
    }
}

- (void)sdkLoginResult:(BOOL)flag userID:(NSString *)userID userName:(NSString *)userName session:(NSString *)session{
    
    if (flag) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict addValue:userName key:@"username"];
        [dict addValue:userID key:@"uid"];
        [dict addValue:session key:@"session"];

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        [self callFuncName:@"loginSuccess" value:jsonString];
    }
}

- (void)sdkSubmitRoleResult:(BOOL)flag{

}

- (void)sdkPsyResult:(BOOL)flag{

}

- (void)sdkLoginOutResult:(BOOL)flag{
    [self callFuncName:@"changeUserSuccess" value:@"changeUserSuccess"];
}

@end
