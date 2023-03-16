//
//  JDZhiFaDan5ViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/22.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDZhiFaDan5ViewController.h"
#import "JDSalesAffirmTableViewController.h"
#import "JDCollectMoneyViewController.h"
#import "JDSelectSpModel.h"
#import "JDSuccessVCViewController.h"
#import "JDAllOrderViewController.h"
#import "YBPopupMenu.h"
#import "JDAddSpViewController.h"
#import "JDZhiFaDan5TableViewController.h"
#import "JDZhiFaDan6ViewController.h"

@interface JDZhiFaDan5ViewController ()<YBPopupMenuDelegate>
@property(nonatomic,strong)JDSalesAffirmTableViewController * VC;
@property (nonatomic,strong) NSDictionary * _dic1;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation JDZhiFaDan5ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jinjiaLbl.text = _jinjia;
    self.xiaojiaLbl.text = _xiaojia;
    self.totalCountLbl.text = _totalcount;
    NSLog(@"%@,",NEW_AffrimDic_SectionArray);
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
//所有单据的参数，并且传到下个页面的共同参数
-(void)allOrderCommonParamters{
    
    JDParModel * parModel = aa;
    
    aa.zdrq = [NSString currentDateString];
    aa.rzrq = [NSString currentDateStringyyyyMMdd];
    aa.rzsj = [NSString currentDateStringHHmmss];
    
    
    
    LoginModel * model = AD_USERDATAARRAY;
   
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
#define TITLES @[@"草稿",@"提交",@"删单"]
-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:TITLES icons:nil menuWidth:120 delegate:self];
}
#pragma mark - 右上角更多的小弹框
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (index == 0) {//草稿
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
        VC.selectTag1 = 2;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (index == 1){//提交
        [self setXiaoShouDanAction];
    }else{
        kWeakSelf(self);
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":AD_MANAGER.caoGaoDic[@"djhm"]}];
        [AD_MANAGER requestDelXiaoShouDan:mDic success:^(id object) {
                [weakself showToast:@"删除订单成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                });
        }];
    }
}
#pragma mark ========== 初始化的方法 ==========
-(void)setUIAction{
    self.title = @"直发单确认";
    [self.nextBtn setTitle:@"下一步" forState:0];
    self.allPriceLbl.text = @"";
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"JDZhiFaDan5TableViewController"]) {
        JDZhiFaDan5TableViewController * nav = [segue destinationViewController];
        self.VC = nav;
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

#pragma mark ========== 所有单子的下单方法 ==========
- (IBAction)selectOKAction:(id)sender {
    [self setXiaoShouDanAction];
}

#pragma mark ========== 销售单下单,跳转下一步收款界面 ==========
-(void)setXiaoShouDanAction{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"XinXuQiu" bundle:nil];
    JDZhiFaDan6ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDZhiFaDan6ViewController"];
    VC.allPrice =  self.xiaojia;
    [self allOrderCommonParamters];
    VC.allOrderXiaoShouTuiHuoListCommonParamtersArray = @[];
    [self.navigationController pushViewController:VC animated:YES];
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
