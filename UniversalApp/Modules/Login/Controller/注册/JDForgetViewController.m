//
//  JDForgetViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/1.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDForgetViewController.h"

@interface JDForgetViewController ()

@end

@implementation JDForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
}
- (IBAction)finishAction:(id)sender {
    if (self.tf1.text.length == 0) {
        [self showToast:@"请输入新密码"];
        return;
    }else if (self.tf2.text.length == 1){
        [self showToast:@"请再次输入新密码"];
        return;
    }else if (![self.tf1.text isEqualToString:self.tf2.text]){
        [self showToast:@"新旧密码不一致"];
        return;
    }else{
        kWeakSelf(self);
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestUnLoginDic:@{@"secretcode":_secretcode,@"mobile":_phone,@"code":_phoneCode,@"newpass":_tf1.text}];
        [AD_MANAGER requestForgetSendPhoneLastStep:mDic success:^(id object) {
            [weakself showToast:@"修改成功"];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}


@end
