//
//  JDRegisterViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/29.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDRegisterViewController.h"
#import "OpenUDID.h"
#import "JDRegister2TableViewController.h"
#import "JDForgetViewController.h"

@interface JDRegisterViewController (){
    NSString * _secretcode;
}

@end

@implementation JDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.whereCome isEqualToString:@"1"] ? @"注册" : @"忘记密码";
    self.navigationController.navigationBar.hidden = NO;
}
//发送验证码
- (IBAction)sendPhoneAction:(WLCaptcheButton *)btn {
    
    if (self.tf1.text.length == 0 || [self.tf1.text isEqualToString:@""]) {
        [self showToast:@"请输入正确的手机号"];
        return;
    }
    kWeakSelf(self);
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestUnLoginDic:@{@"clientid":[OpenUDID value],@"mobile":self.tf1.text}];
    if ([self.whereCome isEqualToString:@"1"]) {

        [AD_MANAGER requestRegistSendPhone:mDic success:^(id object) {
            _secretcode = object[@"data"];
            [weakself showToast:@"验证码已发送到你的手机,请注意查收"];
            [btn fire];
        }];
    }else{
        [AD_MANAGER requestForgetSendPhone:mDic success:^(id object) {
            _secretcode = object[@"data"];
            [weakself showToast:@"验证码已发送到你的手机,请注意查收"];
            [btn setTitleColor:KWhiteColor forState:0];
            [btn fire];
        }];
    }
 
    
}
//下一步
- (IBAction)nextAction:(id)sender{
//    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"LoginViewController" bundle:nil];
//    JDForgetViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDForgetViewController"];
//    [self.navigationController pushViewController:VC animated:YES];
//    return;
        if (self.tf1.text.length == 0 || [self.tf1.text isEqualToString:@""]) {
            [self showToast:@"请输入正确的手机号"];
            return;
        }else  if (self.tf2.text.length == 0 || [self.tf2.text isEqualToString:@""]) {
            [self showToast:@"请输入正确的验证码"];
            return;
        }else  if (_secretcode.length == 0 || [_secretcode isEqualToString:@""]) {
            [self showToast:@"请重新请求验证码"];
            return;
        }else{
            UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"LoginViewController" bundle:nil];

            if ([self.whereCome isEqualToString:@"1"]) {
                JDRegister2TableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDRegister2TableViewController"];
                VC.phone = _tf1.text;
                VC.phoneCode = _tf2.text;
                VC.secretcode = _secretcode;
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                JDForgetViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDForgetViewController"];
                VC.phone = _tf1.text;
                VC.phoneCode = _tf2.text;
                VC.secretcode = _secretcode;
                [self.navigationController pushViewController:VC animated:YES];
            }
    
    
        }
       
        
    

}
@end
