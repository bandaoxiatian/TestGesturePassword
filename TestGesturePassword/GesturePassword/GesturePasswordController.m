//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

#import "GesturePasswordController.h"


#import "KeychainItemWrapper.h"

#import "ViewController.h"
#import "AppDelegate.h"

@interface GesturePasswordController ()

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
    
}

@synthesize gesturePasswordView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _canChangeVC = YES;
    // Do any additional setup after loading the view.
    previousString = @"";
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""]) {
        
        [self reset];
    }
    else {
        [self verify];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 验证手势密码
- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];//验证密码
    [gesturePasswordView setGesturePasswordDelegate:self];
    [gesturePasswordView.forgetButton setHidden:NO];
    [gesturePasswordView.changeButton setHidden:NO];
    [gesturePasswordView.goBackButton setHidden:YES];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 重置手势密码
- (void)reset{
    previousString = @"";//这里也要重置一下，解决用户刚刚更改密码然后忘了又重置密码产生的bug
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];//重置密码
    [gesturePasswordView setGesturePasswordDelegate:self];
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.changeButton setHidden:YES];
    [gesturePasswordView.goBackButton setHidden:YES];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""])return NO;
    return YES;
}

#pragma mark - 清空记录
- (void)clear{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];
}

#pragma mark - 改变手势密码(自己加的功能)
- (void)change{
    previousString = @"";//这里要重置一下，解决用户刚刚重置密码又更改密码产生的bug
    [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
    [gesturePasswordView.state setText:@"请先输入原密码"];
    [gesturePasswordView.tentacleView setChangeDelegate:self];//自己作为更改密码的代理，等输入手势完毕后会调用代理
    [gesturePasswordView.tentacleView setStyle:3];//更改密码
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.changeButton setHidden:YES];
    [gesturePasswordView.goBackButton setHidden:NO];
    _canChangeVC = NO;//这时候点击back按钮不能跳转页面
}

#pragma mark - 忘记手势密码
- (void)forget{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证信息" message:@"请填写用户名和密码，若正确则可重新设置手势密码！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}


#pragma mark - rerificationDelegate 执行验证后执行的代理
- (BOOL)verification:(NSString *)result{
    [gesturePasswordView.tentacleView enterArgin];
    if ([result isEqualToString:password]) {
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:@"输入正确"];
        
        ViewController *vc = [[ViewController alloc]init];//跳转页面
        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:vc animated:YES completion:^{
            //将页面清除痕迹，但是本地缓存不能清除
            
        }];
        
        return YES;
    }
    [gesturePasswordView.state setTextColor:[UIColor redColor]];
    [gesturePasswordView.state setText:@"手势密码错误"];
    return NO;
}

#pragma mark - resetDelegate 执行重置后执行的代理
- (BOOL)resetPassword:(NSString *)result{
    [gesturePasswordView.tentacleView enterArgin];//清除界面上的手势痕迹(不清除本地存储)
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:@"请再输入密码"];
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
            [keychin setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            //[self presentViewController:(UIViewController) animated:YES completion:nil];
            password = [keychin objectForKey:(__bridge id)kSecValueData];//修改完以后password要更新一下
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [gesturePasswordView.state setText:@"已保存手势密码"];
            [gesturePasswordView.forgetButton setHidden:NO];
            [gesturePasswordView.changeButton setHidden:NO];
            [gesturePasswordView.goBackButton setHidden:NO];
            return YES;
        }else{
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return NO;
        }
    }
}
#pragma mark - changeDelegate 执行更改密码后的代理方法
- (BOOL)changePassword:(NSString *)result{
    [gesturePasswordView.tentacleView enterArgin];
    if ([result isEqualToString:password]) {
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:@"输入正确，请输入新密码"];
        
        [gesturePasswordView.tentacleView setResetDelegate:self];
        [gesturePasswordView.tentacleView setStyle:2];//验证完原密码后，以后的操作就是reset操作，所以只要将style改变一下，tentacleView便会执行重置密码操作
        return YES;
    }
    [gesturePasswordView.state setTextColor:[UIColor redColor]];
    [gesturePasswordView.state setText:@"手势密码错误，没有权限更改密码"];
    return NO;
}

- (void)back{
    if (_canChangeVC) {
        ViewController *vc = [[ViewController alloc]init];
        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }else{
        _canChangeVC = YES;
        previousString = @"";
        [gesturePasswordView.forgetButton setHidden:NO];
        [gesturePasswordView.changeButton setHidden:NO];
    }
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {//点击了确定
        UITextField *idTextField = [alertView textFieldAtIndex:0];//用户名
        UITextField *pwTextField = [alertView textFieldAtIndex:1];//密码
        NSLog(@"id:%@, pw:%@", idTextField.text, pwTextField.text);
        if ([idTextField.text isEqualToString:@"lgq"]&&[pwTextField.text isEqualToString:@"123"]) {
            [self clear];//先清空本地存储，再执行重置
            [self reset];
        }else{
            NSLog(@"用户名，密码错误");
        }
    }
}

@end
