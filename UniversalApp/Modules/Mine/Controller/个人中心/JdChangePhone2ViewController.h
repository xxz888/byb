//
//  JdChangePhone2ViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "GTVerifyCodeView.h"
#import "WLCaptcheButton.h"
@interface JdChangePhone2ViewController : RootViewController
@property (weak, nonatomic) IBOutlet UILabel *phoneNew;
@property (weak, nonatomic) IBOutlet WLCaptcheButton *sendPhoneCode;
- (IBAction)sendPhoneCodeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property(nonatomic, weak) GTVerifyCodeView *codeGTView;
@property (nonatomic,strong) NSString * phonenew;
@property (nonatomic,strong) NSString * secretcode;

@end
