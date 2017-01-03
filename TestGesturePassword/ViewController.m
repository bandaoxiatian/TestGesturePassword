//
//  ViewController.m
//  TestGesturePassword
//
//  Created by liguoqiang on 17/1/3.
//  Copyright © 2017年 liguoqiang. All rights reserved.
//

#import "ViewController.h"
//#import "DEFINE.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    kScreenWidth;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"欢迎登陆" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.backgroundColor = [UIColor colorWithRed:2/255.f green:174/255.f  blue:240/255.f alpha:1];
    btn.backgroundColor = [UIColor colorWithRed:208/255.f green:36/255.f  blue:36/255.f alpha:1];
    [btn setFrame:CGRectMake(kScreenWidth/2 - 50, kScreenHeight/2 - 50, 100, 100)];
    [self.view addSubview:btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
