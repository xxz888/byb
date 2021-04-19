//
//  JDRegisterViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/29.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "WLCaptcheButton.h"

@interface JDRegisterViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;

@property (weak, nonatomic) IBOutlet WLCaptcheButton *sendPhoneCodeBtn;


- (IBAction)sendPhoneAction:(id)sender;
- (IBAction)nextAction:(id)sender;

@property (nonatomic,strong) NSString * whereCome;//1注册 2忘记密码


@end
