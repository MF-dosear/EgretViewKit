//
//  EgretViewController+online.h
//  LatterCarp
//
//  Created by 程小康 on 2021/11/25.
//  Copyright © 2021 黄飞鸿. All rights reserved.
//

#import "EgretViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EgretViewController (online)<WKNavigationDelegate,WKUIDelegate>

- (void)loadOnlineWithApi:(NSString *)api;

@end

NS_ASSUME_NONNULL_END
