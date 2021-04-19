//
//  JDSalesTagViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/16.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSalesTagViewController.h"
#import "JDSalesActionViewController.h"
#import "JDSelectOddViewController.h"
#import "JDSelectOddTagViewController.h"
#import "JDAddSpViewController.h"
#import "JDSelectClientViewController.h"
@interface JDSalesTagViewController ()

@end

@implementation JDSalesTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextBtn.hidden = YES;
    self.title = CaiGouBOOL ? @"选择供应商" : @"选择客户";
    self.searchTf.placeholder = CaiGouBOOL ? @"请输入供应商名称或手机号..." : @"请输入客户名称或手机号...";
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    if (AD_MANAGER.affrimDic[@"khmc"] && [AD_MANAGER.affrimDic[@"khmc"] length] == 0) {
        
    }

}
- (IBAction)searchTfDidBegin:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    kWeakSelf(self);
    JDSalesActionViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesActionViewController"];
    VC.OpenType = self.OpenType;
    VC.selectFinshClientBlock = ^(JDSelectClientModel *model) {
        weakself.nextBtn.hidden = NO;
        if (model.have) {
            weakself.searchTf.text = CaiGouBOOL ? model.gysmc : model.khmc;
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString * title = CaiGouBOOL ? @"这个供应商尚未存档,将在下单后为你自动建档!" : @"这个客户尚未存档,将在下单后为你自动建档!";
                [weakself showToast:title];
                weakself.searchTf.text = CaiGouBOOL ? model.gysmc : model.khmc;
                [weakself nextAction:weakself.nextBtn];
            });
        }
    };
    [self.navigationController pushViewController:VC animated:YES];
}
//下一步方法
- (IBAction)nextAction:(id)sender{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    if ([self.OpenType isEqualToString:@"SPVC"]) {
        JDAddSpViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddSpViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        JDSelectOddTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSelectOddTagViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }

}
- (IBAction)selectKhAction:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDSelectClientViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSelectClientViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
