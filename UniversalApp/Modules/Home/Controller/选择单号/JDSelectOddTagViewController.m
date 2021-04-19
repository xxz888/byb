//
//  JDSelectOddTagViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/16.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSelectOddTagViewController.h"
#import "JDSelectOddViewController.h"
#import "JDAddSpViewController.h"
#import "JDSalesTagViewController.h"
@interface JDSelectOddTagViewController ()

@end

@implementation JDSelectOddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择货号";
    self.nextBtn.hidden = YES;

}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)backBtnClicked{
  
    BOOL haveSpVC = NO;
    JDAddSpViewController * spVC ;
    JDSalesTagViewController * salesVC;
    for (UIViewController * VC in [self.navigationController viewControllers]) {

        if ([VC isKindOfClass:[JDAddSpViewController class]]) {
            spVC = VC;
            haveSpVC = YES;
            break;
        }else{
            salesVC = VC;
            haveSpVC = NO;
        }
    }
    
    if (haveSpVC) {
        [self.navigationController popToViewController:spVC animated:YES];
    }else{
        for (UIViewController * VC in [self.navigationController viewControllers]) {
            
            if ([VC isKindOfClass:[JDSalesTagViewController class]]) {
                [self.navigationController popToViewController:VC animated:YES];

            }
        }

    }
    
}
- (IBAction)searchTfDidBegin:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDSelectOddViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSelectOddViewController"];
    kWeakSelf(self);
    VC.selectFinshSpBlock = ^(JDSelectSpModel *spmodel) {
        weakself.spModel = spmodel;
        weakself.nextBtn.hidden = NO;
        if (spmodel.have) {
            weakself.searchTf.text = spmodel.spmc;
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself showToast:@"这个货号尚未存档,将在下单后为你自动建档!"];
                [weakself nextAction:weakself.nextBtn];
            });
        }
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}
//下一步方法
- (IBAction)nextAction:(id)sender{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
        JDAddSpViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddSpViewController"];
        VC.spModel = self.spModel;
    BOOL have = NO;
    for (JDSelectSpModel * model in AD_MANAGER.debugNewGoodsArray) {
        if (model.spid == VC.spModel.spid) {
            have = YES;
            break;
        }else{
            have = NO;
        }
    }
    if (!have) {
        [AD_MANAGER.debugNewGoodsArray addObject:VC.spModel];
    }
        //每点击一次，就加一个model
        NSMutableArray * mArr = [[NSMutableArray alloc]init];
        //这一步判断如果添加过这个商品，就不往数组里面添加了
        //得到所有keys的数组
        NSMutableArray * keysArr = [[NSMutableArray alloc]init];
        if (AD_MANAGER.sectionArray.count > 0) {
            for (NSDictionary * dic in AD_MANAGER.sectionArray) {
                [keysArr addObject:[dic allKeys][0]];
            }
        }
        if ([keysArr containsObject:NSIntegerToNSString(self.spModel.spid)]) {
        }else{
            [AD_MANAGER.sectionArray addObject:@{NSIntegerToNSString(self.spModel.spid):mArr}];
        }
        [self.navigationController pushViewController:VC animated:YES];
}
@end
