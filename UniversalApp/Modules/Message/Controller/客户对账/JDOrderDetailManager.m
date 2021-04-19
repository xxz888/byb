//
//  JDOrderDetailManager.m
//  UniversalApp
//
//  Created by wxl on 2020/4/15.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "JDOrderDetailManager.h"
#import "JDNewAddShouKuanTableViewController.h"
#import "JDOrder1TableViewController.h"
#import "JDYangPinDetailTableViewController.h"

@implementation JDOrderDetailManager
typedef void(^OrderSelectComplete)(BOOL success, NSString *message, UIViewController *controller);

//-(void)orderSelectionWithOrderDic:(NSDictionary *)dic complete:(OrderSelectComplete)complete
//{
//    if ([dic[@"djzt"] integerValue] == -1){
//        complete(NO, @"订单已删除", nil);
//        return;
//    }
//
//    //如果是预订单
//    if (YES) {
//        AD_MANAGER.orderType = YuDingDan;
//        [self cellAShenHeAxtion:dic];
//    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"样品单历史"]){
//        AD_MANAGER.orderType = YangPinDan;
//        [self cellBShenHeAction:dic];
//    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"销售单历史"]){
//        AD_MANAGER.orderType = XiaoShouDan;
//        [self cellBShenHeAction:dic];
//    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"退货单历史"]){
//        AD_MANAGER.orderType = TuiHuoDan;
//        [self cellBShenHeAction:dic];
//    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"采购入库单历史"]){
//        AD_MANAGER.orderType = CaiGouRuKuDan;
//        [self cellBShenHeAction:dic];
//    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"采购退货单历史"]){
//        AD_MANAGER.orderType = CaiGouTuiHuoDan;
//        [self cellBShenHeAction:dic];
//    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"直发单历史"]){
//        AD_MANAGER.orderType = ZhiFaDan;
//        [self cellBShenHeAction:dic];
//    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"收款单历史"]){
//        AD_MANAGER.orderType = ShouKuanDan;
//        REMOVE_ALL_CACHE;
//        [AD_MANAGER.affrimDic setValue:dic[@"khmc"] forKey:@"khmc"];
//        [AD_MANAGER.affrimDic setValue:dic[@"jsrmc"] forKey:@"jsrmc"];
//        [self cellECommon:dic[@"djhm"] djzt:[dic[@"djzt"] integerValue]];
//    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"付款单历史"]){
//        AD_MANAGER.orderType = FuKuanDan;
//        REMOVE_ALL_CACHE;
//        [AD_MANAGER.affrimDic setValue:dic[@"gysmc"] forKey:@"gysmc"];
//        [self cellECommon:dic[@"djhm"] djzt:[dic[@"djzt"] integerValue]];
//    }
//    else if ([self.titleBtn.titleLabel.text isEqualToString:@"出库单历史"]){
//        AD_MANAGER.orderType = ChuKuDan;
//        [self cellBShenHeAction:dic];
//    }
//}

-(void)cellECommon:(NSString *)noteno djzt:(NSInteger)djzt{
    NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDNewAddShouKuanTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDNewAddShouKuanTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = noteno;
    VC.djzt = djzt;
    if (ORDER_ISEQUAl(ShouKuanDan)) {
        [AD_MANAGER requestSelectKhPage:mDic2 success:^(id str) {//客户信息请求
            //[self.navigationController pushViewController:VC animated:YES];
        }];
    }else if (ORDER_ISEQUAl(FuKuanDan)){
        [AD_MANAGER requestGongYingShangListAction:mDic2 success:^(id str) {//供应商信息请求
            //[self.navigationController pushViewController:VC animated:YES];
        }];
    }
}

//点击预定单已审核
-(void)cellAShenHeAxtion:(NSDictionary *)dic{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDOrder1TableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDOrder1TableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = dic[@"djhm"];
    //[self.navigationController pushViewController:VC animated:YES];
}
//点击样品单已审核
-(void)cellBShenHeAction:(NSDictionary *)dic{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDYangPinDetailTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDYangPinDetailTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = dic[@"djhm"];
    //[self.navigationController pushViewController:VC animated:YES];
}

@end
