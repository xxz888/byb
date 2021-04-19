//
//  CommonMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/31.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//全局标记字符串，用于 通知 存储

#ifndef CommonMacros_h
#define CommonMacros_h
#import "IAPManager.h"


#define YuDingDan @"YuDingDan"
#define XiaoShouDan @"XiaoShouDan"
#define YangPinDan @"YangPinDan"
#define TuiHuoDan @"TuiHuoDan"
#define ShouKuanDan @"ShouKuanDan"
#define ChuKuDan @"ChuKuDan"
#define SPDA @"spda"
#define ZhiFaDan @"ZhiFaDan"


#define CaiGouRuKuDan @"CaiGouRuKuDan"
#define CaiGouTuiHuoDan @"CaiGouTuiHuoDan"
#define FuKuanDan @"FuKuanDan"
#define JiaGongFaHuo @"JiaGongFaHuo"
#define YuanLiaoRuKu @"YuanLiaoRuKu"
#define JiaGongShouHuo @"JiaGongShouHuo"
#define JiaGongZhuanChang @"JiaGongZhuanChang"




#define YuDingDanCaoGao @"YuDingDanCaoGao"

#define YangPinDanCaoGao @"YangPinDanCaoGao"

#define NEWSTR @"new"
#define OLDSTR @"old"

#define KAIFAING @"功能开发中"




#define AD_TOOL [ADTool sharedInstance]
#define AD_MANAGER [ADManager sharedInstance]
#define aa [ADManager sharedInstance].model

#define AD_USERDATAARRAY AD_MANAGER.userDataArray[0]
#define AD_SHARE_MANAGER [ShareManager sharedShareManager]
#define Quan_Xian(name) [AD_SHARE_MANAGER inNameOutQuanXian:name]
#define Quan_Xian_order(name,index) [AD_SHARE_MANAGER inOrderNameOutQuanXian:name subIndex:index]
#define REQUEST_PUSH_MANAGER [IAPManager sharedInstance]

#define NEW_AffrimDic  AD_MANAGER.affrimDic
#define NEW_AffrimDic_SectionArray  AD_MANAGER.affrimDic[@"sectionArray"]


#define STATUS_ARRAY @[@"",@"显示",@"新增",@"修改",@"删除",@"审核",@"打印",@"财务审核",@"查看别人单据",@"终结"]
#define QUANXIAN_ALERT_STRING(name,index) [NSString stringWithFormat:@"你当前没有[%@%@]的权限",name,STATUS_ARRAY[[index integerValue]]]
#import "ADTool.h"
#import "ADManager.h"
#import "LoginModel.h"
#import "NSString+CString.h"
#import "LEEAlert.h"
#import "Define.h"
#import "NSDictionary+Log.h"
#import "NSString+Datetime.h"
#import "RootTableViewController.h"
#import "UIView+Extras.h"
#define pushXiaoShouDan(own)\
\
if (!Quan_Xian_order(@"商品销售",@"2")) {\
[UIView showToast:QUANXIAN_ALERT_STRING(@"商品销售",@"2")];\
return;\
}\
UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];\
AD_MANAGER.orderType = XiaoShouDan;\
REMOVE_ALL_CACHE;\
JDSalesTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesTagViewController"];\
VC.hidesBottomBarWhenPushed = YES;\
[own pushViewController:VC animated:YES]

#pragma mark - ——————— 用户相关 ————————
//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"

//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"

//用户model缓存
#define KUserModelCache @"KUserModelCache"

#define AUTO_LOGIN  @"AUTO_LOGIN"

#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"


#define ORDER_ISEQUAl(order) [AD_MANAGER.orderType isEqualToString:order]



#define pushZhifaDan(own)\
UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"XinXuQiu" bundle:nil];\
AD_MANAGER.orderType = ZhiFaDan;\
REMOVE_ALL_CACHE;\
JDZhiFaDan1ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDZhiFaDan1ViewController"];\
VC.hidesBottomBarWhenPushed = YES;\
[own pushViewController:VC animated:YES]


#define pushYuDingDan(own)\
\
if (!Quan_Xian_order(@"销售订单",@"2")) {\
[UIView showToast:QUANXIAN_ALERT_STRING(@"销售订单",@"2")];\
return;\
}\
UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];\
AD_MANAGER.orderType = YuDingDan;\
REMOVE_ALL_CACHE;\
JDSalesTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesTagViewController"];\
VC.hidesBottomBarWhenPushed = YES;\
[own pushViewController:VC animated:YES]






#define pushYangPinDan(own)\
\
if (!Quan_Xian_order(@"样品销售单",@"2")) {\
[UIView showToast:QUANXIAN_ALERT_STRING(@"样品销售单",@"2")];\
return;\
}\
UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];\
AD_MANAGER.orderType = YangPinDan;\
REMOVE_ALL_CACHE;\
JDSalesTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesTagViewController"];\
VC.hidesBottomBarWhenPushed = YES;\
[own pushViewController:VC animated:YES]



#define pushTuiHuoDan(own)\
\
if (!Quan_Xian_order(@"销售退货",@"2")) {\
[UIView showToast:QUANXIAN_ALERT_STRING(@"销售退货",@"2")];\
return;\
}\
UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];\
AD_MANAGER.orderType = TuiHuoDan;\
REMOVE_ALL_CACHE;\
JDSalesTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesTagViewController"];\
VC.hidesBottomBarWhenPushed = YES;\
[own pushViewController:VC animated:YES]



#define pushCaiGouRuKuDan(own)\
\
if (!Quan_Xian_order(@"商品入库",@"2")) {\
[UIView showToast:QUANXIAN_ALERT_STRING(@"商品入库",@"2")];\
return;\
}\
UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];\
AD_MANAGER.orderType = CaiGouRuKuDan;\
REMOVE_ALL_CACHE;\
JDSalesTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesTagViewController"];\
VC.hidesBottomBarWhenPushed = YES;\
[own pushViewController:VC animated:YES]



#define pushCaiGouTuiHuoDan(own)\
\
if (!Quan_Xian_order(@"入库退货",@"2")) {\
[UIView showToast:QUANXIAN_ALERT_STRING(@"入库退货",@"2")];\
return;\
}\
UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];\
AD_MANAGER.orderType = CaiGouTuiHuoDan;\
REMOVE_ALL_CACHE;\
JDSalesTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesTagViewController"];\
VC.hidesBottomBarWhenPushed = YES;\
[own pushViewController:VC animated:YES]


#define pushShouKuanDan(tabbar)\
\
if (!Quan_Xian_order(@"收款单",@"2")) {\
[UIView showToast:QUANXIAN_ALERT_STRING(@"收款单",@"2")];\
return;\
}\
AD_MANAGER.orderType = ShouKuanDan;\
[AD_SHARE_MANAGER moneyAction:tabbar]

#define pushFuKuanDan(tabbar)\
\
if (!Quan_Xian_order(@"付款单",@"2")) {\
[UIView showToast:QUANXIAN_ALERT_STRING(@"付款单",@"2")];\
return;\
}\
AD_MANAGER.orderType = FuKuanDan;\
[AD_SHARE_MANAGER moneyAction:tabbar]



#define REMOVE_ALL_CACHE    \
\
[AD_MANAGER.sectionArray removeAllObjects];\
[AD_MANAGER.affrimDic removeAllObjects];\
[AD_MANAGER.caoGaoDic removeAllObjects]

#define ipad_alertController \
\
alertController.popoverPresentationController.sourceView = self.view ;\
alertController.popoverPresentationController.sourceRect = self.view.frame

#endif /* CommonMacros_h */
