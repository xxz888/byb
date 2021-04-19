//
//  ADManager.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/19.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "ADManager.h"
#import "HttpRequest.h"
#import "LoginModel.h"
#import "JDSelectClientModel.h"
#import "JDSelectSpModel.h"
#import "JDAddColorModel.h"
#import "JDSelectYgModel.h"
#import "JDSelectShrModel.h"
#import "JDSelectCkPageModel.h"
#import "JDSalesBtnModel.h"
#import "JDKLineModel.h"
#import "JDPiexModel.h"
#import "JDDayListModel.h"


#define RREQUEST(paramters)     [HTTP_POST(paramters) Parameters:dic sucess:^(id responseObject) {\
successBlock(responseObject);\
} failure:^(NSError *error) {\
}];
@interface ADManager ()

@end
#define HTTP_POST(pi) HttpRequest httpRequestPostPi:pi

@implementation ADManager


/*单例*/
+ (instancetype)sharedInstance{
    static ADManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[ADManager alloc]init];
    });
    return s_instance;
}
#pragma mark ========== 版本更新 ==========
-(void)requestVersionRefresh:AD_BLOCK{
    RREQUEST(@"/sys/comm/CheckVersionIOS");
}

#pragma mark ========== 试用一下 ==========
-(void)requestTryItAction:(id)dic success:(SuccessdBlockTypeParameter)successBlock{
    RREQUEST(@"/main/comm/Tryit");
}
//登陆gettoken
-(void)requestLoginGettoken:(id)dic success:(SuccessdBlockTypeParameter)successBlock{
    [HTTP_POST(@"/auth/gettoken") Parameters:dic sucess:^(id responseObject) {
        [_userDataArray removeAllObjects];
        
        LoginModel * model = [[LoginModel alloc]init];
        [model setValuesForKeysWithDictionary:responseObject[@"data"]];
        [kUserDefaults setValue:responseObject[@"data"] forKey:@"AUTO_LOGIN"];

        [_userDataArray addObject:model];
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 选择客户列表 ==========
-(void)requestSelectKhPage:AD_BLOCK{
    [HTTP_POST(@"/archives/pdaselect/SelectKhPage") Parameters:dic sucess:^(id responseObject) {
        [_selectKhPageArray removeAllObjects];
        for (NSDictionary * dic  in responseObject[@"data"][@"list"]) {
            JDSelectClientModel  * model = [[JDSelectClientModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_selectKhPageArray addObject:model];
        }
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 选择商品货号列表 ==========
-(void)requestSelectSpPage:AD_BLOCK{
    [HTTP_POST(@"/archives/pdaselect/SelectSpPage") Parameters:dic sucess:^(id responseObject) {
        [_selectSpPageArray removeAllObjects];
        for (NSDictionary * dic  in responseObject[@"data"][@"list"]) {
            JDSelectSpModel  * model = [[JDSelectSpModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_selectSpPageArray addObject:model];
        }
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 选择商品颜色列表 ==========
-(void)requestAddColorPage:AD_BLOCK{
    [HTTP_POST(@"/archives/pdaselect/SelectYs") Parameters:dic sucess:^(id responseObject) {
        [_addColorArray removeAllObjects];
        for (NSDictionary * dic  in responseObject[@"data"]) {
            JDAddColorModel  * model = [[JDAddColorModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_addColorArray addObject:model];
        }
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 选择仓库 ==========
-(void)requestSelectCkPage:AD_BLOCK{
    [HTTP_POST(@"/archives/pdaselect/SelectCkPage") Parameters:dic sucess:^(id responseObject) {
        [_selectCkPageArray removeAllObjects];
        for (NSDictionary * dic  in responseObject[@"data"][@"list"]) {
             JDSelectCkPageModel * model = [[JDSelectCkPageModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_selectCkPageArray addObject:model];
        }
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 选择店铺 ==========
-(void)requestSelectYgPage:AD_BLOCK{
    [HTTP_POST(@"/archives/pdaselect/SelectYgPage") Parameters:dic sucess:^(id responseObject) {
        [_selectYgPageArray removeAllObjects];
        for (NSDictionary * dic  in responseObject[@"data"][@"list"]) {
            JDSelectYgModel  * model = [[JDSelectYgModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_selectYgPageArray addObject:model];
        }
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 选择送货员 ==========
-(void)requestSelectShrPage:AD_BLOCK{
    [HTTP_POST(@"/archives/pdaselect/SelectShr") Parameters:dic sucess:^(id responseObject) {
        [_selectShrPageArray removeAllObjects];
        for (NSDictionary * dic  in responseObject[@"data"]) {
            JDSelectShrModel  * model = [[JDSelectShrModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_selectShrPageArray addObject:model];
        }
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 支付方式 ==========
-(void)requestSelectZH:AD_BLOCK{
    [HTTP_POST(@"/archives/pdaselect/SelectZh") Parameters:dic sucess:^(id responseObject) {
        [_selectZHArray removeAllObjects];
        [_selectZHArray addObjectsFromArray:responseObject[@"data"]];
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 优惠方式 ==========
-(void)requestSelectZklx:AD_BLOCK{
    [HTTP_POST(@"/archives/pdaselect/SelectZklx") Parameters:dic sucess:^(id responseObject) {
        [_selectZHlxArray removeAllObjects];
        [_selectZHlxArray addObjectsFromArray:responseObject[@"data"]];
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售单保存 ==========
-(void)requestNoteSpxsSaveNote:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/SaveNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 直发单保存 ==========
-(void)requestNoteSpzfSaveNote:AD_BLOCK{
    [HTTP_POST(@"/note/spzf/savenote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 退货单保存 ==========
-(void)requestTuihuoOrderSaveNote:AD_BLOCK{
    [HTTP_POST(@"/note/xsth/SaveNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 样品单保存 ==========
-(void)requestYangPinOrderSaveNote:AD_BLOCK{
    [HTTP_POST(@"/note/ypxs/SaveNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 预定单保存 ==========
-(void)requestYuDingOrderOrderSaveNote:AD_BLOCK{
    [HTTP_POST(@"/note/xsdd/SaveNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售报表 ==========
-(void)requestqQueryxs_tjList:AD_BLOCK{
    [HTTP_POST(@"/query/xs_tj/List") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售报表界面,销售按钮 ==========
-(void)requestqQueryxs_tjList_djhm:AD_BLOCK paramters:(NSString *)paramters{
    [_salesBtnArray removeAllObjects];
    [HTTP_POST(paramters) Parameters:dic sucess:^(id responseObject) {
        [_salesBtnArray removeAllObjects];
        for (NSDictionary * dic  in responseObject[@"data"][@"list"]) {
            JDSalesBtnModel * model = [[JDSalesBtnModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_salesBtnArray addObject:model];
        }
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== k线 ==========
-(void)requestQueryCw_ysqslist_xsje:AD_BLOCK paramters:(NSString *)paramters{
    [_kLineArray removeAllObjects];
    [HTTP_POST(paramters) Parameters:dic sucess:^(id responseObject) {
        for (NSDictionary * dic in responseObject[@"data"]) {
            JDKLineModel * model = [[JDKLineModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_kLineArray addObject:model];
        }
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  饼状图 ==========
-(void)requestQueryxs_tjList_rxsp:AD_BLOCK paramters:(NSString *)paramters{
    [_piexArray removeAllObjects];
    [HTTP_POST(paramters) Parameters:dic sucess:^(id responseObject) {
        
        if ([responseObject[@"data"] count] > 10) {
            for (NSInteger i = 0; i < 10; i++) {
                JDPiexModel * model = [[JDPiexModel alloc] init];
                [model setValuesForKeysWithDictionary:responseObject[@"data"][i]];
                [_piexArray addObject:model];
            }
            
        }else{
            for (NSDictionary * dic in responseObject[@"data"]) {
                JDPiexModel * model = [[JDPiexModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_piexArray addObject:model];
            }
        }
        
      
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  经营概括 ==========
-(void)requestQueryxs_cwjyrb_list:AD_BLOCK{
    [_dayListArray removeAllObjects];
    [HTTP_POST(@"/query/Cw_Jyrb/list") Parameters:dic sucess:^(id responseObject) {
        JDDayListModel * model = [[JDDayListModel alloc] init];
        [model setValuesForKeysWithDictionary:responseObject[@"data"]];
        [_dayListArray addObject:model];
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  利润简报 ==========
-(void)requestQueryxs_cwjylr_list:AD_BLOCK{
    [HTTP_POST(@"/query/Cw_jylr/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  账户收款情况 ==========
-(void)requestQueryxs_cwskqk_list:AD_BLOCK{
    [HTTP_POST(@"/query/Cw_skqk/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ==========  账户付款情况 ==========
-(void)requestQueryxs_cwfkqk_list:AD_BLOCK{
    [HTTP_POST(@"/query/Cw_fkqk/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  库存预警 ==========
-(void)requestQueryckbj_list:AD_BLOCK{
    [HTTP_POST(@"/query/ck_bj/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  客户对账 ==========
-(void)requestQueryyszktj_list:AD_BLOCK{
    [HTTP_POST(@"/query/yszk_tj/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  供应商对账 ==========
-(void)requestQueryyfzktj_list:AD_BLOCK{
    [HTTP_POST(@"/query/yfzk_tj/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  客户对账明细 ==========
-(void)requestQueryyszkmx_list:AD_BLOCK{
    [HTTP_POST(@"/query/yszk_mx/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  供应商对账明细 ==========
-(void)requestQueryyfzkmx_list:AD_BLOCK{
    [HTTP_POST(@"/query/yfzk_mx/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  收款情况统计 ==========
-(void)requestQuerycwskqs_list:AD_BLOCK{
    [HTTP_POST(@"/query/Cw_skqs/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  付款情况统计 ==========
-(void)requestQuerycwfkqs_list:AD_BLOCK{
    [HTTP_POST(@"/query/Cw_fkqs/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ==========  第三页 ==========
-(void)requestThreeShow:AD_BLOCK{
    [HTTP_POST(@"/query/cw_tjfx/show") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 首页营收简报 ==========
-(void)requestqueryCw_Jyjblist:AD_BLOCK{
    [HTTP_POST(@"/query/Cw_Jyjb/list") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 注册发送手机验证码 ==========
-(void)requestRegistSendPhone:AD_BLOCK{
    [HTTP_POST(@"/sys/comm/SendMobileCode") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 注册最后一步 ==========
-(void)requestRegistLastStep:AD_BLOCK{
    [HTTP_POST(@"/main/EnterApply/Add") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 忘记密码发送手机验证码 ==========
-(void)requestForgetSendPhone:AD_BLOCK{
    [HTTP_POST(@"/Auth/changepasssendmobilecode") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 忘记密码最后一步 ==========
-(void)requestForgetSendPhoneLastStep:AD_BLOCK{
    [HTTP_POST(@"/Auth/changepassbymobilecode") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 全部订单 ==========
-(void)requestAllOrderList:AD_BLOCK paramters:(NSString *)paramters{
    [HTTP_POST(paramters) Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 退出登录  ==========
-(void)requestLogOutApp:AD_BLOCK{
    [HTTP_POST(@"/auth/Signout") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        [AD_SHARE_MANAGER outLogin];
    }];
}
#pragma mark ========== 新增客户  ==========
-(void)requestClientList:AD_BLOCK{
    [HTTP_POST(@"/Archives/khda/show") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 客户列表  ==========
-(void)requestAddClient:AD_BLOCK{
    [HTTP_POST(@"/Archives/khda/add") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== edit客户列表  ==========
-(void)requestEditClient:AD_BLOCK{
    [HTTP_POST(@"/Archives/khda/edit") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== delete客户列表  ==========
-(void)requestdeleteClient:AD_BLOCK{
    [HTTP_POST(@"/Archives/khda/delete") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 地址  ==========
-(void)requestAddressList:AD_BLOCK{
    [HTTP_POST(@"/Archives/khda/AddressList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 预定单详情  ==========
-(void)requestxsddShowNote:AD_BLOCK{
    [HTTP_POST(@"/note/xsdd/ShowNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售单详情 ==========
-(void)requestXiaoShouSHowNote:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/ShowNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 终结  ==========
-(void)requestZjCheckNote:AD_BLOCK{
    [HTTP_POST(@"/note/xsdd/ZjCheckNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 出库单保存 ==========
-(void)requestChuKuDanSave:AD_BLOCK{
    [HTTP_POST(@"/note/spck/SaveNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 出库单详情 ==========
-(void)requestChuKuDanDetail:AD_BLOCK{
    [HTTP_POST(@"/note/spck/ShowNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 样品单详情 ==========
-(void)requestYangPinDanDetail:AD_BLOCK{
    [HTTP_POST(@"/note/ypxs/ShowNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 预定单删除 ==========
-(void)requestDelyudingdan:AD_BLOCK{
    [HTTP_POST(@"/note/xsdd/DeleteNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 出库单删除 ==========
-(void)requestDelChuKuDan:AD_BLOCK{
    [HTTP_POST(@"/note/spck/DeleteNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 退货单删除 ==========
-(void)requestDelTuiHuoDan:AD_BLOCK{
    [HTTP_POST(@"/note/xsth/DeleteNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购入库单单删除 ==========
-(void)requestDelCaiGouRuKuDan:AD_BLOCK{
    [HTTP_POST(@"/note/sprk/DeleteNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购退货单单删除 ==========
-(void)requestDelCaiGouTuiHuoDan:AD_BLOCK{
    [HTTP_POST(@"/note/rkth/DeleteNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 收款单删除 ==========
-(void)requestDelskdan:AD_BLOCK{
    [HTTP_POST(@"/note/sk/DeleteNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 付款单删除 ==========
-(void)requestDelFuKuandan:AD_BLOCK{
    [HTTP_POST(@"/note/fk/DeleteNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售删除 ==========
-(void)requestDelXiaoShouDan:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/DeleteNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 样品单删除 ==========
-(void)requestDelYangPinDan:AD_BLOCK{
    [HTTP_POST(@"/note/ypxs/DeleteNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 现货单详情 ==========
-(void)requestXiaoShouDanCaoGaoDetail:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/ShowNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售单审核和反核 ==========
-(void)requestFanShenDan:AD_BLOCK{
    [HTTP_POST(@"/note/xsdd/CheckNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 收款单审核和反核 ==========
-(void)requestShouKuanDanFanShen:AD_BLOCK{
    [HTTP_POST(@"/note/sk/CheckNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 出库单审核和反核 ==========
-(void)requestChuKuFanShenDan:AD_BLOCK{
    [HTTP_POST(@"/note/spck/CheckNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 退货单审核和反核 ==========
-(void)requestTuiHuoFanShenDan:AD_BLOCK{
    [HTTP_POST(@"/note/xsth/CheckNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 样品单审核和反核 ==========
-(void)requestYangPinFanShenDan:AD_BLOCK{
    [HTTP_POST(@"/note/ypxs/CheckNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售单反审 ==========
-(void)requestXiaoShouDanFanShen:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/CheckNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购入库单反审 ==========
-(void)requestCaiGouRuKuDanFanShen:AD_BLOCK{
    [HTTP_POST(@"/note/sprk/CheckNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购退货 单反审 ==========
-(void)requestCaiGouTuiHuoDanFanShen:AD_BLOCK{
    [HTTP_POST(@"/note/rkth/CheckNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 退货单详情 ==========
-(void)requestTuiHuoCaoGaoDetail:AD_BLOCK{
    [HTTP_POST(@"/note/xsth/ShowNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 增加商品 ==========
-(void)requestAddNewSp:AD_BLOCK{
    [HTTP_POST(@"/archives/spda/add") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== edit商品 ==========
-(void)requestEditSp:AD_BLOCK{
    [HTTP_POST(@"/archives/spda/edit") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 客户列表 ==========
-(void)requestKeHuList:AD_BLOCK{
    [HTTP_POST(@"/archives/khda/List") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 收款单保存 ==========
-(void)requestSaveShouKuanDan:AD_BLOCK{
    [HTTP_POST(@"/note/sk/SaveNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 收款单列表 ==========
-(void)requestShowSKList:AD_BLOCK{
    [HTTP_POST(@"/note/sk/ShowNote") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 自动增加颜色 ==========
-(void)requestAutoAddYs:AD_BLOCK{
    [HTTP_POST(@"/archives/Spda_Ys/AutoAddYs") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 自动增加商品 ==========
-(void)requestAutoAddSp:AD_BLOCK{
    [HTTP_POST(@"/archives/spda/AutoAddSp") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 蓝牙打印show ==========
-(void)requestBlueShow:AD_BLOCK{
    [HTTP_POST(@"/sys/config/Show") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark ========== 预定单单打印方式 ==========
-(void)requestYuDingDanBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/xsdd/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 商品销售单打印方式 ==========
-(void)requestXiaoShouBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 商品出库单打印方式 ==========
-(void)requestChuKuBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/spck/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 采购入库单打印方式 ==========
-(void)requestCaiGouRuKuBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/sprk/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购退货单打印方式 ==========
-(void)requestCaiGouTuiHuoBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/rkth/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 付款单打印方式 ==========
-(void)requestFuKuanDanBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/fk/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 样品单打印方式 ==========
-(void)requestYangPinBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/ypxs/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 退货单打印方式 ==========
-(void)requestTuiHuoDanBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/xsth/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 收款打印方式 ==========
-(void)requestShouKuanDanBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/sk/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售单打印保存 ==========
-(void)printXiaoShouSaveAction:AD_BLOCK{
    [HTTP_POST(@"/sys/config/SavePrintConfig") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 出库单远程打印保存 ==========
-(void)printChuKuLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/spck/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售单远程打印保存 ==========
-(void)printXiaoShouLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购入库单远程打印保存 ==========
-(void)printCaiGouRuKuLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/sprk/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购退货单远程打印保存 ==========
-(void)printCaiGouTuiHuoLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/rkth/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 付款单单远程打印保存 ==========
-(void)printFuKuanDanPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/fk/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 预定单远程打印保存 ==========
-(void)printYuDingDanLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/xsdd/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 样品单远程打印保存 ==========
-(void)printYangPinDanLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/ypxs/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 退货单远程打印保存 ==========
-(void)printTuiHuoDanLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/xsth/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 收款单远程打印保存 ==========
-(void)printShouKuanDanLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/sk/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 采购入库单远程打印保存 ==========
-(void)printCaiGouRuKuDanLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/sprk/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 采购出库远程打印保存 ==========
-(void)printCaiGouChuKuDanLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/rkth/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 付款单远程打印保存 ==========
-(void)printFuKuanDanLongPrintSaveAction:AD_BLOCK{
    [HTTP_POST(@"/note/fk/PrintNoteSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}

#pragma mark ========== 商品直发单打印方式 ==========
-(void)requestShangPingZhiFaDanBluePrintWay:AD_BLOCK{
    [HTTP_POST(@"/note/spzf/PrintWayList") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 商品详情 ==========
-(void)requestShangPinDetailAction:AD_BLOCK{
    [HTTP_POST(@"/archives/spda/show") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}







#pragma mark ========== 销售单打印预览 ==========
-(void)printXiaoShouPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售单返回页数 ==========
-(void)printXiaoShouPreviewPageCountAction:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/PrintNotePreviewPageCount") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 销售单返回当前页数 ==========
-(void)printXiaoShouPreviewPageCurpageAction:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/PrintNotePreviewCurpage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 预定单单打印预览 ==========
-(void)printYuDingDanPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/xsdd/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 样品单单打印预览 ==========
-(void)printYangPinDanPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/ypxs/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 退货单单打印预览 ==========
-(void)printTuiHuoDanPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/xsth/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 出库单单单打印预览 ==========
-(void)printChuKuDanPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/spck/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark ========== 收款单单打印预览 ==========
-(void)printShouKuanDanPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/sk/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 颜色单打印预览 ==========
-(void)printSPDAPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/archives/spda/Print_YsPreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 付款单单打印预览 ==========
-(void)printFuKuanDanPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/fk/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购入库单打印预览 ==========
-(void)printCaiGouRuKuDanPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/sprk/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购退货单打印预览  ==========
-(void)printCaiGouTuiHuoDanPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/rkth/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 直发单打印预览 ==========
-(void)printZhiFaDanPreviewAction:AD_BLOCK{
    [HTTP_POST(@"/note/spzf/PrintNotePreview") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark ========== 商品标签打印 ==========
-(void)printSPDAPrintSendMessageAction:AD_BLOCK{
    [HTTP_POST(@"/archives/spda/PrintSendMessage") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

















#pragma mark ========== 销售开始打印 ==========
-(void)printXPXSNoteBytesAction:AD_BLOCK{
    [HTTP_POST(@"/note/spxs/PrintNoteBytes") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 出库单开始打印 ==========
-(void)printChuKuDanNoteBytesAction:AD_BLOCK{
    [HTTP_POST(@"/note/spck/PrintNoteBytes") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 样品开始打印 ==========
-(void)printYangPinDanNoteBytesAction:AD_BLOCK{
    [HTTP_POST(@"/note/ypxs/PrintNoteBytes") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 预定单开始打印 ==========
-(void)printYuDingDanNoteBytesAction:AD_BLOCK{
    [HTTP_POST(@"/note/xsdd/PrintNoteBytes") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 退货单开始打印 ==========
-(void)printTuiHuoDanNoteBytesAction:AD_BLOCK{
    [HTTP_POST(@"/note/xsth/PrintNoteBytes") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 收款单开始打印 ==========
-(void)printShouKuanDanNoteBytesAction:AD_BLOCK{
    [HTTP_POST(@"/note/sk/PrintNoteBytes") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 付款单开始打印 ==========
-(void)printFuKuanDanNoteBytesAction:AD_BLOCK{
    [HTTP_POST(@"/note/fk/PrfintNoteBytes") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购入库单开始打印 ==========
-(void)printCaiGouRuKuDanNoteBytesAction:AD_BLOCK{
    [HTTP_POST(@"/note/sprk/PrintNoteBytes") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 采购退货单开始打印 ==========
-(void)printCaiGouTuiHuoNoteBytesAction:AD_BLOCK{
    [HTTP_POST(@"/note/rkth/PrintNoteBytes") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark ========== 颜色详情 ==========
-(void)requestColorDetailAction:AD_BLOCK{
    [HTTP_POST(@"/archives/pdaselect/SelectYs") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark ========== 查看门店 ==========
-(void)requestAllMdAction:AD_BLOCK{
    [HTTP_POST(@"/archives/mdda/List") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 编辑门店 ==========
-(void)requestEditMdAction:AD_BLOCK{
    [HTTP_POST(@"/archives/mdda/edit") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========== 新增门店 ==========
-(void)requestAddMdAction:AD_BLOCK{
    [HTTP_POST(@"/archives/mdda/add") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 删除门店 ==========
-(void)requestDelMdAction:AD_BLOCK{
    [HTTP_POST(@"/archives/mdda/delete") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ========== 操作记录门店 ==========
-(void)requestMdCaoZuoJiLuAction:AD_BLOCK{
    [HTTP_POST(@"/archives/mdda/Logs") Parameters:dic sucess:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        
    }];
}





#pragma mark ========== 仓库列表 ==========
-(void)requestCKListAction:AD_BLOCK{
    RREQUEST(@"/archives/ckda/List");
}
#pragma mark ========== 仓库信息show ==========
-(void)requestShowCKAction:AD_BLOCK{
    RREQUEST(@"/archives/ckda/show");
}
#pragma mark ========== 仓库edit ==========
-(void)requestEDitCKction:AD_BLOCK{
    RREQUEST(@"/archives/ckda/edit");
}
#pragma mark ========== 仓库add ==========
-(void)requestAddCKction:AD_BLOCK{
    RREQUEST(@"/archives/ckda/add");
}
#pragma mark ========== 仓库删除 ==========
-(void)requestDelCKAction:AD_BLOCK{
    RREQUEST(@"/archives/ckda/delete");
}
#pragma mark ========== 操作记录门店 ==========
-(void)requestCKCaoZuoJiLuAction:AD_BLOCK{
    RREQUEST(@"/archives/ckda/Logs");
}



#pragma mark ========== 财务管理list ==========
-(void)requestCWGLListAction:AD_BLOCK{
    RREQUEST(@"/archives/zhda/List");
}
#pragma mark ========== 财务管理show ==========
-(void)requestCWGLShowAction:AD_BLOCK{
    RREQUEST(@"/archives/zhda/show");
}
#pragma mark ========== 财务管理del ==========
-(void)requestCWGLDelAction:AD_BLOCK{
    RREQUEST(@"/archives/zhda/delete");
}
#pragma mark ========== 财务管理logs ==========
-(void)requestCWGLCaoZuoAction:AD_BLOCK{
    RREQUEST(@"/archives/zhda/Logs");
}
#pragma mark ========== 财务管理edit ==========
-(void)requestCWGLEditAction:AD_BLOCK{
    RREQUEST(@"/archives/zhda/edit");
}
#pragma mark ========== 财务管理add ==========
-(void)requestCWGLAddAction:AD_BLOCK{
    RREQUEST(@"/archives/zhda/add");
}




#pragma mark ========== 送货人管理list ==========
-(void)requestSHRListAction:AD_BLOCK{
    RREQUEST(@"/archives/shrda/List");
}
#pragma mark ========== 送货人管理show ==========
-(void)requestSHRShowAction:AD_BLOCK{
    RREQUEST(@"/archives/shrda/show");
}
#pragma mark ========== 送货人管理del ==========
-(void)requestSHRDelAction:AD_BLOCK{
    RREQUEST(@"/archives/shrda/delete");
}
#pragma mark ========== 送货人管理logs ==========
-(void)requestSHRCaoZuoAction:AD_BLOCK{
    RREQUEST(@"/archives/shrda/Logs");
}
#pragma mark ========== 送货人管理edit ==========
-(void)requestSHREditAction:AD_BLOCK{
    RREQUEST(@"/archives/shrda/edit");
}
#pragma mark ========== 送货人管理add ==========
-(void)requestSHRAddAction:AD_BLOCK{
    RREQUEST(@"/archives/shrda/add");
}








#pragma mark ========== 优惠方式管理list ==========
-(void)requestYHFSListAction:AD_BLOCK{
    RREQUEST(@"/archives/zklxda/List");
}
#pragma mark ========== 优惠方式管理show ==========
-(void)requestYHFSShowAction:AD_BLOCK{
    RREQUEST(@"/archives/zklxda/show");
}
#pragma mark ========== 优惠方式管理del ==========
-(void)requestYHFSDelAction:AD_BLOCK{
    RREQUEST(@"/archives/zklxda/delete");
}
#pragma mark ==========优惠方式管理logs ==========
-(void)requestYHFSCaoZuoAction:AD_BLOCK{
    RREQUEST(@"/archives/zklxda/Logs");
}
#pragma mark ========== 优惠方式管理edit ==========
-(void)requestYHFSEditAction:AD_BLOCK{
    RREQUEST(@"/archives/zklxda/edit");
}
#pragma mark ========== 优惠方式管理add ==========
-(void)requestYHFSAddAction:AD_BLOCK{
    RREQUEST(@"/archives/zklxda/add");
}




#pragma mark ========== 店员管理list ==========
-(void)requestDYShowAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/show");
}
#pragma mark ========== 店员管理list ==========
-(void)requestDYListAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/List");
}
#pragma mark ========== 店员管理del ==========
-(void)requestDYDelAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/delete");
}
#pragma mark ==========店员管理logs ==========
-(void)requestDYCaoZuoAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/Logs");
}
#pragma mark ========== 店员管理edit ==========
-(void)requestDYEditAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/edit");
}
#pragma mark ========== 店员管理add ==========
-(void)requestDYAddAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/add");
}


#pragma mark ========== 意见反馈 ==========
-(void)requestYjfkAction:AD_BLOCK{
    RREQUEST(@"/Main/Comm/AddFeedBack");
}


#pragma mark ========== 权限 ==========
-(void)requestQXJSAction:AD_BLOCK{
    RREQUEST(@"/sys/js/list");
}

#pragma mark ========== 店员发送手机验证码==========
-(void)requestDYSendPhoneCodeAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/SendMobileCode");
}
#pragma mark ========== 批量修改价格 ==========
-(void)requestAllChangePriceAction:AD_BLOCK{
    RREQUEST(@"/archives/spda_ys/BatchEditBySh");
}
#pragma mark ========== 批量修改库存 ==========
-(void)requestAllChangeKuCunAction:AD_BLOCK{
    RREQUEST(@"/archives/spda_ys/BatchEditBySh");
}
#pragma mark ========== 增加新颜色匹数和米数  ==========
-(void)requestAddnewColorAction:AD_BLOCK{
    RREQUEST(@"/note/sppd/SaveSpyskcBySpidSh");
}
#pragma mark ========== 增加图片  ==========
-(void)requestAddNewColorImageAction:AD_BLOCK{
    RREQUEST(@"/archives/spda_ys/EditTp");
}
#pragma mark ========== 新增颜色时候的仓库  ==========
-(void)requestAddnewColorCangKuAction:AD_BLOCK{
    RREQUEST(@"/note/sppd/SaveSpyskcbySpidSh");
}
#pragma mark ========== 增加其他的  ==========
-(void)requestAddnewColorQiTaAction:AD_BLOCK{
    RREQUEST(@"/archives/spda_ys/add");
}
#pragma mark ========== edit图片  ==========
-(void)requestEditNewColorImageAction:AD_BLOCK{
    RREQUEST(@"/archives/spda_ys/edit");
}
#pragma mark ========== 查看颜色地址匹数和数量  ==========
-(void)requestShowColorPiShuAction:AD_BLOCK{
    RREQUEST(@"/Query/ck_kc/ListBySpidSh");
}
#pragma mark ========== 查看颜色其他  ==========
-(void)requestShowColorQiTaAction:AD_BLOCK{
    RREQUEST(@"/archives/spda_ys/show");
}

#pragma mark ========== del图片  ==========
-(void)requestDelNewColorImageAction:AD_BLOCK{
    RREQUEST(@"/archives/spda_ys/delete");
}
#pragma mark ========== 公司信息 ==========
-(void)requestCommanyInfoAction:AD_BLOCK{
    RREQUEST(@"/sys/Config/ShowMobileConfig");
}
#pragma mark ========== 保存公司信息 ==========
-(void)requestSaveCommanyInfoAction:AD_BLOCK{
    RREQUEST(@"/sys/Config/SaveMobileConfig");
}


#pragma mark ========== SPDA远程打印 ==========
-(void)requestSPDAPrintInfoAction:AD_BLOCK{
    RREQUEST(@"/archives/spda/Print_YsWayList");
}
#pragma mark ========== SPDA远程打印 ==========
-(void)requestSPDALastStepPrintInfoAction:AD_BLOCK{
    RREQUEST(@"/archives/spda/Print_YsSendMessage");
}

#pragma mark ==========商品logs ==========
-(void)requestSpCaoZuoAction:AD_BLOCK{
    RREQUEST(@"/archives/spda/Logs");
}
#pragma mark ==========商品del ==========
-(void)requestDelCaoZuoAction:AD_BLOCK{
    RREQUEST(@"/archives/spda/del");
}


#pragma mark ==========商品标签方式 ==========
-(void)requestSpBQWayAction:AD_BLOCK{
    RREQUEST(@"/Archives/spda/PrintWayList");
}

#pragma mark ==========修改库存 ==========
-(void)requestChangeKuCunAction:AD_BLOCK{
    RREQUEST(@"/note/sppd/SelectSpyskc");
}

#pragma mark ==========库存储存 ==========
-(void)requestSaveKuCunAction:AD_BLOCK{
    RREQUEST(@"/note/sppd/SaveSpyskc");
}
#pragma mark ========== 修改头像 ==========
-(void)requestChangeImageAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/EditSelfTp");
}
#pragma mark ========== 修改name ==========
-(void)requestChangeNameAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/EditSelfYgmc");
}
#pragma mark ========== 修改密码 ==========
-(void)requestChangePsdAction:AD_BLOCK{
    RREQUEST(@"/auth/ChangePass");
}

#pragma mark ========== 修改手机号 ==========
-(void)requestChangePhoneAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/SendMobileCode");
}

#pragma mark ========== 查看头像 ==========
-(void)requestAccTouXiangAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/show");
}
#pragma mark ========== edit手机号码 ==========
-(void)requestEditPhoneAction:AD_BLOCK{
    RREQUEST(@"/archives/ygda/EditSelfSjhm");
}
#pragma mark ========== 客户操作记录 ==========
-(void)requestKeHuCaoZuoAction:AD_BLOCK{
    RREQUEST(@"/archives/khda/Logs");
}






#pragma mark ========== 供应商列表 ==========
-(void)requestGongYingShangListAction:AD_BLOCK{
        [HTTP_POST(@"/archives/gysda/List") Parameters:dic sucess:^(id responseObject) {
        [_selectKhPageArray removeAllObjects];
        for (NSDictionary * dic  in responseObject[@"data"][@"list"]) {
            JDSelectClientModel  * model = [[JDSelectClientModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_selectKhPageArray addObject:model];
        }
        successBlock(responseObject);
    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 供应商del ==========
-(void)requestGongYingShangDelAction:AD_BLOCK{
    RREQUEST(@"/Archives/gysda/delete");
}
#pragma mark ========== 供应商add ==========
-(void)requestGongYingShangAddAction:AD_BLOCK{
    RREQUEST(@"/Archives/gysda/add");
}
#pragma mark ========== 供应商edit ==========
-(void)requestGongYingShangEditAction:AD_BLOCK{
    RREQUEST(@"/Archives/gysda/edit");
}
#pragma mark ========== 供应商show ==========
-(void)requestGongYingShangshowAction:AD_BLOCK{
    RREQUEST(@"/Archives/gysda/show");
}

#pragma mark ========== 供应商采购入库save ==========
-(void)requestCaiGouRuKuSaveAction:AD_BLOCK{
    RREQUEST(@"/note/sprk/savenote");
}
#pragma mark ========== 供应商采购退货 ==========
-(void)requestCaiGouTuiHuoSaveAction:AD_BLOCK{
    RREQUEST(@"/note/rkth/SaveNote");
}
#pragma mark ========== 供应商采购入库show ==========
-(void)requestCaiGouRuKuShowAction:AD_BLOCK{
    RREQUEST(@"/note/sprk/ShowNote");
}
#pragma mark ========== 供应商采购退货show ==========
-(void)requestCaiGouTuiHuoShowAction:AD_BLOCK{
    RREQUEST(@"/note/rkth/ShowNote");
}
#pragma mark ========== 直发单show ==========
-(void)requestZhiFaShowAction:AD_BLOCK{
    RREQUEST(@"/note/spzf/ShowNote");
}
#pragma mark ========== 付款单审核和反核 ==========
-(void)requestFuKuanDanFanShen:AD_BLOCK{
    RREQUEST(@"/note/fk/CheckNote");
}
#pragma mark ========== 收款单保存 ==========
-(void)requestSaveFuKuanDan:AD_BLOCK{
        RREQUEST(@"/note/fk/SaveNote");
}
#pragma mark ========== 付款单列表 ==========
-(void)requestShowFKList:AD_BLOCK{
       RREQUEST(@"/note/fk/ShowNote");
}
#pragma mark ========== 单子分享分享 ==========
-(void)requestShareWeiXin:AD_BLOCK notetype:(NSString *)notetype{
    RREQUEST([[@"/note/" append:notetype] append:@"/GetShareInfo"]);
}


#pragma mark ========== 供应商新增 ==========
-(void)requestAddGongYingShangList:AD_BLOCK{
    RREQUEST(@"/Archives/gysda/add");
}
#pragma mark ========== 供应商edit ==========
-(void)requestEditGongYingShangList:AD_BLOCK{
    RREQUEST(@"/Archives/gysda/edit");
}
#pragma mark ========== 供应商edit ==========
-(void)requestDelGongYingShangList:AD_BLOCK{
    RREQUEST(@"/Archives/gysda/delete");
}


#pragma mark ========== 供应商应付 ==========
-(void)requestYingFuGongYingShangList:AD_BLOCK{
    RREQUEST(@"/note/yfcsh/SaveYfzk");
}



#pragma mark ========== 联系人add ==========
-(void)requestaddLxrList:AD_BLOCK{
    RREQUEST(@"/Archives/gysda_lxr/BatchEdit");
}
#pragma mark ========== 联系人edit ==========
-(void)requestEditLxrList:AD_BLOCK{
    RREQUEST(@"/Archives/gysda_lxr/edit");
}
#pragma mark ========== 联系人删除 ==========
-(void)requestDelLxrList:AD_BLOCK{
    RREQUEST(@"/Archives/gysda_lxr/delete");
}
#pragma mark ========== 联系人列表 ==========
-(void)requestLxrList:AD_BLOCK{
    RREQUEST(@"/archives/gysda_lxr/List");
}
#pragma mark ========== 联系人show ==========
-(void)requestGYSShowList:AD_BLOCK{
    RREQUEST(@"/Archives/gysda/show");
}
#pragma mark ========== 供应商操作记录 ==========
-(void)requestGYSCaoZuoAction:AD_BLOCK{
    RREQUEST(@"/Archives/gysda/Logs");
}

#pragma mark ========== 客户应付 ==========
-(void)requestKeHuYingFuList:AD_BLOCK{
    RREQUEST(@"/note/yscsh/SaveYszk");
}
#pragma mark ========== 订单号 ==========
-(void)requestJiaGongOrderList:AD_BLOCK{
    RREQUEST(@"/note/xsdd/GetCommonXsddList");
}
#pragma mark ========== 加工发货 ==========
-(void)requestJiaGongFaHuoUp:AD_BLOCK{
    RREQUEST(@"/note/jgfh/savenote");
}
#pragma mark ========== 加工转厂 ==========
-(void)requestJiaGongZhuanChangUp:AD_BLOCK{
    RREQUEST(@"/note/jgzc/savenote");
}
#pragma mark ========== 原料入库 ==========
-(void)requestYuanLiaoRuKuUp:AD_BLOCK{
    RREQUEST(@"/note/jhrk/savenote");
}
#pragma mark ========== 加工收货 ==========
-(void)requestJiaGongShouHuoUp:AD_BLOCK{
    RREQUEST(@"/note/jgsh/savenote");
}
#pragma mark ========== 客户联系人add ==========
-(void)requestaddKhLxrList:AD_BLOCK{
    RREQUEST(@"/Archives/khda_lxr/BatchEdit");
}
#pragma mark ========== 所有权限 ==========
-(void)getRefreshQuanXianData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"":@""}];
    [HTTP_POST(@"/sys/power/getPermissions") Parameters:mDic sucess:^(id responseObject) {
        weakself.quanXianDic = [[NSMutableDictionary alloc]initWithDictionary:responseObject[@"data"]];
        NSMutableArray * menusArray = [[NSMutableArray alloc]init];
        for (NSNumber * number in AD_MANAGER.quanXianDic[@"menus"]) {
            [menusArray addObject:kGetString(number)];
        }
        [weakself.quanXianDic setValue:menusArray forKey:@"menus"];

    } failure:^(NSError *error) {
    }];
}
#pragma mark ========== 客户标签 ==========
-(void)requestKeHuBiaoQianList:AD_BLOCK{
    RREQUEST(@"/Archives/khda/TagList");
}
#pragma mark ========== 加工方式 ==========
-(void)requestJiaGongFangShi:AD_BLOCK{
    RREQUEST(@"/Archives/Jgfsda/List");
}
#pragma mark ========== 加工库存 ==========
-(void)requestGongChangKuCun:AD_BLOCK{
    RREQUEST(@"/query/gc_kc/Execute_Mobile");
}

#pragma mark ========== 颜色库存明细 ==========
-(void)requestColorKucunMingXi:AD_BLOCK{
    RREQUEST(@"/Query/Ck_Kcmx/Execute");
}


#pragma mark ========== 应收账款明细 ==========
-(void)requestKeHuYszk:AD_BLOCK{
    RREQUEST(@"/query/Yszk_Zb/Execute_Spys");
}
#pragma mark ========== 最新价 ==========
-(void)requestNewPrice:AD_BLOCK{
    RREQUEST(@"/sys/comm/getxsdj");
}
#pragma mark ========== 客户对账单分享 ==========
-(void)requestKeHuDuiZhangDanGetWay:AD_BLOCK{
    RREQUEST(@"/query/Yszk_Zb/PrintWay_SpysList");
}
#pragma mark ========== 取得页数 ==========
-(void)requestKeHuDuiZhangDanYeShu:AD_BLOCK{
    RREQUEST(@"/query/Yszk_Zb/Execute_Spys_PrintNoteImageCount");
}
#pragma mark ========== 取得图片 ==========
-(void)requestKeHuDuiZhangDanTuPian:AD_BLOCK{
    RREQUEST(@"/query/Yszk_Zb/Execute_Spys_PrintNoteImage");
}
#pragma mark --------------------初始化数据--------------------
- (instancetype)init{
    _userDataArray = [NSMutableArray array];
    _selectKhPageArray = [NSMutableArray array];
    _selectSpPageArray = [NSMutableArray array];
    _addColorArray     = [NSMutableArray array];
    _sectionArray    = [NSMutableArray array];
    _selectCkPageArray = [NSMutableArray array];
    _selectYgPageArray = [NSMutableArray array];
    _selectShrPageArray = [NSMutableArray array];
    _selectZHArray = [NSMutableArray array];
    _selectZHlxArray = [NSMutableArray array];
    _salesBtnArray = [NSMutableArray array];
    _affrimDic = [[NSMutableDictionary alloc]init];
    
    
    
    _caoGaoDic = [[NSMutableDictionary alloc]init];

    _kLineArray = [NSMutableArray array];
    _piexArray = [NSMutableArray array];
    _dayListArray = [NSMutableArray array];
    _markArray = [NSMutableArray array];
    _printWay = [[NSMutableDictionary alloc]init];
    
    _debugNewGoodsArray =[NSMutableArray array];
//    _zhifuImageDic = @{}
    
    
    _data = [[NSMutableDictionary alloc]init];
    
    
    
    
    return self;
}
@end
