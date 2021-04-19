//
//  IAPManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/8/16.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "IAPManager.h"
#import "JDKeHuListViewController.h"
#import "UIView+Extension.h"
#import "JDGYSListViewController.h"
#import "JDCKManagerViewController.h"
#import "JDDYManagerViewController.h"
#import "JDCKManagerViewController.h"
#import "JDAllMdViewController.h"
@interface IAPManager ()
@end

@implementation IAPManager

SINGLETON_FOR_CLASS(IAPManager)

/*单例*/
+ (instancetype)sharedInstance{
    static IAPManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[IAPManager alloc]init];
    });
    return s_instance;
}

//客户管理
-(void)qxPushKeHuVC:(UINavigationController *)nav{
    if (!Quan_Xian(@"客户档案")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"客户档案",@"0")];
        return;
    }
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDKeHuListViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDKeHuListViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:VC animated:YES];
}
//商品管理
-(void)qxPushShangPin:(UITabBarController *)tabbarVC{
    if (!Quan_Xian(@"商品档案")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"商品档案",@"0")];
        return;
    }
    tabbarVC.tabBar.hidden = NO;
    tabbarVC.selectedIndex = 1;
}
//店员管理
-(void)qxPushDianYuanVC:(UINavigationController *)nav{
    if (!Quan_Xian(@"客户档案")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"客户档案",@"0")];
        return;
    }
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDKeHuListViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDKeHuListViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:VC animated:YES];
}
//供应商管理
-(void)qxPushGongYingShangVC:(UINavigationController *)nav{
    if (!Quan_Xian(@"供应商档案")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"供应商档案",@"0")];
        return;
    }
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDGYSListViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDGYSListViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:VC animated:YES];
}
//仓库管理
-(void)qxPushCangKuDangAnVC:(UINavigationController *)nav{
    if (!Quan_Xian(@"仓库档案")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"仓库档案",@"0")];
        return;
    }
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDCKManagerViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDCKManagerViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = CCK;
    [nav pushViewController:VC animated:YES];
}
//员工管理
-(void)qxPushYuanGongDangAnVC:(UINavigationController *)nav{
    if (!Quan_Xian(@"员工档案")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"员工档案",@"0")];
        return;
    }
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDDYManagerViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDDYManagerViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:VC animated:YES];
}
//账户管理
-(void)qxZhangHuGuanLiVC:(UINavigationController *)nav{
    if (!Quan_Xian(@"账户档案")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"账户档案",@"0")];
        return;
    }
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDCKManagerViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDCKManagerViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = CCWGL;
    [nav pushViewController:VC animated:YES];
}
//折扣类型
-(void)qxZheKouLeiXingVC:(UINavigationController *)nav{
    if (!Quan_Xian(@"折扣类型档案")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"折扣类型档案",@"0")];
        return;
    }
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDAllMdViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllMdViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = YYHFS;
    [nav pushViewController:VC animated:YES];
}
//送货人档案
-(void)qxSongHuoRenVC:(UINavigationController *)nav{
    if (!Quan_Xian(@"送货人档案")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"送货人档案",@"0")];
        return;
    }
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDCKManagerViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDCKManagerViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = SSHR;
    [nav pushViewController:VC animated:YES];
}
@end
