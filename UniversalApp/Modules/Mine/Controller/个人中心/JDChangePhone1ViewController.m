//
//  JDChangePhone1ViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/26.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDChangePhone1ViewController.h"
#import "OpenUDID.h"
#import "JdChangePhone2ViewController.h"

@interface JDChangePhone1ViewController (){
    NSString * _secretcode;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;

@end

@implementation JDChangePhone1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号";
    self.phoneLbl.text = _phone;
}


- (IBAction)getCode:(id)sender {
    
    [self requestData];
}

-(void)requestData{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JdChangePhone2ViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JdChangePhone2ViewController"];
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"clientid":[OpenUDID value],@"mobile":self.phoneTf.text}];
    [AD_MANAGER requestChangePhoneAction:mDic success:^(id object) {
        VC.secretcode = object[@"data"];
        VC.phonenew = weakself.phoneTf.text;
//        [weakself showToast:@"验证码已发送到你的手机,请注意查收"];
        [weakself.navigationController pushViewController:VC animated:YES];
        
    }];
}


@end
