//
//  DEFINE.h
//  TestGesturePassword
//
//  Created by liguoqiang on 17/1/3.
//  Copyright © 2017年 liguoqiang. All rights reserved.
//

#ifndef DEFINE_h
#define DEFINE_h

//设备宽高
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height


#define kInitialStrokeColor [UIColor colorWithRed:1 green:1  blue:1 alpha:1]

// 线条&实心圆颜色
#define kSuccessStrokeColor [UIColor colorWithRed:2/255.f green:174/255.f  blue:240/255.f alpha:1]
#define kFailureStrokeColor [UIColor colorWithRed:208/255.f green:36/255.f  blue:36/255.f alpha:1]

// 半透明圆颜色
#define kSuccessFillColor [UIColor colorWithRed:30/255.f green:175/255.f blue:235/255.f alpha:0.3]
#define kFailureFillColor [UIColor colorWithRed:208/255.f green:36/255.f  blue:36/255.f alpha:0.3]

#endif /* DEFINE_h */
