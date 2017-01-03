//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"

@interface GesturePasswordController : UIViewController <VerificationDelegate,ResetDelegate,GesturePasswordDelegate, ChangeDelegate, UIAlertViewDelegate>

- (void)clear;

- (BOOL)exist;

@property (nonatomic, assign) BOOL canChangeVC;//点击返回可能有两个操作:1.跳转界面 2.显示左右button 所以这里要设置标志位判断一下

@end
