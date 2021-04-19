//
//  LoginViewController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ADManager.h"
#import "ADTool.h"
#import "JDRegisterViewController.h"
#import "XNGuideView.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *psdTf;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;


@end

@implementation LoginViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    NSArray *array = @[@"guide page 1", @"guide page 2", @"guide page 3"];
    [XNGuideView showGudieView:array];
    
    self.psdTf.delegate = self;
    self.phoneTf.delegate = self;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.phoneTf.text = self.regPhone;
}
#pragma mark ========== 睁开闭上小眼睛 ==========
- (IBAction)eyeBtnAction:(UIButton *)sender {
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    [self.eyeBtn setImage:[[UIImage imageNamed:@"icon_yincang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.eyeBtn setImage:[[UIImage imageNamed:@"icon_xianshi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    if (sender.selected) { // 按下去了就是明文
        NSString * tempPwdStr = self.psdTf.text;
        self.psdTf.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.psdTf.secureTextEntry = NO;
        self.psdTf.text = tempPwdStr;
    } else { // 暗文
        NSString *tempPwdStr = self.psdTf.text;
        self.psdTf.text = @"";
        self.psdTf.secureTextEntry = YES;
        self.psdTf.text = tempPwdStr;
    }
}
#pragma mark ========== 登录按钮 ==========
- (IBAction)loginBtnAction:(id)sender {
    if (self.phoneTf.text.length == 0) {
        [self showToast:@"请输入手机号码"];
        return;
    }else{

        [self commonLoginAction:[ADTool dicConvertToNSString:@{@"mobile":self.phoneTf.text,@"password":self.psdTf.text}]];
    }
    
}
-(void)commonLoginAction:(NSString *)string{
 
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
    [mDic setValue:@"textilemobile" forKey:@"appid"];
    //当前时间
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    [mDic setValue:timeSp forKey:@"timestamp"];
        [mDic setValue:string forKey:@"jsondata"];
    [mDic setValue:@"" forKey:@"token"];
    [mDic setValue:@"" forKey:@"qybm"];
    [mDic setValue:@"" forKey:@"hardwarekey"];
    NSString *signStr = [ADTool encoingWithDic:mDic];
    [mDic setValue:signStr forKey:@"sign"];
    kWeakSelf(self);
    [AD_MANAGER requestLoginGettoken:mDic success:^(id str) {
        [weakself showToast:@"登录成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AD_MANAGER getRefreshQuanXianData];
            MainTabBarController * mainTabBarVC = [[MainTabBarController alloc]init];
            [AppDelegate shareAppDelegate].window.rootViewController = mainTabBarVC;
        });
    }];
}

#pragma mark ========== 快速注册 ==========
- (IBAction)registerBtnAction:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"LoginViewController" bundle:nil];
    JDRegisterViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDRegisterViewController"];
    VC.whereCome = @"1";
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 忘记密码 ==========
- (IBAction)forgetBtnAction:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"LoginViewController" bundle:nil];
    JDRegisterViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDRegisterViewController"];
    VC.whereCome = @"2";
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 体验一下==========
- (IBAction)experienceBtnAction:(id)sender {
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestUnLoginDic:@{}];
    [AD_MANAGER requestTryItAction:mDic success:^(id object) {
        NSString * qybm = object[@"data"][@"qybm"];
        NSString * username = object[@"data"][@"username"];
        NSString * password = object[@"data"][@"password"];
        
        [self commonLoginAction:[ADTool dicConvertToNSString:@{@"qybm":qybm,@"username":username,@"password":password}]];
    }];

   
}


- (IBAction)tf:(id)sender {
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
