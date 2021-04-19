//
//  JdChangePhone2ViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JdChangePhone2ViewController.h"

@interface JdChangePhone2ViewController ()

@end

@implementation JdChangePhone2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号";
    self.phoneNew.text = self.phonenew;
    [self showToast:@"短信发送成功,请注意查收"];
    [self sendPhoneCodeAction:self.sendPhoneCode];
    GTVerifyCodeView *codeView = [[GTVerifyCodeView alloc] initWithFrame:CGRectMake(0, 0, self.codeView.frame.size.width, self.codeView.frame.size.height) onFinishedEnterCode:^(NSString *code) {
      kWeakSelf(self);
      NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"secretcode":weakself.secretcode,
                                                                               @"value":weakself.phonenew,
                                                                               @"code":code
                                                                               }];
        [AD_MANAGER requestEditPhoneAction:mDic success:^(id object) {
            [weakself showToast:@"修改成功"];
            [weakself.navigationController popToViewController:[weakself.navigationController viewControllers][1] animated:YES];
        }];
    }];
    [self.codeView addSubview:codeView];
    _codeGTView = codeView;
}

- (IBAction)sendPhoneCodeAction:(WLCaptcheButton *)btn {
     [self.sendPhoneCode fire];
}
@end
