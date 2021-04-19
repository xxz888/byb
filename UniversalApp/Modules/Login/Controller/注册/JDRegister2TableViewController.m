//
//  JDRegister2TableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/29.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDRegister2TableViewController.h"

@interface JDRegister2TableViewController ()

@end

@implementation JDRegister2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完善注册信息";

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 7) ? 10 : indexPath.row == 9 ? 100 : 50;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (IBAction)finishAction:(id)sender {
    if (_tf1.text.length == 0 || [_tf1.text isEqualToString:@""]) {
        [self showToast:@"公司名称不能为空"];
        return;
    }else if (_tf2.text.length == 0 || [_tf2.text isEqualToString:@""]) {
        [self showToast:@"姓名不能为空"];
        return;
    }else if (_tf3.text.length == 0 || [_tf3.text isEqualToString:@""]) {
    }else if (_tf4.text.length == 0 || [_tf4.text isEqualToString:@""]) {
        [self showToast:@"请设置登录密码"];
        return;
    }else if (_tf5.text.length == 0 || [_tf5.text isEqualToString:@""]) {
        [self showToast:@"请再次输入密码"];
        return;
    }else if (_tf6.text.length == 0 || [_tf6.text isEqualToString:@""]) {
    }
    kWeakSelf(self);
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@(0) forKey:@"id"];
    [dic setValue:_tf1.text forKey:@"entername"];
    [dic setValue:_tf3.text forKey:@"enteraddress"];
    [dic setValue:_tf2.text forKey:@"contactname"];
    [dic setValue:_phone forKey:@"contactmobile"];
    [dic setValue:_phoneCode forKey:@"mobilecode"];
    [dic setValue:@"" forKey:@"othercontact"];
    [dic setValue:@"" forKey:@"staff"];
    [dic setValue:@(0) forKey:@"status"];
    [dic setValue:@"" forKey:@"remark"];
    [dic setValue:@(0) forKey:@"qyid"];
    [dic setValue:@(1) forKey:@"licensecount"];
    [dic setValue:@(0) forKey:@"initstatus"];
    [dic setValue:@(0) forKey:@"initmsg"];
    [dic setValue:_tf4.text forKey:@"password"];

    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestUnLoginDic:@{@"secretcode":_secretcode,@"invitecode":_tf6.text,@"data":string}];
    [AD_MANAGER requestRegistLastStep:mDic success:^(id object) {
        [weakself showToast:@"注册成功"];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    }];
}
@end
