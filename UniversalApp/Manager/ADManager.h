//
//  ADManager.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/19.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDSelectClientModel.h"
#import "JDParModel.h"
typedef void(^SuccessdBlockType)();
typedef void(^FailBlockType)();
typedef void(^SuccessdBlockTypeParameter)(id object);

#define AD_BLOCK (id)dic success:(SuccessdBlockTypeParameter)successBlock
#define CaiGouBOOL (ORDER_ISEQUAl(CaiGouTuiHuoDan) || ORDER_ISEQUAl(CaiGouRuKuDan) || ORDER_ISEQUAl(FuKuanDan))
#define CaiGouTuiHuoBOOL ORDER_ISEQUAl(CaiGouTuiHuoDan)
#define CaiGouRuKuBOOL ORDER_ISEQUAl(CaiGouRuKuDan)

@interface ADManager : NSObject
@property (nonatomic,strong) NSDictionary * zhifuImageDic;

// 标签数组.确认页面字典
@property (nonatomic, strong) NSMutableArray *markArray;
//新建的商品数组 debug紧急使用
@property (nonatomic,strong) NSMutableArray * debugNewGoodsArray;
//单利数组
@property (nonatomic,strong) NSMutableArray * sectionArray;
//下单参数
@property (nonatomic,strong) NSMutableDictionary * affrimDic;
//保存原草稿的字典
@property (nonatomic,strong) NSMutableDictionary * caoGaoDic;
//新需求下单参数
@property (nonatomic,strong) NSMutableDictionary * data;
//记录是点击哪个单子的tag值，保存在单利里面
@property (nonatomic,assign) NSString * orderType;
//记录是点击哪个单子的单号值，保存在单利里面，方便打印
@property (nonatomic,assign) NSString * noteno;
//打印方案
@property (nonatomic,strong) NSMutableDictionary * printWay;
//权限字典
@property (nonatomic,strong) NSMutableDictionary * quanXianDic;

//下单参数
@property (nonatomic,strong) JDParModel * model;



+ (instancetype)sharedInstance;

#pragma mark ========== 版本更新 ==========
-(void)requestVersionRefresh:AD_BLOCK;
#pragma mark ========== 请求方法 ==========
-(void)requestLoginGettoken:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * userDataArray;
#pragma mark ========== 选择客户列表 ==========
-(void)requestSelectKhPage:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * selectKhPageArray;
#pragma mark ========== 选择商品货号 ==========
-(void)requestSelectSpPage:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * selectSpPageArray;
#pragma mark ========== 选择商品颜色列表 ==========
-(void)requestAddColorPage:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * addColorArray;
#pragma mark ========== 选择仓库 ==========
-(void)requestSelectCkPage:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * selectCkPageArray;
#pragma mark ========== 选择店铺 ==========
-(void)requestSelectYgPage:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * selectYgPageArray;
#pragma mark ========== 选择送货员 ==========
-(void)requestSelectShrPage:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * selectShrPageArray;
#pragma mark ========== 支付方式 ==========
-(void)requestSelectZH:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * selectZHArray;
#pragma mark ========== 优惠方式 ==========
-(void)requestSelectZklx:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * selectZHlxArray;
#pragma mark ========== 销售单保存 ==========
-(void)requestNoteSpxsSaveNote:AD_BLOCK;
#pragma mark ========== 销售报表 ==========
-(void)requestqQueryxs_tjList:AD_BLOCK;
#pragma mark ========== 销售报表界面,销售按钮 ==========
-(void)requestqQueryxs_tjList_djhm:AD_BLOCK paramters:(NSString *)paramters;
@property (nonatomic,strong) NSMutableArray * salesBtnArray;
#pragma mark ========== k线 ==========
-(void)requestQueryCw_ysqslist_xsje:AD_BLOCK paramters:(NSString *)paramters;
@property (nonatomic,strong) NSMutableArray * kLineArray;
#pragma mark ==========  饼状图 ==========
-(void)requestQueryxs_tjList_rxsp:AD_BLOCK paramters:(NSString *)paramters;
@property (nonatomic,strong) NSMutableArray * piexArray;
#pragma mark ==========  经营概括 ==========
-(void)requestQueryxs_cwjyrb_list:AD_BLOCK;
@property (nonatomic,strong) NSMutableArray * dayListArray;
#pragma mark ==========  利润简报 ==========
-(void)requestQueryxs_cwjylr_list:AD_BLOCK;
#pragma mark ==========  账户收款情况 ==========
-(void)requestQueryxs_cwskqk_list:AD_BLOCK;
#pragma mark ==========  库存预警 ==========
-(void)requestQueryckbj_list:AD_BLOCK;
#pragma mark ==========  客户对账 ==========
-(void)requestQueryyszktj_list:AD_BLOCK;
#pragma mark ==========  客户对账明细 ==========
-(void)requestQueryyszkmx_list:AD_BLOCK;
#pragma mark ==========  收款情况统计 ==========
-(void)requestQuerycwskqs_list:AD_BLOCK;
#pragma mark ==========  第三页 ==========
-(void)requestThreeShow:AD_BLOCK;
#pragma mark ========== 首页营收简报 ==========
-(void)requestqueryCw_Jyjblist:AD_BLOCK;
#pragma mark ========== 注册发送手机验证码 ==========
-(void)requestRegistSendPhone:AD_BLOCK;
#pragma mark ========== 注册最后一步 ==========
-(void)requestRegistLastStep:AD_BLOCK;
#pragma mark ========== 全部订单 ==========
-(void)requestAllOrderList:AD_BLOCK paramters:(NSString *)paramters;
#pragma mark ========== 忘记密码发送手机验证码 ==========
-(void)requestForgetSendPhone:AD_BLOCK;
#pragma mark ========== 忘记密码最后一步 ==========
-(void)requestForgetSendPhoneLastStep:AD_BLOCK;
#pragma mark ========== 退货单保存 ==========
-(void)requestTuihuoOrderSaveNote:AD_BLOCK;
#pragma mark ========== 预定单保存 ==========
-(void)requestYuDingOrderOrderSaveNote:AD_BLOCK;
#pragma mark ========== 样品单保存 ==========
-(void)requestYangPinOrderSaveNote:AD_BLOCK;
#pragma mark ========== 退出登录  ==========
-(void)requestLogOutApp:AD_BLOCK;
#pragma mark ========== 新增客户  ==========
-(void)requestAddClient:AD_BLOCK;
#pragma mark ========== 地址  ==========
-(void)requestAddressList:AD_BLOCK;
#pragma mark ========== 预定单详情  ==========
-(void)requestxsddShowNote:AD_BLOCK;
#pragma mark ========== 终结  ==========
-(void)requestZjCheckNote:AD_BLOCK;
#pragma mark ========== 出库单确认 ==========
-(void)requestChuKuDanSave:AD_BLOCK;
#pragma mark ========== 出库单详情 ==========
-(void)requestChuKuDanDetail:AD_BLOCK;
#pragma mark ========== 样品单详情 ==========
-(void)requestYangPinDanDetail:AD_BLOCK;
#pragma mark ========== 预定单删除 ==========
-(void)requestDelyudingdan:AD_BLOCK;
#pragma mark ========== 销售单详情 ==========
-(void)requestXiaoShouSHowNote:AD_BLOCK;
#pragma mark ========== 销售单详情 ==========
-(void)requestXiaoShouDanCaoGaoDetail:AD_BLOCK;
#pragma mark ========== 审核和反核 ==========
-(void)requestFanShenDan:AD_BLOCK;
#pragma mark ========== 退货单详情 ==========
-(void)requestTuiHuoCaoGaoDetail:AD_BLOCK;
#pragma mark ========== 增加商品 ==========
-(void)requestAddNewSp:AD_BLOCK;
#pragma mark ========== 客户列表 ==========
-(void)requestKeHuList:AD_BLOCK;
#pragma mark ========== 收款单保存 ==========
-(void)requestSaveShouKuanDan:AD_BLOCK;
#pragma mark ========== 收款单列表 ==========
-(void)requestShowSKList:AD_BLOCK;
#pragma mark ========== 收款单删除 ==========
-(void)requestDelskdan:AD_BLOCK;
#pragma mark ========== 出库单审核和反核 ==========
-(void)requestChuKuFanShenDan:AD_BLOCK;
#pragma mark ========== 退货单审核和反核 ==========
    -(void)requestTuiHuoFanShenDan:AD_BLOCK;
#pragma mark ========== 样品单审核和反核 ==========
        -(void)requestYangPinFanShenDan:AD_BLOCK;
#pragma mark ========== 销售单反审 ==========
-(void)requestXiaoShouDanFanShen:AD_BLOCK;
#pragma mark ========== 出库单删除 ==========
-(void)requestDelChuKuDan:AD_BLOCK;
#pragma mark ========== 退货单删除 ==========
    -(void)requestDelTuiHuoDan:AD_BLOCK;
#pragma mark ========== 样品单删除 ==========
-(void)requestDelYangPinDan:AD_BLOCK;
#pragma mark ========== 销售删除 ==========
-(void)requestDelXiaoShouDan:AD_BLOCK;
#pragma mark ========== 收款单审核和反核 ==========
-(void)requestShouKuanDanFanShen:AD_BLOCK;
#pragma mark ========== 自动增加颜色 ==========
-(void)requestAutoAddYs:AD_BLOCK;
#pragma mark ========== 自动增加商品 ==========
-(void)requestAutoAddSp:AD_BLOCK;
#pragma mark ========== 蓝牙打印show ==========
-(void)requestBlueShow:AD_BLOCK;

#pragma mark ========== 预定单单打印方式 ==========
-(void)requestYuDingDanBluePrintWay:AD_BLOCK;
#pragma mark ========== 商品销售单打印方式 ==========
-(void)requestXiaoShouBluePrintWay:AD_BLOCK;
#pragma mark ========== 商品出库单打印方式 ==========
-(void)requestChuKuBluePrintWay:AD_BLOCK;
#pragma mark ========== 样品单打印方式 ==========
-(void)requestYangPinBluePrintWay:AD_BLOCK;
#pragma mark ========== 退货单打印方式 ==========
-(void)requestTuiHuoDanBluePrintWay:AD_BLOCK;
#pragma mark ========== 收款打印方式 ==========
-(void)requestShouKuanDanBluePrintWay:AD_BLOCK;
#pragma mark ========== 商品直发单打印方式 ==========
-(void)requestShangPingZhiFaDanBluePrintWay:AD_BLOCK;

#pragma mark ========== 销售单打印预览 ==========
-(void)printXiaoShouPreviewAction:AD_BLOCK;
#pragma mark ========== 预定单单打印预览 ==========
-(void)printYuDingDanPreviewAction:AD_BLOCK;
#pragma mark ========== 样品单单打印预览 ==========
-(void)printYangPinDanPreviewAction:AD_BLOCK;
#pragma mark ========== 退货单单打印预览 ==========
-(void)printTuiHuoDanPreviewAction:AD_BLOCK;
#pragma mark ========== 出库单单单打印预览 ==========
-(void)printChuKuDanPreviewAction:AD_BLOCK;
#pragma mark ========== 收款单单打印预览 ==========
-(void)printShouKuanDanPreviewAction:AD_BLOCK;
#pragma mark ========== 直发单打印预览 ==========
-(void)printZhiFaDanPreviewAction:AD_BLOCK;

#pragma mark ========== 蓝牙开始打印 ==========
-(void)printXPXSNoteBytesAction:AD_BLOCK;
#pragma mark ========== 出库单开始打印 ==========
-(void)printChuKuDanNoteBytesAction:AD_BLOCK;
#pragma mark ========== 样品开始打印 ==========
-(void)printYangPinDanNoteBytesAction:AD_BLOCK;
#pragma mark ========== 预定单开始打印 ==========
-(void)printYuDingDanNoteBytesAction:AD_BLOCK;
#pragma mark ========== 退货单开始打印 ==========
-(void)printTuiHuoDanNoteBytesAction:AD_BLOCK;
#pragma mark ========== 收款单开始打印 ==========
-(void)printShouKuanDanNoteBytesAction:AD_BLOCK;

#pragma mark ========== 出库单远程打印保存 ==========
-(void)printChuKuLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 销售单远程打印保存 ==========
-(void)printXiaoShouLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 打印保存 ==========
-(void)printXiaoShouSaveAction:AD_BLOCK;

#pragma mark ========== 商品详情 ==========
-(void)requestShangPinDetailAction:AD_BLOCK;
#pragma mark ========== 颜色详情 ==========
-(void)requestColorDetailAction:AD_BLOCK;
#pragma mark ========== 新增门店 ==========
-(void)requestAllMdAction:AD_BLOCK;
#pragma mark ========== 编辑门店 ==========
-(void)requestEditMdAction:AD_BLOCK;
#pragma mark ========== 新增门店 ==========
-(void)requestAddMdAction:AD_BLOCK;
#pragma mark ========== 删除门店 ==========
-(void)requestDelMdAction:AD_BLOCK;
#pragma mark ========== 操作记录门店 ==========
-(void)requestMdCaoZuoJiLuAction:AD_BLOCK;

#pragma mark ========== 仓库列表 ==========
-(void)requestCKListAction:AD_BLOCK;
#pragma mark ========== 仓库信息show ==========
-(void)requestShowCKAction:AD_BLOCK;
#pragma mark ========== 仓库edit ==========
-(void)requestEDitCKction:AD_BLOCK;
#pragma mark ========== 仓库add ==========
-(void)requestAddCKction:AD_BLOCK;
#pragma mark ========== 仓库删除 ==========
-(void)requestDelCKAction:AD_BLOCK;
#pragma mark ========== 操作记录门店 ==========
-(void)requestCKCaoZuoJiLuAction:AD_BLOCK;



#pragma mark ========== 财务管理show ==========
-(void)requestCWGLListAction:AD_BLOCK;
#pragma mark ========== 财务管理show ==========
-(void)requestCWGLShowAction:AD_BLOCK;
#pragma mark ========== 财务管理del ==========
-(void)requestCWGLDelAction:AD_BLOCK;
#pragma mark ========== 财务管理del ==========
-(void)requestCWGLCaoZuoAction:AD_BLOCK;
#pragma mark ========== 财务管理edit ==========
-(void)requestCWGLEditAction:AD_BLOCK;
#pragma mark ========== 财务管理add ==========
-(void)requestCWGLAddAction:AD_BLOCK;







#pragma mark ========== 送货人管理list ==========
-(void)requestSHRListAction:AD_BLOCK;
#pragma mark ========== 送货人管理show ==========
-(void)requestSHRShowAction:AD_BLOCK;
#pragma mark ========== 送货人管理del ==========
-(void)requestSHRDelAction:AD_BLOCK;
#pragma mark ========== 送货人管理logs ==========
-(void)requestSHRCaoZuoAction:AD_BLOCK;
#pragma mark ========== 送货人管理edit ==========
-(void)requestSHREditAction:AD_BLOCK;
#pragma mark ========== 送货人管理add ==========
-(void)requestSHRAddAction:AD_BLOCK;


#pragma mark ========== 优惠方式管理list ==========
-(void)requestYHFSListAction:AD_BLOCK;
#pragma mark ========== 优惠方式管理show ==========
-(void)requestYHFSShowAction:AD_BLOCK;
#pragma mark ========== 优惠方式管理del ==========
-(void)requestYHFSDelAction:AD_BLOCK;
#pragma mark ==========优惠方式管理logs ==========
-(void)requestYHFSCaoZuoAction:AD_BLOCK;
#pragma mark ========== 优惠方式管理edit ==========
-(void)requestYHFSEditAction:AD_BLOCK;
#pragma mark ========== 优惠方式管理add ==========
-(void)requestYHFSAddAction:AD_BLOCK;

#pragma mark ========== 店员管理list ==========
-(void)requestDYListAction:AD_BLOCK;
#pragma mark ========== 店员管理show ==========
-(void)requestDYShowAction:AD_BLOCK;
#pragma mark ========== 店员管理del ==========
-(void)requestDYDelAction:AD_BLOCK;
#pragma mark ==========店员管理logs ==========
-(void)requestDYCaoZuoAction:AD_BLOCK;
#pragma mark ========== 店员管理edit ==========
-(void)requestDYEditAction:AD_BLOCK;
#pragma mark ========== 店员管理add ==========
-(void)requestDYAddAction:AD_BLOCK;
#pragma mark ========== 店员发送手机验证码==========
-(void)requestDYSendPhoneCodeAction:AD_BLOCK;

#pragma mark ========== 批量修改价格 ==========
-(void)requestAllChangePriceAction:AD_BLOCK;
#pragma mark ========== 意见反馈 ==========
-(void)requestYjfkAction:AD_BLOCK;

#pragma mark ========== 权限 ==========
-(void)requestQXJSAction:AD_BLOCK;
#pragma mark ========== 增加新颜色  ==========
-(void)requestAddnewColorAction:AD_BLOCK;
#pragma mark ========== 增加图片  ==========
-(void)requestAddNewColorImageAction:AD_BLOCK;
#pragma mark ========== 增加其他的  ==========
-(void)requestAddnewColorQiTaAction:AD_BLOCK;

#pragma mark ========== 查看颜色地址匹数和数量  ==========
-(void)requestShowColorPiShuAction:AD_BLOCK;
#pragma mark ========== 查看颜色其他  ==========
-(void)requestShowColorQiTaAction:AD_BLOCK;
#pragma mark ========== edit图片  ==========
-(void)requestEditNewColorImageAction:AD_BLOCK;
#pragma mark ========== del图片  ==========
-(void)requestDelNewColorImageAction:AD_BLOCK;
#pragma mark ========== 公司信息 ==========
-(void)requestCommanyInfoAction:AD_BLOCK;
#pragma mark ========== 保存公司信息 ==========
-(void)requestSaveCommanyInfoAction:AD_BLOCK;
#pragma mark ========== SPDA远程打印 ==========
-(void)requestSPDAPrintInfoAction:AD_BLOCK;
#pragma mark ========== 颜色单打印预览 ==========
-(void)printSPDAPreviewAction:AD_BLOCK;
#pragma mark ========== SPDA远程打印 ==========
-(void)requestSPDALastStepPrintInfoAction:AD_BLOCK;
#pragma mark ========== edit商品 ==========
-(void)requestEditSp:AD_BLOCK;
#pragma mark ==========商品logs ==========
-(void)requestSpCaoZuoAction:AD_BLOCK;
#pragma mark ==========商品del ==========
-(void)requestDelCaoZuoAction:AD_BLOCK;
#pragma mark ==========商品标签方式 ==========
-(void)requestSpBQWayAction:AD_BLOCK;
#pragma mark ========== 商品标签打印 ==========
-(void)printSPDAPrintSendMessageAction:AD_BLOCK;
#pragma mark ==========修改库存 ==========
-(void)requestChangeKuCunAction:AD_BLOCK;
#pragma mark ==========库存储存 ==========
-(void)requestSaveKuCunAction:AD_BLOCK;
#pragma mark ========== 修改头像 ==========
-(void)requestChangeImageAction:AD_BLOCK;
#pragma mark ========== 修改头像 ==========
    -(void)requestChangeNameAction:AD_BLOCK;
#pragma mark ========== 修改密码 ==========
-(void)requestChangePsdAction:AD_BLOCK;
#pragma mark ========== 查看头像 ==========
-(void)requestAccTouXiangAction:AD_BLOCK;
#pragma mark ========== 修改手机号 ==========
-(void)requestChangePhoneAction:AD_BLOCK;
#pragma mark ========== 新增客户  ==========
-(void)requestClientList:AD_BLOCK;
#pragma mark ========== edit手机号码 ==========
-(void)requestEditPhoneAction:AD_BLOCK;
#pragma mark ========== edit客户列表  ==========
-(void)requestEditClient:AD_BLOCK;
#pragma mark ========== delete客户列表  ==========
-(void)requestdeleteClient:AD_BLOCK;
#pragma mark ========== 客户操作记录 ==========
-(void)requestKeHuCaoZuoAction:AD_BLOCK;
#pragma mark ========== 试用一下 ==========
-(void)requestTryItAction:(id)dic success:(SuccessdBlockTypeParameter)successBlock;

#pragma mark ========== 供应商列表 ==========
-(void)requestGongYingShangListAction:AD_BLOCK;
#pragma mark ========== 供应商del ==========
-(void)requestGongYingShangDelAction:AD_BLOCK;
#pragma mark ========== 供应商add ==========
-(void)requestGongYingShangAddAction:AD_BLOCK;
#pragma mark ========== 供应商edit ==========
-(void)requestGongYingShangEditAction:AD_BLOCK;
#pragma mark ========== 供应商show ==========
-(void)requestGongYingShangshowAction:AD_BLOCK;
#pragma mark ========== 供应商采购入库 ==========
-(void)requestCaiGouRuKuSaveAction:AD_BLOCK;
#pragma mark ========== 供应商采购退货 ==========
-(void)requestCaiGouTuiHuoSaveAction:AD_BLOCK;
#pragma mark ========== 供应商采购入库show ==========
-(void)requestCaiGouRuKuShowAction:AD_BLOCK;
#pragma mark ========== 供应商采购退货show ==========
-(void)requestCaiGouTuiHuoShowAction:AD_BLOCK;
#pragma mark ========== 采购入库单反审 ==========
-(void)requestCaiGouRuKuDanFanShen:AD_BLOCK;
#pragma mark ========== 采购入库单单删除 ==========
-(void)requestDelCaiGouRuKuDan:AD_BLOCK;
#pragma mark ========== 采购退货单单删除 ==========
-(void)requestDelCaiGouTuiHuoDan:AD_BLOCK;
#pragma mark ========== 采购退货 单反审 ==========
-(void)requestCaiGouTuiHuoDanFanShen:AD_BLOCK;
#pragma mark ========== 新增颜色时候的仓库  ==========
-(void)requestAddnewColorCangKuAction:AD_BLOCK;
#pragma mark ========== 付款单删除 ==========
-(void)requestDelFuKuandan:AD_BLOCK;
#pragma mark ========== 付款单审核和反核 ==========
-(void)requestFuKuanDanFanShen:AD_BLOCK;
#pragma mark ========== 收款单保存 ==========
-(void)requestSaveFuKuanDan:AD_BLOCK;
#pragma mark ========== 付款单列表 ==========
-(void)requestShowFKList:AD_BLOCK;
#pragma mark ========== 单子分享分享 ==========
-(void)requestShareWeiXin:AD_BLOCK notetype:(NSString *)notetype;
#pragma mark ========== 供应商新增 ==========
-(void)requestAddGongYingShangList:AD_BLOCK;
#pragma mark ========== 供应商edit ==========
-(void)requestEditGongYingShangList:AD_BLOCK;
#pragma mark ========== 供应商edit ==========
-(void)requestDelGongYingShangList:AD_BLOCK;
#pragma mark ========== 供应商应付 ==========
-(void)requestYingFuGongYingShangList:AD_BLOCK;
#pragma mark ========== 联系人add ==========
-(void)requestaddLxrList:AD_BLOCK;
#pragma mark ========== 联系人edit ==========
-(void)requestEditLxrList:AD_BLOCK;
#pragma mark ========== 联系人删除 ==========
-(void)requestDelLxrList:AD_BLOCK;
#pragma mark ========== 联系人列表 ==========
-(void)requestLxrList:AD_BLOCK;
#pragma mark ========== 联系人show ==========
-(void)requestGYSShowList:AD_BLOCK;
#pragma mark ========== 供应商操作记录 ==========
-(void)requestGYSCaoZuoAction:AD_BLOCK;
#pragma mark ========== 采购入库单打印方式 ==========
-(void)requestCaiGouRuKuBluePrintWay:AD_BLOCK;
#pragma mark ========== 采购退货单打印方式 ==========
-(void)requestCaiGouTuiHuoBluePrintWay:AD_BLOCK;
#pragma mark ========== 付款单打印方式 ==========
-(void)requestFuKuanDanBluePrintWay:AD_BLOCK;
#pragma mark ========== 采购入库单远程打印保存 ==========
-(void)printCaiGouRuKuLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 采购退货单远程打印保存 ==========
-(void)printCaiGouTuiHuoLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 付款单单远程打印保存 ==========
-(void)printFuKuanDanPrintSaveAction:AD_BLOCK;
#pragma mark ========== 付款单单打印预览 ==========
-(void)printFuKuanDanPreviewAction:AD_BLOCK;
#pragma mark ========== 采购入库单打印预览 ==========
-(void)printCaiGouRuKuDanPreviewAction:AD_BLOCK;
#pragma mark ========== 采购退货单打印预览  ==========
-(void)printCaiGouTuiHuoDanPreviewAction:AD_BLOCK;
#pragma mark ========== 付款单开始打印 ==========
-(void)printFuKuanDanNoteBytesAction:AD_BLOCK;
#pragma mark ========== 采购入库单开始打印 ==========
-(void)printCaiGouRuKuDanNoteBytesAction:AD_BLOCK;
#pragma mark ========== 采购退货单开始打印 ==========
-(void)printCaiGouTuiHuoNoteBytesAction:AD_BLOCK;


#pragma mark ========== 预定单远程打印保存 ==========
-(void)printYuDingDanLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 样品单远程打印保存 ==========
-(void)printYangPinDanLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 退货单远程打印保存 ==========
-(void)printTuiHuoDanLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 收款单远程打印保存 ==========
-(void)printShouKuanDanLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 采购入库单远程打印保存 ==========
-(void)printCaiGouRuKuDanLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 采购退货远程打印保存 ==========
-(void)printCaiGouChuKuDanLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 付款单远程打印保存 ==========
-(void)printFuKuanDanLongPrintSaveAction:AD_BLOCK;
#pragma mark ========== 客户应付 ==========
-(void)requestKeHuYingFuList:AD_BLOCK;
#pragma mark ==========  账户付款情况 ==========
-(void)requestQueryxs_cwfkqk_list:AD_BLOCK;
#pragma mark ==========  供应商对账 ==========
-(void)requestQueryyfzktj_list:AD_BLOCK;
#pragma mark ==========  供应商对账明细 ==========
-(void)requestQueryyfzkmx_list:AD_BLOCK;
#pragma mark ==========  付款情况统计 ==========
-(void)requestQuerycwfkqs_list:AD_BLOCK;
#pragma mark ========== 所有权限 ==========
-(void)getRefreshQuanXianData;
#pragma mark ========== 客户联系人add ==========
-(void)requestaddKhLxrList:AD_BLOCK;
#pragma mark ========== 客户标签 ==========
-(void)requestKeHuBiaoQianList:AD_BLOCK;


#pragma mark ========== 直发单保存 ==========
-(void)requestNoteSpzfSaveNote:AD_BLOCK;
#pragma mark ========== 直发单show ==========
-(void)requestZhiFaShowAction:AD_BLOCK;
#pragma mark ========== 订单号 ==========
-(void)requestJiaGongOrderList:AD_BLOCK;
#pragma mark ========== 加工发货 ==========
-(void)requestJiaGongFaHuoUp:AD_BLOCK;
#pragma mark ========== 加工转厂 ==========
-(void)requestJiaGongZhuanChangUp:AD_BLOCK;
#pragma mark ========== 原料入库 ==========
-(void)requestYuanLiaoRuKuUp:AD_BLOCK;
#pragma mark ========== 加工方式 ==========
-(void)requestJiaGongFangShi:AD_BLOCK;
#pragma mark ========== 加工收货 ==========
-(void)requestJiaGongShouHuoUp:AD_BLOCK;
#pragma mark ========== 加工库存 ==========
-(void)requestGongChangKuCun:AD_BLOCK;
#pragma mark ========== 颜色库存明细 ==========
-(void)requestColorKucunMingXi:AD_BLOCK;
#pragma mark ========== 应收账款明细 ==========
-(void)requestKeHuYszk:AD_BLOCK;
#pragma mark ========== 最新价 ==========
-(void)requestNewPrice:AD_BLOCK;

#pragma mark ========== 销售单返回当前页数 ==========
-(void)printXiaoShouPreviewPageCurpageAction:AD_BLOCK;
#pragma mark ========== 销售单返回页数 ==========
-(void)printXiaoShouPreviewPageCountAction:AD_BLOCK;

#pragma mark ========== 取得图片 ==========
-(void)requestKeHuDuiZhangDanTuPian:AD_BLOCK;
#pragma mark ========== 取得页数 ==========
-(void)requestKeHuDuiZhangDanYeShu:AD_BLOCK;
#pragma mark ========== 客户对账单分享 ==========
-(void)requestKeHuDuiZhangDanGetWay:AD_BLOCK;


@end
