//
//  ShareManager.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/1.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDSelectSpModel.h"
#import "JDSelectYgModel.h"
#import "JDSelectShrModel.h"
#import "JDSelectCkPageModel.h"
#import "JDSelectClientModel.h"
/**
 分享 相关服务
 */
@interface ShareManager : NSObject

//单例
SINGLETON_FOR_HEADER(ShareManager)

@property (nonatomic,strong) NSString * appVersion;

//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3;
/**
 展示分享页面
 */
-(void)showShareView;
-(void)showShareView:(NSMutableDictionary *)dic;

-(void)setBtnImgRWithTitleL:(UIButton *)button;
-(NSMutableDictionary *)requestSameParamtersDic:(NSDictionary *)jsonDataDic;
-(NSMutableDictionary *)requestUnLoginDic:(NSDictionary *)jsonDataDic;
- (void)updateApp;
// 读取本地JSON文件
-(NSDictionary *)readLocalFileWithName:(NSString *)name;
//传进仓库名字，out仓库ID
-(NSInteger)inCangkuNameOutCangkuId:(NSString *)name;
//传进送货人名字，out送货人ID
-(NSInteger)inSongHuoRenNameOutSonghuoRenId:(NSString *)name;
//传进送货人名字，out送货人ID
-(NSInteger)inYeWuYuanNameOutYeWuYuanId:(NSString *)name;
//传客户名字,传出客户model
-(JDSelectClientModel *)inKeHuNameOutKeHuId:(NSString *)name;
//传进商品id，out商品名字
-(NSString *)inShangPinIdOutName:(NSInteger )key;
//销售单进到草稿的通用方法
-(void)commonXiaoShouDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController;
//预订单进到草稿的通用方法
-(void)commonYuDingDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController;
//样品单进到草稿的通用方法
-(void)commonYangPinDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController;
//退货单进到草稿的通用方法
-(void)commonTuiHuoDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController;
//出库单通用方法
-(void)commonChuKuDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController;
//采购入库单进到草稿的通用方法
-(void)commonCaiGouRuKuDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController;
-(void)getCaiGouRuKuList:(NSDictionary *)resultDic;
//采购退货单进到草稿的通用方法
-(void)commonCaiGouTuiHuoDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController;
-(void)getCaiGouTuiHuoDan:(NSDictionary *)resultDic;
//动态cell时，求得全部的数组
-(NSMutableArray *)getSectionAndRowCount;
//组头的方法
-(NSMutableArray *)getSectionTitleArray;
//蓝牙打印公用方法
-(void)blueToothCommonActionNav:(UINavigationController *)navigationController;
//远程蓝牙打印公用方法
-(void)longBlueToothCommonActionNav:(UINavigationController *)navigationController;
//退出登录
-(void)outLogin;
//传进商品id，out商品model
-(JDSelectSpModel *)inShangPinIdOutModel:(NSInteger )key;
//阴影
-(void)MLShadow:(UIView *)shadowView;
//打印预览公用方法
-(void)pushPrintYuLan:(UINavigationController *)navigationController;
//打印预览和打印的公共参数
-(NSMutableDictionary *)sameParamters;
//进入到预览界面的方法
-(void)pushYuLanAction:(id)object nv:(UINavigationController *)navigationController;
//定位
- (void)dingweiAction:(UIView *)view tf:(UITextField *)tf tv:(UIView *)tv;
//权限
-(void)getRefreshQuanXianData;
//传入权限名称，传出是否有权限
-(BOOL)inNameOutQuanXian:(NSString *)name;
//单子传入权限名称和下标，传出是否有权限
-(BOOL)inOrderNameOutQuanXian:(NSString *)name subIndex:(NSString *)index;
//收付款单
-(void)moneyAction:(MainTabBarController * )tabbar;
@end
