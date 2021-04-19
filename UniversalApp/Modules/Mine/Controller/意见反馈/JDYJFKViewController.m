//
//  JDYJFKViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDYJFKViewController.h"

@interface JDYJFKViewController ()

@end

@implementation JDYJFKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    self.YJFKTv.placeholderLabel.font = [UIFont systemFontOfSize:14];
    self.YJFKTv.placeholder = @"你认为我们在哪些地方还可以做的更好,请告诉我们...";
    self.YJFKTv.maxLength = 500;

    [self.YJFKTv didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",textView.text);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)submitAction:(id)sender {
    NSDictionary * dic = @{@"feedback":self.YJFKTv.text,@"contact":self.phoneTf.text,@"ver":@"0"};
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dic];
    kWeakSelf(self);
    [AD_MANAGER requestYjfkAction:mDic success:^(id object) {
        [weakself showToast:@"提交成功，感谢你的反馈"];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
@end
