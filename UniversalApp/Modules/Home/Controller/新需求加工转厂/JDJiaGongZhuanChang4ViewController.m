//
//  JDJiaGongZhuanChang4ViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDJiaGongZhuanChang4ViewController.h"
#import "JDSalesAffirmTableViewController.h"
#import "JDCollectMoneyViewController.h"
#import "JDSelectSpModel.h"
#import "JDSuccessVCViewController.h"
#import "JDAllOrderViewController.h"
#import "YBPopupMenu.h"
#import "JDAddSpViewController.h"
#import "JDJiaGongZhuanChang4TableViewController.h"
@interface JDJiaGongZhuanChang4ViewController ()<YBPopupMenuDelegate>
@property(nonatomic,strong)JDJiaGongZhuanChang4TableViewController * VC;
@property (nonatomic,strong) NSDictionary * _dic1;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation JDJiaGongZhuanChang4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加工转厂单确认";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self setUIAction];
    [self requestCKShrYgArray];
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
            NSString * key = @"tbnote_jgzccbs";
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
            [spxscbsDic setValue:@([colorModel.savePishu integerValue]) forKey:@"spps"];//匹数
            [spxscbsDic setValue:@([colorModel.saveCount doubleValue]) forKey:@"spsl"];//销售数量
            
            
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
    

    [AD_MANAGER.caoGaoDic setValue:[self.VC.bzTV.text isEqualToString:@"填写你的备注(选填)"] ? @"" :self.VC.bzTV.text  forKey:@"djbz"];//单据备注
    [AD_MANAGER.caoGaoDic setValue:@([AD_MANAGER.affrimDic[@"gysmcInId"] integerValue])  forKey:@"zcjgcid"];//送货人
    [AD_MANAGER.caoGaoDic setValue:@([AD_MANAGER.affrimDic[@"gysmcOutId"] integerValue])  forKey:@"zrjgcid"];//送货人

    [AD_MANAGER.caoGaoDic setValue:@([AD_MANAGER.affrimDic[@"jsrid"] integerValue])  forKey:@"jsrid"];//送货人
    
    
    [AD_MANAGER.caoGaoDic setValue:@"" forKey:@"bjmc"];//标记名称 可空字符串(修改时请保留原值)
    
    NSString * djhm = AD_MANAGER.caoGaoDic[@"djhm"];
    [AD_MANAGER.caoGaoDic setValue:djhm.length == 0 ? @"" : djhm   forKey:@"djhm"];//单据号码 否
    
    NSString * ddhm = AD_MANAGER.affrimDic[@"ddhm"];
    [AD_MANAGER.caoGaoDic setValue:ddhm   forKey:@"ddhm"];//单据号码 否
    
    NSInteger djzt = [AD_MANAGER.caoGaoDic[@"djzt"] integerValue];
    [AD_MANAGER.caoGaoDic setValue:djzt ? @(djzt) : @0 forKey:@"djzt"];//单据状态  djzt=0时，为新增 djzt=1时：为修改
}
-(JDSelectClientModel *)getClientModel{
    return [AD_SHARE_MANAGER inKeHuNameOutKeHuId:self.VC.btn1.titleLabel.text];
}
#pragma mark ========== 初始化的方法 ==========
-(void)setUIAction{
    [self.nextBtn setTitle:@"完成" forState:0];
    self.allPriceLbl.text = AD_MANAGER.affrimDic[@"allPrice"];
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"JDJiaGongZhuanChang4TableViewController"]) {
        JDJiaGongZhuanChang4TableViewController * nav = [segue destinationViewController];
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
#pragma mark ========== 所有单子的下单方法 ==========
- (IBAction)selectOKAction:(id)sender {
    [self yudingdanCommonAction:1];
}
#pragma mark ========== 预定单的下单和草稿的公用方法 ==========
-(void)yudingdanCommonAction:(NSInteger )autoCheck{
    kWeakSelf(self);
    [self allOrderCommonParamters];
    [AD_MANAGER.caoGaoDic setValue:[self allOrderYangPinYuDingListCommonParamtersArray] forKey:@"tbnote_jgzccbs"];//商品列表
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    //如果单子已经审核，并且是下单的情况下，需要重新反审单子
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestJiaGongZhuanChangUp:mDic success:^(id object) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        if (autoCheck == 1) {
            [self showToast:[@"加工转厂单保存成功" append:object[@"data"]]];
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
