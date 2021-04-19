//
//  JDSuccessVCViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSuccessVCViewController.h"
#import "JDAllOrderViewController.h"
#import "JDOrder1TableViewController.h"
#import "JDYangPinDetailTableViewController.h"
@interface JDSuccessVCViewController (){
    NSMutableArray * _resultArray;

}

@end

@implementation JDSuccessVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewBorderRadius(self.chakanOrder, 6, 1, JDRGBAColor(0, 163, 255));
    self.title = @"下单成功";
    _resultArray = [[NSMutableArray alloc]init];

    if (ORDER_ISEQUAl(JiaGongFaHuo) || ORDER_ISEQUAl(JiaGongZhuanChang) || ORDER_ISEQUAl(YuanLiaoRuKu) || ORDER_ISEQUAl(JiaGongShouHuo)) {
        self.chakanOrder.hidden = self.printBtn.hidden = YES;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self addNavigationItemWithTitles:@[@"完成"] isLeft:NO target:self action:@selector(clickRightBackBtn:) tags:nil];
    self.isShowLiftBack = NO;
    
}
- (IBAction)printOrderAction:(id)sender {
    AD_MANAGER.noteno = self.noteno;
    if (ORDER_ISEQUAl(YuDingDan)) {
        [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
    }else if (ORDER_ISEQUAl(YangPinDan)){
        [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
    }else if (ORDER_ISEQUAl(TuiHuoDan)){
        [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
    }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
        [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
    }
}
-(void)clickRightBackBtn:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)chakanOrderAction:(id)sender {

    if (ORDER_ISEQUAl(YuDingDan)) {
        [self cellAShenHeAxtion:self.noteno];
    }else if (ORDER_ISEQUAl(YangPinDan)){
        [self cellBShenHeAction:self.noteno];
    }else if (ORDER_ISEQUAl(TuiHuoDan)){
        [self cellBShenHeAction:self.noteno];
    }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
        [self cellBShenHeAction:self.noteno];
    }

}
//点击样品单已审核
-(void)cellTuiHuoShenHeAction:(NSDictionary *)dic{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDYangPinDetailTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDYangPinDetailTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = dic[@"djhm"];
    [self.navigationController pushViewController:VC animated:YES];
}
//点击预定单已审核
-(void)cellAShenHeAxtion:(NSString *)noteno{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDOrder1TableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDOrder1TableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = noteno;
    [self.navigationController pushViewController:VC animated:YES];
}
//点击样品单 和退货已审核
-(void)cellBShenHeAction:(NSString *)noteno{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDYangPinDetailTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDYangPinDetailTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = noteno;
    [self.navigationController pushViewController:VC animated:YES];
}
@end
