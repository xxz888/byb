//
//  IAPManager.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/8/16.
//  Copyright © 2017年 徐阳. All rights reserved.
//

/**
 内购模块
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MainTabBarController.h"
@interface IAPManager : NSObject

SINGLETON_FOR_HEADER(IAPManager)
+ (instancetype)sharedInstance;

//客户管理
-(void)qxPushKeHuVC:(UINavigationController *)nav;
//商品管理
-(void)qxPushShangPin:(UITabBarController *)tabbarVC;
//供应商管理
-(void)qxPushGongYingShangVC:(UINavigationController *)nav;
//仓库管理
-(void)qxPushCangKuDangAnVC:(UINavigationController *)nav;
//员工管理
-(void)qxPushYuanGongDangAnVC:(UINavigationController *)nav;
//账户管理
-(void)qxZhangHuGuanLiVC:(UINavigationController *)nav;
//折扣类型
-(void)qxZheKouLeiXingVC:(UINavigationController *)nav;
//送货人档案
-(void)qxSongHuoRenVC:(UINavigationController *)nav;
@end
