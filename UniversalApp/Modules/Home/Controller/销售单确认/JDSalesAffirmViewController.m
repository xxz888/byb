//
//  JDSalesAffirmViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSalesAffirmViewController.h"
#import "JDSalesAffirmTableViewController.h"
#import "JDCollectMoneyViewController.h"
#import "JDSelectSpModel.h"
#import "JDSuccessVCViewController.h"
#import "JDAllOrderViewController.h"
#import "YBPopupMenu.h"
#import "JDAddSpViewController.h"
@interface JDSalesAffirmViewController ()<YBPopupMenuDelegate>
@property(nonatomic,strong)JDSalesAffirmTableViewController * VC;
@property (nonatomic,strong) NSDictionary * _dic1;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end
@implementation JDSalesAffirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self setUIAction];
    [self requestCKShrYgArray];
    
}


#pragma mark ========== 商品列表。退货和销售单的公用方法 ==========
-(NSMutableArray *)  allOrderXiaoShouTuiHuoListCommonParamtersArray{
    NSMutableArray * spxscbsArr = [[NSMutableArray alloc]init];
    //计算多少商品
    NSInteger spxdnxh = 0;
    for (NSInteger i = 0 ; i < AD_MANAGER.sectionArray.count; i++) {
        NSString * spid = [self inKeyOutSpid:i];
        NSString * key = [AD_MANAGER.sectionArray[i] allKeys][0];
        //找到一个商品对应的colormodel
        NSArray * jjfsArray ;
        NSArray * countArr = AD_MANAGER.sectionArray[i][key];
        for (JDSelectSpModel * spModle in AD_MANAGER.selectSpPageArray) {
            if ([[AD_MANAGER.sectionArray[i] allKeys][0] intValue] == spModle.spid) {
                spid = NSIntegerToNSString(spModle.spid);
                jjfsArray = @[spModle.jldw,spModle.fjldw];
            }
        }

        for (JDAddColorModel * colorModel in countArr) {
            for (NSDictionary * dic in colorModel.psArray) {
                NSMutableDictionary * spxscbsDic = [[NSMutableDictionary alloc]init];
                spxdnxh += 1;
                [spxscbsDic setValue:@"1" forKey:@"xsps"];//匹数
                [spxscbsDic setValue:spid forKey:@"spid"];//商品ID
                [spxscbsDic setValue:colorModel.sh forKey:@"sh"];//色号
                [spxscbsDic setValue:@([colorModel.savekongcha doubleValue]) forKey:@"spkc"];//空差
                [spxscbsDic setValue:colorModel.saveKhkh forKey:@"khkh"];//客户款号（客户货号） 可空字符串
                
                [spxscbsDic setValue:colorModel.saveBz forKey:@"bz"];//备注
                [spxscbsDic setValue:@([colorModel.savePrice doubleValue]) forKey:@"xsdj"];//销售单价
                [spxscbsDic setValue:@([dic[@"xssl"] doubleValue]) forKey:@"xssl"];//销售数量
                [spxscbsDic setValue:@([dic[@"xsfsl"] doubleValue]) forKey:@"xsfsl"];//销售副数量
                [spxscbsDic setValue:@(colorModel.saveZhuFuTag) forKey:@"jjfs"];//销售主单位
                
                [spxscbsDic setValue:NSIntegerToNSString(spxdnxh) forKey:@"dnxh"];//单内序号
                double count = colorModel.saveZhuFuTag == 0 ? [dic[@"xssl"] doubleValue] : [dic[@"xsfsl"] doubleValue];
                [spxscbsDic setValue:kGet2fDouble([colorModel.savePrice doubleValue] * ([colorModel.savekongcha doubleValue] + count)) forKey:@"xsje"];//销售金额
                
                
                
                
                
                for (NSDictionary * oldDic in ORDER_ISEQUAl(XiaoShouDan) ? AD_MANAGER.caoGaoDic[@"tbnote_spxscbs"] : ORDER_ISEQUAl(CaiGouTuiHuoDan) ?AD_MANAGER.caoGaoDic[@"tbnote_rkthcbs"]  : AD_MANAGER.caoGaoDic[@"tbnote_xsthcbs"]) {
                    if ([oldDic[@"ys"] isEqualToString:colorModel.ys]) {
                        [spxscbsDic setValue:oldDic[@"gh"] forKey:@"gh"];//缸号
                        [spxscbsDic setValue:oldDic[@"sfm"] forKey:@"sfm"];//身份码
                        [spxscbsDic setValue:oldDic[@"fslbl"] forKey:@"fslbl"];//辅数量比率
                        [spxscbsDic setValue:oldDic[@"cdbm"] forKey:@"cdbm"];
                        [spxscbsDic setValue:oldDic[@"cdid"] forKey:@"cdid"];
                        [spxscbsDic setValue:oldDic[@"cdmc"] forKey:@"cdmc"];
                        [spxscbsDic setValue:oldDic[@"sphh"] forKey:@"sphh"];
                        [spxscbsDic setValue:oldDic[@"fjldw"] forKey:@"fjldw"];
                        [spxscbsDic setValue:oldDic[@"jldw"] forKey:@"jldw"];
                        [spxscbsDic setValue:oldDic[@"ys"] forKey:@"ys"];
                        [spxscbsDic setValue:oldDic[@"spmc"] forKey:@"spmc"];


                        [spxscbsDic setValue:oldDic[@"djhm"] forKey:@"djhm"];
          

                    }
                }
                
                
                
               
                //商品列表
                [spxscbsArr addObject:spxscbsDic];
                spxdnxh += 1;
            }
        }
    }
    return spxscbsArr;
}
#pragma mark ========== 采购入库的公用方法 ==========
-(NSMutableArray *)allOrderCaiGouRuKuListCommonParamtersArray{
    NSMutableArray * spxscbsArr = [[NSMutableArray alloc]init];
    //计算多少商品
    NSInteger spxdnxh = 0;
    for (NSInteger i = 0 ; i < AD_MANAGER.sectionArray.count; i++) {
        NSString * spid = [self inKeyOutSpid:i];
        NSString * key = [AD_MANAGER.sectionArray[i] allKeys][0];
        //找到一个商品对应的colormodel
        NSArray * jjfsArray ;
        NSArray * countArr = AD_MANAGER.sectionArray[i][key];
        for (JDSelectSpModel * spModle in AD_MANAGER.selectSpPageArray) {
            if ([[AD_MANAGER.sectionArray[i] allKeys][0] intValue] == spModle.spid) {
                spid = NSIntegerToNSString(spModle.spid);
                jjfsArray = @[spModle.jldw,spModle.fjldw];
            }
        }
        //查找颜色的model
        for (JDAddColorModel * colorModel in countArr) {
            NSMutableDictionary * spxscbsDic = [[NSMutableDictionary alloc]init];
            spxdnxh += 1;
            
            for (NSDictionary * oldDic in  AD_MANAGER.caoGaoDic[@"tbnote_sprkcbs"]) {
                if ([oldDic[@"spid"] integerValue] == colorModel.spid) {
                    [spxscbsDic setValue:oldDic[@"gh"] forKey:@"gh"];//缸号
                    [spxscbsDic setValue:oldDic[@"fslbl"] forKey:@"fslbl"];//辅数量比率
                    [spxscbsDic setValue:oldDic[@"cdbm"] forKey:@"cdbm"];
                    [spxscbsDic setValue:oldDic[@"cdid"] forKey:@"cdid"];
                    [spxscbsDic setValue:oldDic[@"cdmc"] forKey:@"cdmc"];
                    [spxscbsDic setValue:oldDic[@"sphh"] forKey:@"sphh"];
                    [spxscbsDic setValue:oldDic[@"fjldw"] forKey:@"fjldw"];
                    [spxscbsDic setValue:oldDic[@"jldw"] forKey:@"jldw"];
                    [spxscbsDic setValue:oldDic[@"spmc"] forKey:@"spmc"];
                    [spxscbsDic setValue:oldDic[@"ys"] forKey:@"ys"];
                    [spxscbsDic setValue:oldDic[@"bz"] forKey:@"bz"];//备注
                    [spxscbsDic setValue:oldDic[@"jjfs"] forKey:@"jjfs"];
                    [spxscbsDic setValue:oldDic[@"sphh"] forKey:@"sphh"];


                }
            }
            
            [spxscbsDic setValue:NSIntegerToNSString(spxdnxh) forKey:@"dnxh"];//单内序号
            [spxscbsDic setValue:spid forKey:@"spid"];//商品ID
            [spxscbsDic setValue:colorModel.sh forKey:@"sh"];//色号
            [spxscbsDic setValue:@"0" forKey:@"gh"];//缸号
            [spxscbsDic setValue:@(colorModel.psArray.count) forKey:@"spps"];
            
            double allSpsl = 0;
            double allSpfsl = 0;
           for (NSDictionary * dic in colorModel.psArray) {
               allSpsl += [dic[@"xssl"] doubleValue];
               allSpfsl += [dic[@"xsfsl"] doubleValue];
            }
            
            [spxscbsDic setValue:@(allSpsl) forKey:@"spsl"];//商品数量
            [spxscbsDic setValue:@(allSpfsl) forKey:@"spfsl"];//商品副数量
            [spxscbsDic setValue:@([colorModel.savekongcha doubleValue]) forKey:@"spkc"];//总空差
            [spxscbsDic setValue:@([colorModel.savePrice doubleValue]) forKey:@"spdj"];//单价
            
            double count = colorModel.saveZhuFuTag == 0 ? allSpsl : allSpfsl;
            [spxscbsDic setValue:kGet2fDouble([colorModel.savePrice doubleValue] * ([colorModel.savekongcha doubleValue] + count)) forKey:@"spje"];//商品金额
            [spxscbsDic setValue:@(colorModel.saveZhuFuTag) forKey:@"jjfs"];//计价方式
            
            
            
            NSMutableArray * tbnote_sprkcb_mxsArray = [[NSMutableArray alloc]init];
            
            for (NSInteger kk = 0; kk < colorModel.psArray.count; kk++) {
                NSDictionary * dic = colorModel.psArray[kk];
                NSMutableDictionary * tbnote_sprkcb_mxs = [[NSMutableDictionary alloc]init];
                [tbnote_sprkcb_mxs setValue:@0 forKey:@"rkxh"];//入库序号 修改保持 新增可0
                [tbnote_sprkcb_mxs setValue:@0 forKey:@"dnxh"];//单内序号 即商品序号 修改保持 新增可0
                [tbnote_sprkcb_mxs setValue:@([dic[@"xssl"] doubleValue]) forKey:@"spsl"];//商品数量
                [tbnote_sprkcb_mxs setValue:@([dic[@"xsfsl"] doubleValue]) forKey:@"spfsl"];//商品副数量
       
                
                for (NSDictionary * oldDic in  AD_MANAGER.caoGaoDic[@"tbnote_sprkcbs"]) {
                        if ([oldDic[@"tbnote_sprkcb_mxs"] count] > i) {
                            if ([oldDic[@"spid"] integerValue] == colorModel.spid) {

                            [tbnote_sprkcb_mxs setValue:oldDic[@"tbnote_sprkcb_mxs"][i][@"rkxh"] forKey:@"rkxh"];
                            [tbnote_sprkcb_mxs setValue:oldDic[@"tbnote_sprkcb_mxs"][i][@"dnxh"] forKey:@"dnxh"];
                            [tbnote_sprkcb_mxs setValue:oldDic[@"tbnote_sprkcb_mxs"][i][@"bz"] forKey:@"bz"];
                            [tbnote_sprkcb_mxs setValue:oldDic[@"tbnote_sprkcb_mxs"][i][@"fslbl"] forKey:@"fslbl"];
                            [tbnote_sprkcb_mxs setValue:oldDic[@"tbnote_sprkcb_mxs"][i][@"gh"] forKey:@"gh"];
                            [tbnote_sprkcb_mxs setValue:oldDic[@"tbnote_sprkcb_mxs"][i][@"jh"] forKey:@"jh"];
                            [tbnote_sprkcb_mxs setValue:oldDic[@"tbnote_sprkcb_mxs"][i][@"sfm"] forKey:@"sfm"];
                            
                            
                        }
                        }
                    
                }
                [tbnote_sprkcb_mxsArray addObject:tbnote_sprkcb_mxs];
            }
   
            [spxscbsDic setValue:tbnote_sprkcb_mxsArray forKey:@"tbnote_sprkcb_mxs"];//商品明细数组，只有入库采购才有
            //商品列表
            [spxscbsArr addObject:spxscbsDic];
        }
        
    }
    return spxscbsArr;
}
#pragma mark ========== 样品单和预定单公用的商品列表方法 ==========
-(NSMutableArray *)allOrderYangPinYuDingListCommonParamtersArray{
    //商品列表取值
    NSMutableArray * spxscbsArr = [[NSMutableArray alloc]init];
    //计算多少商品
    NSInteger spxdnxh = 0;
    for (NSInteger i = 0 ; i < AD_MANAGER.sectionArray.count; i++) {

        NSString * spidKey = [AD_MANAGER.sectionArray[i] allKeys][0];
        //找到一个商品对应的colormodel
        NSArray * countArr = AD_MANAGER.sectionArray[i][spidKey];
        //查找颜色的model
        
        for (NSInteger i = 0; i < countArr.count; i++) {
            JDAddColorModel * colorModel = countArr[i];
            NSMutableDictionary * spxscbsDic = [[NSMutableDictionary alloc]init];
            spxdnxh += 1;
            
            //原来就有的，pc需要，手机不需要的需要保存原来参数
            NSString * key = ORDER_ISEQUAl(YangPinDan) ? @"tbnote_ypxscbs" : @"tbnote_xsddcbs";
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"cdbm"] forKey:@"cdbm"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"cdid"] forKey:@"cdid"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"cdmc"] forKey:@"cdmc"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"cksl"] forKey:@"cksl"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"ddps"] forKey:@"ddps"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"ddsl"] forKey:@"ddsl"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"fjldw"] forKey:@"fjldw"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"fslbl"] forKey:@"fslbl"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"jldw"] forKey:@"jldw"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"sphh"] forKey:@"sphh"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"spmc"] forKey:@"spmc"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"spzt"] forKey:@"spzt"];
            [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"fjldw"] forKey:@"fjldw"];

            //这个是手机传的参数
            if (AD_MANAGER.caoGaoDic[key][i][@"dnxh"]) {
                [spxscbsDic setValue:AD_MANAGER.caoGaoDic[key][i][@"dnxh"] forKey:@"dnxh"];//单内序号
            }else{
                [spxscbsDic setValue:NSIntegerToNSString(spxdnxh) forKey:@"dnxh"];//单内序号
            }
            [spxscbsDic setValue:spidKey forKey:@"spid"];//商品ID
            [spxscbsDic setValue:colorModel.sh forKey:@"sh"];//色号
            [spxscbsDic setValue:@([colorModel.savePishu integerValue]) forKey:@"xsps"];//匹数
            [spxscbsDic setValue:@([colorModel.saveCount doubleValue]) forKey:@"xssl"];//销售数量
            [spxscbsDic setValue:@([colorModel.savePrice doubleValue]) forKey:@"xsdj"];//销售单价
            
            
            [spxscbsDic setValue:kGet2fDouble([colorModel.savePrice doubleValue] * ([colorModel.saveCount doubleValue] + [colorModel.savekongcha doubleValue])) forKey:@"xsje"];//销售金额
            
            [spxscbsDic setValue:colorModel.saveKhkh forKey:@"khkh"];//客户款号（客户货号） 可空字符串
            [spxscbsDic setValue:colorModel.saveBz forKey:@"bz"];//备注
            [spxscbsDic setValue:@(colorModel.saveZhuFuTag) forKey:@"jjfs"];//单位
            
            [spxscbsDic setValue:colorModel.savekongcha forKey:@"mpkc"];//空差
            
            //商品列表
            [spxscbsArr addObject:spxscbsDic];
            spxdnxh += 1;
        }
    }
    return spxscbsArr;
}
//所有单据的参数，并且传到下个页面的共同参数
-(void)allOrderCommonParamters{
    LoginModel * model = AD_USERDATAARRAY;
    [AD_MANAGER.caoGaoDic setValue:[NSString currentDateString] forKey:@"zdrq"];//制单日期 否
    [AD_MANAGER.caoGaoDic setValue:[NSString currentDateStringyyyyMMdd] forKey:@"rzrq"];//入账日期
    [AD_MANAGER.caoGaoDic setValue:[NSString currentDateStringHHmmss] forKey:@"rzsj"];//入账时间
    [AD_MANAGER.caoGaoDic setValue:@([AD_SHARE_MANAGER inCangkuNameOutCangkuId:self.VC.btn3.titleLabel.text]) forKey:@"ckid"];//仓库id ?
    
    if (CaiGouBOOL) {
        [AD_MANAGER.caoGaoDic setValue:[NSString currentDateStringHHmmss] forKey:@"xsddh"];//销售订单号 可空字符串
        [AD_MANAGER.caoGaoDic setValue:@([AD_SHARE_MANAGER inYeWuYuanNameOutYeWuYuanId:self.VC.btn4.titleLabel.text]) forKey:@"jsrid"];
        
    }
    
    JDSelectClientModel * clientModel = [AD_SHARE_MANAGER inKeHuNameOutKeHuId:self.VC.btn1.titleLabel.text];
    if (clientModel) {
        if (CaiGouBOOL) {
            [AD_MANAGER.caoGaoDic setValue:@(clientModel.gysid) forKey:@"gysid"];//供应商名称id
            [AD_MANAGER.caoGaoDic setValue:clientModel.gysmc forKey:@"gysmc"];//供应商名称 （如khid=0，表示已该名称新增客户）
        }else{
            [AD_MANAGER.caoGaoDic setValue:@(clientModel.Khid) forKey:@"khid"];//供应商名称id
            [AD_MANAGER.caoGaoDic setValue:clientModel.khmc forKey:@"khmc"];//供应商名称 （如khid=0，表示已该名称新增客户）
        }

    }else{//如果是
        if (CaiGouBOOL) {
            if (AD_MANAGER.caoGaoDic[@"gysid"] && AD_MANAGER.caoGaoDic[@"gysmc"]) {
                [AD_MANAGER.caoGaoDic setValue:@([AD_MANAGER.caoGaoDic[@"gysid"] integerValue]) forKey:@"gysid"];//客户id
                [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.caoGaoDic[@"gysmc"] forKey:@"gysmc"];//供应商名称 （如khid=0，表示已该名称新增客户）
            }else{
                [AD_MANAGER.caoGaoDic setValue:@(0) forKey:@"gysid"];//客户id
                [AD_MANAGER.caoGaoDic setValue:clientModel.khmc forKey:@"gysmc"];//供应商名称 （如khid=0，表示已该名称新增客户）
            }
        }else{
            if (AD_MANAGER.caoGaoDic[@"khid"] && AD_MANAGER.caoGaoDic[@"khmc"]) {
                [AD_MANAGER.caoGaoDic setValue:@([AD_MANAGER.caoGaoDic[@"khid"] integerValue]) forKey:@"khid"];//客户id
                [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.caoGaoDic[@"kcmc"] forKey:@"khmc"];//客户名称 （如khid=0，表示已该名称新增客户）
            }else{
                [AD_MANAGER.caoGaoDic setValue:@(0) forKey:@"khid"];//客户id
                [AD_MANAGER.caoGaoDic setValue:clientModel.khmc forKey:@"khmc"];//客户名称 （如khid=0，表示已该名称新增客户）
            }
        }
 

    }
    

    [AD_MANAGER.caoGaoDic setValue:@([AD_SHARE_MANAGER inYeWuYuanNameOutYeWuYuanId:self.VC.btn5.titleLabel.text]) forKey:@"ywyid"];//业务员ID
    [AD_MANAGER.caoGaoDic setValue:self.VC.btn4.titleLabel.text forKey:@"yjfhrq"];//预定发货日期
    [AD_MANAGER.caoGaoDic setValue:self.VC.tf2.text forKey:@"shdz"];//收货地址
    [AD_MANAGER.caoGaoDic setValue:@"1" forKey:@"tag"];
    [AD_MANAGER.caoGaoDic setValue:[self.VC.bzTV.text isEqualToString:@"填写你的备注(选填)"] ? @"" :self.VC.bzTV.text  forKey:@"djbz"];//单据备注
    [AD_MANAGER.caoGaoDic setValue:@"" forKey:@"bjmc"];//标记名称 可空字符串(修改时请保留原值)
    [AD_MANAGER.caoGaoDic setValue:model.mdid forKey:@"mdid"];//门店Id
    
    NSString * djhm = AD_MANAGER.caoGaoDic[@"djhm"];
    [AD_MANAGER.caoGaoDic setValue:djhm.length == 0 ? @"" : djhm   forKey:@"djhm"];//单据号码 否
    NSInteger djzt = [AD_MANAGER.caoGaoDic[@"djzt"] integerValue];
    [AD_MANAGER.caoGaoDic setValue:djzt ? @(djzt) : @0 forKey:@"djzt"];//单据状态  djzt=0时，为新增 djzt=1时：为修改
}
-(JDSelectClientModel *)getClientModel{
    return [AD_SHARE_MANAGER inKeHuNameOutKeHuId:self.VC.btn1.titleLabel.text];
}
#define TITLES @[@"草稿",@"提交",@"打印",@"删单"]
-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:TITLES icons:nil menuWidth:120 delegate:self];
}
#pragma mark - 右上角更多的小弹框
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (index == 0) {//草稿
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
        if (ORDER_ISEQUAl(YuDingDan)) {
            VC.selectTag1 = 0;
        }else if(ORDER_ISEQUAl(XiaoShouDan)){
            VC.selectTag1 = 2;
        }else if(ORDER_ISEQUAl(YangPinDan)){
            VC.selectTag1 = 3;
        }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
            VC.selectTag1 = 6;
        }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
            VC.selectTag1 = 7;
        }
        [self.navigationController pushViewController:VC animated:YES];
    }else if (index == 1){//提交
        if (ORDER_ISEQUAl(YuDingDan)) {
            [self yudingdanCommonAction:1];
        }else if(ORDER_ISEQUAl(YangPinDan)){
            [self setXiaoShouDanAction];
        }else if(ORDER_ISEQUAl(XiaoShouDan)){
            [self setXiaoShouDanAction];
        }else if(ORDER_ISEQUAl(TuiHuoDan)){
            [self setTuiHuoDanAction:1];
        }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
            [self setXiaoShouDanAction];
        }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
            [self setCaiGouTuiHuoDanAction:1];
        }
    }else if (index == 2){
        AD_MANAGER.noteno = AD_MANAGER.caoGaoDic[@"djhm"];
        [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
    }else{
        kWeakSelf(self);
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":AD_MANAGER.caoGaoDic[@"djhm"]}];
        if (ORDER_ISEQUAl(YuDingDan) ) {
            [AD_MANAGER requestDelyudingdan:mDic success:^(id object) {
                [weakself showToast:@"删除订单成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
        }else if ( ORDER_ISEQUAl(XiaoShouDan)){
            [AD_MANAGER requestDelXiaoShouDan:mDic success:^(id object) {
                [weakself showToast:@"删除订单成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
        }
        else if(ORDER_ISEQUAl(YangPinDan)){
            [AD_MANAGER requestDelYangPinDan:mDic success:^(id object) {
                [weakself showToast:@"删除订单成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
        }else if(ORDER_ISEQUAl(TuiHuoDan)){
            [AD_MANAGER requestDelTuiHuoDan:mDic success:^(id object) {
                [weakself showToast:@"删除订单成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
        }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
            [AD_MANAGER requestDelCaiGouRuKuDan:mDic success:^(id object) {
                [weakself showToast:@"删除订单成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
        }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
            [AD_MANAGER requestDelCaiGouTuiHuoDan:mDic success:^(id object) {
                [weakself showToast:@"删除订单成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
        }
            
        
    }
}
#pragma mark ========== 初始化的方法 ==========
-(void)setUIAction{
    self.title =
    
    ORDER_ISEQUAl(YuDingDan) ? @"预定单确认" :
    ORDER_ISEQUAl(XiaoShouDan) ? @"销售单确认" :
    ORDER_ISEQUAl(YangPinDan) ? @"样品单确认" :
    ORDER_ISEQUAl(TuiHuoDan)  ? @"退货单确认":
    ORDER_ISEQUAl(CaiGouRuKuDan)  ? @"采购入库单确认":
    ORDER_ISEQUAl(CaiGouTuiHuoDan)  ? @"采购退货单确认":

    
    @"";
    
    
    
    [self.nextBtn setTitle:
     ORDER_ISEQUAl(YuDingDan) ? @"下单" :
     ORDER_ISEQUAl(XiaoShouDan) ? @"下一步" :
     ORDER_ISEQUAl(YangPinDan) ? @"下一步" :
     ORDER_ISEQUAl(TuiHuoDan)  ? @"下单":
     ORDER_ISEQUAl(CaiGouTuiHuoDan)  ? @"确认退货":
     ORDER_ISEQUAl(CaiGouRuKuDan)  ? @"下一步":@""
     forState:0];
    
    
    self.allPriceLbl.text = AD_MANAGER.affrimDic[@"allPrice"];

    
    if (AD_MANAGER.caoGaoDic) {
        [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@9009]];
    }
}
//
-(NSString *)getAllPrice{
    double je = 0;
    NSString * jeString = ORDER_ISEQUAl(XiaoShouDan) ? @"tbnote_spxscbs" :
     ORDER_ISEQUAl(YangPinDan) ? @"tbnote_ypxscbs" :
     ORDER_ISEQUAl(YuDingDan) ? @"tbnote_xsddcbs" :
     ORDER_ISEQUAl(TuiHuoDan) ? @"tbnote_xsthcbs" :
     ORDER_ISEQUAl(CaiGouRuKuDan) ? @"tbnote_sprkcbs" :
     ORDER_ISEQUAl(CaiGouTuiHuoDan) ? @"tbnote_rkthcbs" :

    
    @"";
    for (NSDictionary * dic in AD_MANAGER.caoGaoDic[jeString]) {
        je += [dic[@"xsje"] doubleValue];
    }
    if (je == 0) {
        return self.allPrice;
    }else{
        return doubleToNSString(je);

    }
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"JDSalesAffirmTableViewController"]) {
        JDSalesAffirmTableViewController * nav = [segue destinationViewController];
        self.VC = nav;
        AD_MANAGER.caoGaoDic = [NSMutableDictionary dictionaryWithDictionary:AD_MANAGER.caoGaoDic];
    }
}
#pragma mark ========== 请求仓库 送货人 业务员数组 ==========
-(void)requestCKShrYgArray{
    NSMutableDictionary* mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pagesize":@"500"}];
    NSMutableDictionary* mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    NSMutableDictionary* mDic3 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pagesize":@"500",@"pon":@"",@"keywords":@""}];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];

    [AD_MANAGER requestSelectCkPage:mDic1 success:^(id object) {}];
    [AD_MANAGER requestSelectYgPage:mDic3 success:^(id object) {}];
    [AD_MANAGER requestSelectShrPage:mDic2 success:^(id object){}];
    if (CaiGouBOOL) {
        [AD_MANAGER requestGongYingShangListAction:mDic success:^(id str) {}];
    }else{
        [AD_MANAGER requestSelectKhPage:mDic success:^(id str) {}];

    }
}
#pragma mark ========== 所有单子的草稿方法 ==========
- (IBAction)saveDraftAction:(id)sender {
    if (ORDER_ISEQUAl(YuDingDan)) {
        [self yudingdanCommonAction:0];
    }else if (ORDER_ISEQUAl(YangPinDan)){
        [self yangPinDanCommonAction:0];
    }else if(ORDER_ISEQUAl(XiaoShouDan)){
        [self XiaoShouDanCommonAction:0];
    }else if (ORDER_ISEQUAl(TuiHuoDan)){
        [self setTuiHuoDanAction:0];
    }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
        [self setCaiGouRuKuDanCommonAction:0];
    }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
        [self setCaiGouTuiHuoDanAction:0];
    }
}
#pragma mark ========== 所有单子的下单方法 ==========
- (IBAction)selectOKAction:(id)sender {
    
    //只有销售单和样品单会跳转到收银台界面    预定单和退货单下单直接就成功
    if (ORDER_ISEQUAl(YuDingDan)) {
        [self yudingdanCommonAction:1];
    }else if (ORDER_ISEQUAl(XiaoShouDan)){
        [self setXiaoShouDanAction];
    }else if (ORDER_ISEQUAl(YangPinDan)){
        [self setXiaoShouDanAction];
    }else if (ORDER_ISEQUAl(TuiHuoDan)){
        [self setTuiHuoDanAction:1];
    }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
        [self setXiaoShouDanAction];
    }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
        [self setCaiGouTuiHuoDanAction:1];
    }
}
#pragma mark ========== 退货单下单保存 ==========
-(void)setTuiHuoDanAction:(NSInteger)autoCheck{
    [self allOrderCommonParamters];
    [AD_MANAGER.caoGaoDic setValue:[self allOrderXiaoShouTuiHuoListCommonParamtersArray] forKey:@"tbnote_xsthcbs"];
    kWeakSelf(self);//autocheck 自动审核 1:是(默认) 0:仅存草稿
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestTuihuoOrderSaveNote:mDic success:^(id object) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        JDSuccessVCViewController * VC = [[JDSuccessVCViewController alloc]init];
        VC.noteno = object[@"data"];
        if (autoCheck == 1) {
            [weakself showToast:object[@"data"]];
            [weakself.navigationController pushViewController:VC animated:YES];
        }else{
            [self showToast:object[@"data"]];
            JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
            VC.selectTag1 = 4;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }];
}
#pragma mark ========== 销售单存下单和草稿不通用方法 ==========
-(void)XiaoShouDanCommonAction:(NSInteger)autoCheck{
    [self allOrderCommonParamters];
    [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.affrimDic[@"dingjinArray"] forKey:@"tbnote_spxscb_sks"];//收款列表
    [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.affrimDic[@"zhekouArray"] forKey:@"tbnote_spxscb_zks"];//折扣列表
    [AD_MANAGER.caoGaoDic setValue:[self allOrderXiaoShouTuiHuoListCommonParamtersArray] forKey:@"tbnote_spxscbs"];//商品列表
    kWeakSelf(self);//autocheck 自动审核 1:是(默认) 0:仅存草稿
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestNoteSpxsSaveNote:mDic success:^(id object) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        [weakself showToast:object[@"data"]];
        JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
        VC.selectTag1 = 2;
        [weakself.navigationController pushViewController:VC animated:YES];
    }];
}
#pragma mark ========== 采购入库单存下单和草稿不通用方法 ==========
-(void)setCaiGouRuKuDanCommonAction:(NSInteger)autoCheck{
    [self allOrderCommonParamters];
    [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.affrimDic[@"dingjinArray"] ? AD_MANAGER.affrimDic[@"dingjinArray"] : @[] forKey:@"tbnote_sprkcb_fks"];//收款列表
    [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.affrimDic[@"zhekouArray"] ? AD_MANAGER.affrimDic[@"zhekouArray"] :@[] forKey:@"tbnote_fkcb_zks"];//折扣列表
    [AD_MANAGER.caoGaoDic setValue:[self allOrderCaiGouRuKuListCommonParamtersArray] forKey:@"tbnote_sprkcbs"];//商品列表
    kWeakSelf(self);//autocheck 自动审核 1:是(默认) 0:仅存草稿
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestCaiGouRuKuSaveAction:mDic success:^(id object) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        [weakself showToast:[@"采购入库单保存成功" append:object[@"data"]]];
        JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
        VC.selectTag1 = 6;
        [weakself.navigationController pushViewController:VC animated:YES];
    }];
}
#pragma mark ========== 采购退货单下单保存 ==========
-(void)setCaiGouTuiHuoDanAction:(NSInteger)autoCheck{
   [self allOrderCommonParamters];
    [AD_MANAGER.caoGaoDic setValue:[self allOrderXiaoShouTuiHuoListCommonParamtersArray] forKey:@"tbnote_rkthcbs"];
    kWeakSelf(self);//autocheck 自动审核 1:是(默认) 0:仅存草稿
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestCaiGouTuiHuoSaveAction:mDic success:^(id object) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
            [weakself showToast:[@"采购退货单存为草稿成功" append:object[@"data"]]];
            JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
            VC.selectTag1 = 7;
            [self.navigationController pushViewController:VC animated:YES];
    }];
}
#pragma mark ========== 销售单下单,跳转下一步收款界面 ==========
-(void)setXiaoShouDanAction{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDCollectMoneyViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDCollectMoneyViewController"];
    VC.allPrice =  self.allPriceLbl.text;
    [self allOrderCommonParamters];
    VC.allOrderXiaoShouTuiHuoListCommonParamtersArray = [NSMutableArray arrayWithArray:[self allOrderXiaoShouTuiHuoListCommonParamtersArray]];
    VC.allOrderYangPinYuDingListCommonParamtersArray = [NSMutableArray arrayWithArray:[self allOrderYangPinYuDingListCommonParamtersArray]];
    VC.allOrderCaiGouRuKuListCommonParamtersArray = [NSMutableArray arrayWithArray:[self allOrderCaiGouRuKuListCommonParamtersArray]];

    
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 预定单的下单和草稿的公用方法 ==========
-(void)yudingdanCommonAction:(NSInteger )autoCheck{
    kWeakSelf(self);
    [self allOrderCommonParamters];
    [AD_MANAGER.caoGaoDic setValue:[self allOrderYangPinYuDingListCommonParamtersArray] forKey:@"tbnote_xsddcbs"];//商品列表
    [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.affrimDic[@"dingjinArray"] forKey:@"tbnote_xsddcb_sks"];//收款列表
    
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    //如果单子已经审核，并且是下单的情况下，需要重新反审单子
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestYuDingOrderOrderSaveNote:mDic success:^(id object) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        if (autoCheck == 1) {
            [self showToast:[@"预定单保存成功" append:object[@"data"]]];
            JDSuccessVCViewController * VC = [[JDSuccessVCViewController alloc]init];
            VC.noteno = object[@"data"];
            [weakself.navigationController pushViewController:VC animated:YES];
        }else{
            [self showToast:[@"存为草稿成功" append:object[@"data"]]];
            JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
            VC.selectTag1 = 0;
            [weakself.navigationController pushViewController:VC animated:YES];
        }
    }];
}
#pragma mark ========== 样品单的下单和草稿公用方法 ==========
-(void)yangPinDanCommonAction:(NSInteger )autoCheck{
    kWeakSelf(self);
    //得到公共的参数
    [self allOrderCommonParamters];
    [AD_MANAGER.caoGaoDic setValue:@[] forKey:@"tbnote_ypxscb_zks"];//折扣列表
    [AD_MANAGER.caoGaoDic setValue:[self allOrderYangPinYuDingListCommonParamtersArray] forKey:@"tbnote_ypxscbs"];//商品列表
    [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.affrimDic[@"dingjinArray"] forKey:@"tbnote_ypxscb_sks"];//收款列表
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestYangPinOrderSaveNote:mDic success:^(id object) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        if (autoCheck == 1) {
        }else{
            [weakself showToast:object[@"data"]];
            JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
            VC.selectTag1 = 3;
            [weakself.navigationController pushViewController:VC animated:YES];
        }
    }];
}
-(NSString *)inKeyOutSpid:(NSInteger)i{
    NSString * spid ;
    for (JDSelectSpModel * spModle in AD_MANAGER.selectSpPageArray) {
        if ([[AD_MANAGER.sectionArray[i] allKeys][0] intValue] == spModle.spid) {
            spid = NSIntegerToNSString(spModle.spid);
        }
    }
    return spid;
}
@end
