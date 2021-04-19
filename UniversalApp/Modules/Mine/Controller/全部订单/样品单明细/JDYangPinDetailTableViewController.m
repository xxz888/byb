//
//  JDYangPinDetailTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/5.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDYangPinDetailTableViewController.h"
#import "JDClientCheckingDetailViewController.h"
#import "JDFooterView.h"
#import "JDYangPinDetailTableViewCell.h"
#import "YBPopupMenu.h"
#import "JDAddColorModel.h"
#import "JDSalesAffirmViewController.h"
#import "JDAllOrderViewController.h"
#import "JDSalesAffirmRunTableViewCell.h"
#import "JDOrder1TableViewController.h"
#import "JDOrder1FaHuoTableViewController.h"
#import "SelectedListView.h"
#import "QiniuLoad.h"
@interface JDYangPinDetailTableViewController ()<YBPopupMenuDelegate>
@property(nonatomic,strong)NSDictionary * resultDic;
@property(nonatomic,strong)JDFooterView * footerView;
@property(nonatomic,strong)JDAllOrderViewController * allOrderVC;
@property (nonatomic,strong)NSMutableArray * resultArray;
@property (nonatomic,strong) NSMutableArray * printWayArray;

@end

@implementation JDYangPinDetailTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
//    if (ORDER_ISEQUAl(ZhiFaDan)) {
//
//    }else{
//        [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@9009]];
//    }
    
    [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@9009]];
    [self requestData];
    [self requestShareDanJuData];
}
#define TITLES1  @[@"回到草稿", @"打印",@"远程打印",@"分享",@"分享码单"]
#define TITLES2  @[@"回到草稿", @"打印",@"远程打印"]

-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:CaiGouBOOL ? TITLES2 : TITLES1 icons:nil menuWidth:120 delegate:self];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    AD_MANAGER.noteno = self.noteno;
    kWeakSelf(self);
    if (index == 1) {
        [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
    }else if (index == 2){
        [AD_SHARE_MANAGER longBlueToothCommonActionNav:self.navigationController];
    }
    else if(index == 0){
        
        
        //回到草稿，需要进行反审
        NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"state":@(1),@"noteno":self.resultDic[@"djhm"]}];
            if (ORDER_ISEQUAl(YangPinDan)) {
                [AD_MANAGER requestYangPinFanShenDan:mDic1 success:^(id object) {
                    [AD_SHARE_MANAGER commonYangPinDanTiaozhuan:weakself.resultDic nav:self.navigationController];
            }];
            }else if (ORDER_ISEQUAl(XiaoShouDan)){
                [AD_MANAGER requestXiaoShouDanFanShen:mDic1 success:^(id object) {
                    [AD_SHARE_MANAGER commonXiaoShouDanTiaozhuan:weakself.resultDic nav:self.navigationController];
                }];
             
            }else if (ORDER_ISEQUAl(TuiHuoDan)){
                [AD_MANAGER requestTuiHuoFanShenDan:mDic1 success:^(id object) {
                    [AD_SHARE_MANAGER commonTuiHuoDanTiaozhuan:weakself.resultDic nav:self.navigationController];
                }];
            }else if (ORDER_ISEQUAl(ChuKuDan)){
                NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"state":@(1),@"noteno":self.noteno}];

                [AD_MANAGER requestChuKuFanShenDan:mDic2 success:^(id object) {
                    kWeakSelf(self);
                    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":self.resultDic[@"tbnote_spckcbs"][0][@"ddhm"]}];
                    [AD_MANAGER requestxsddShowNote:mDic success:^(id object) {
                        NSDictionary * resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
                        
                        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
                        JDOrder1FaHuoTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDOrder1FaHuoTableViewController"];
                        VC.hidesBottomBarWhenPushed = YES;
                        VC.objectDic = [[NSMutableDictionary alloc]initWithDictionary:resultDic];
                        VC.noteno = self.noteno;
                        [weakself.navigationController pushViewController:VC animated:YES];
                    }];
                }];
            }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
                [AD_MANAGER requestCaiGouRuKuDanFanShen:mDic1 success:^(id object) {
                    [AD_SHARE_MANAGER commonCaiGouRuKuDanTiaozhuan:weakself.resultDic nav:self.navigationController];
                }];
            }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
                [AD_MANAGER requestCaiGouTuiHuoDanFanShen:mDic1 success:^(id object) {
                    [AD_SHARE_MANAGER commonCaiGouTuiHuoDanTiaozhuan:weakself.resultDic nav:self.navigationController];
                }];
            }
 
    }else if (index == 3){
        // 分享部分的逻辑 目前来看后端没有直发单的分享逻辑
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":self.noteno}];
        [AD_MANAGER requestShareWeiXin:mDic success:^(id object) {
            [AD_SHARE_MANAGER showShareView:object[@"data"]];
        } notetype:ORDER_ISEQUAl(YangPinDan) ? @"ypxs" :
         ORDER_ISEQUAl(XiaoShouDan) ? @"spxs" :
         ORDER_ISEQUAl(TuiHuoDan) ? @"xsth" :
         ORDER_ISEQUAl(ChuKuDan) ? @"spck" :
         ORDER_ISEQUAl(ZhiFaDan) ? @"spzf" : @""
         ];
    }else if (index == 4){
//        [AD_SHARE_MANAGER showShareView:object[@"data"]];
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i <  _printWayArray.count; i++) {
            NSInteger cloud = [_printWayArray[i][@"cloud"] integerValue];
            if (cloud == 0) {
                NSString * string = [@"[定制]" append:_printWayArray[i][@"name"]];
                [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:string]];
            }
   
        }
        if (mArray.count == 0) {
            [self showToast:@"当前无打印模块"];
            return;
        }
        view.array = [NSArray arrayWithArray:mArray];
        kWeakSelf(self);
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                NSInteger cloud = [model.title containsString:@"[定制]"] ? 0 : 1;
               //保存打印参数
                NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
//                @{@"wayname":model.title,@"cloud":@(cloud)}
                [dic setValue:model.title forKey:@"wayname"];
                [dic setValue:@(cloud) forKey:@"cloud"];

                [weakself pushPrintYuLan:dic];
            }];
        };
        
        [LEEAlert alert].config
        .LeeTitle(@"")
        .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        .LeeCustomView(view)
        .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        .LeeClickBackgroundClose(YES)
        .LeeShow();
    }
}
-(void)pushShareView:(id)object{
    [[ShareManager sharedShareManager] showShareView:@{@"img":object[@"img"],@"order":self.noteno}];
}
-(void)xinfenxiang{
    
}
-(void)pushPrintYuLan:(NSMutableDictionary *)parDic{
    kWeakSelf(self);
    if (ORDER_ISEQUAl(XiaoShouDan)) {
        [AD_MANAGER printXiaoShouPreviewPageCountAction:[weakself sameParamters:parDic] success:^(id object) {
            NSInteger count = [object[@"data"] integerValue];
            if (count == 1) {[AD_MANAGER printXiaoShouPreviewAction:[weakself sameParamters:parDic] success:^(id object) {[weakself pushShareView:object];}];}else{
                dispatch_group_t group = dispatch_group_create();
                NSMutableArray * allArray = [[NSMutableArray alloc]init];
                for (NSInteger i = 0; i < count; i++) {
                      dispatch_group_enter(group);
                      [parDic setValue:@(i+1) forKey:@"curpage"];
                      [AD_MANAGER printXiaoShouPreviewAction:[weakself sameParamters:parDic] success:^(id object) {
                            [allArray addObject:object[@"img"]];
                            dispatch_group_leave(group);
                      }];}
                dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //主线程执行
                        NSArray *items = [NSArray arrayWithArray:allArray];
                            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
                            [weakself presentViewController:activityVC animated:TRUE completion:nil];
                });
                
                });
           }}];
    }else if (ORDER_ISEQUAl(YuDingDan)){
        [AD_MANAGER printYuDingDanPreviewAction:[weakself sameParamters:parDic]  success:^(id object) {
            [weakself pushShareView:object];
        }];
    }else if (ORDER_ISEQUAl(TuiHuoDan)){
        [AD_MANAGER printTuiHuoDanPreviewAction:[weakself sameParamters:parDic]  success:^(id object) {
            [weakself pushShareView:object];
        }];
    }else if (ORDER_ISEQUAl(YangPinDan)){
        [AD_MANAGER printYangPinDanPreviewAction:[weakself sameParamters:parDic]  success:^(id object) {
            [weakself pushShareView:object];
        }];
    }else if (ORDER_ISEQUAl(ChuKuDan)){
        [AD_MANAGER printChuKuDanPreviewAction:[weakself sameParamters:parDic]  success:^(id object) {
            [weakself pushShareView:object];
        }];
    }else if (ORDER_ISEQUAl(ShouKuanDan)){
        [AD_MANAGER printShouKuanDanPreviewAction:[weakself sameParamters:parDic]  success:^(id object) {
            [weakself pushShareView:object];
        }];
    }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
        [AD_MANAGER printCaiGouRuKuDanPreviewAction:[weakself sameParamters:parDic]  success:^(id object) {
            [weakself pushShareView:object];
        }];
    }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
        [AD_MANAGER printCaiGouTuiHuoDanPreviewAction:[weakself sameParamters:parDic]  success:^(id object) {
            [weakself pushShareView:object];
        }];
    }else if (ORDER_ISEQUAl(FuKuanDan)){
        [AD_MANAGER printFuKuanDanPreviewAction:[weakself sameParamters:parDic]  success:^(id object) {
            [weakself pushShareView:object];
        }];
    }else if (ORDER_ISEQUAl(ZhiFaDan)){
        [AD_MANAGER printZhiFaDanPreviewAction:[weakself sameParamters:parDic]  success:^(id object) {
            [weakself pushShareView:object];
        }];
    }
}
-(NSMutableDictionary *)sameParamters:(NSMutableDictionary *)dic{
    NSString * wayname = [dic[@"wayname"] replaceAll:@"[定制]" target:@""];
    NSInteger cloud = [dic[@"cloud"] integerValue];
    if (wayname) {
        if (dic[@"curpage"]) {
            NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"DpiX":@180,
                                                                                      @"cloud":@(cloud),
                                                                                      @"wayname":wayname,
                                                                                      @"DpiY":@180,
                                                                                      @"noteno":AD_MANAGER.noteno,
                                                                                      @"curpage":dic[@"curpage"]
                                                                                      }];
            return mDic1;
        }else{
            NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"DpiX":@180,
                                                                                                @"cloud":@(cloud),
                                                                                                @"wayname":wayname,
                                                                                                @"DpiY":@180,
                                                                                                @"noteno":AD_MANAGER.noteno,
                                                                                                }];
                      return mDic1;
        }
        
    }else{
        return [NSMutableDictionary new];
    }
}









//单子的请求方法
-(void)requestShareDanJuData{
    kWeakSelf(self);
    [_printWayArray removeAllObjects];
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"sjhzfs":@0,@"mhdyps":@0}];
    if (ORDER_ISEQUAl(XiaoShouDan)) {
        [AD_MANAGER requestXiaoShouBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
        }];
    }else  if (ORDER_ISEQUAl(YuDingDan)) {
        [AD_MANAGER requestYuDingDanBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
        }];
    }else  if (ORDER_ISEQUAl(YangPinDan)) {
        [AD_MANAGER requestYangPinBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
        }];
    }else  if (ORDER_ISEQUAl(TuiHuoDan)) {
        [AD_MANAGER requestTuiHuoDanBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
        }];
    }else  if (ORDER_ISEQUAl(ShouKuanDan)) {
        [AD_MANAGER requestShouKuanDanBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
        }];
    }else  if (ORDER_ISEQUAl(ChuKuDan)) {
        [AD_MANAGER requestChuKuBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
        }];
    }else if ([AD_MANAGER.orderType isEqualToString:SPDA]){
        [AD_MANAGER requestSPDAPrintInfoAction:mDic1 success:^(id object) {
            [weakself getWayArray:object];
        }];
    }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
        [AD_MANAGER requestCaiGouRuKuBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
            
        }];
    }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
        [AD_MANAGER requestCaiGouTuiHuoBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
            
        }];
    }else if (ORDER_ISEQUAl(FuKuanDan)){
        [AD_MANAGER requestFuKuanDanBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
            
        }];
    }else if (ORDER_ISEQUAl(ZhiFaDan)) {
        [AD_MANAGER requestShangPingZhiFaDanBluePrintWay:mDic1 success:^(id object) {
            [weakself getWayArray:object];
        }];
    }
}
-(void)getWayArray:(id)object{
    [_printWayArray removeAllObjects];
    [_printWayArray addObjectsFromArray:object[@"data"]];
}
-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":self.noteno}];
    if (ORDER_ISEQUAl(YangPinDan)){
        [AD_MANAGER requestYangPinDanDetail:mDic success:^(id object) {
            [weakself yangPinAction:object];
        }];
    }else if (ORDER_ISEQUAl(XiaoShouDan)){
        [AD_MANAGER requestXiaoShouSHowNote:mDic success:^(id object) {
            [weakself xianChengAction:object];
        }];
    }else if (ORDER_ISEQUAl(TuiHuoDan)){
        [AD_MANAGER requestTuiHuoCaoGaoDetail:mDic success:^(id object) {
           [weakself tuiHuoDanAction:object];
        }];
    }else if (ORDER_ISEQUAl(ChuKuDan)){
        [AD_MANAGER requestChuKuDanDetail:mDic  success:^(id object) {
            [weakself ChuKuDanAction:object];
        }];
    }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
         NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
        [AD_MANAGER requestGongYingShangListAction:mDic1 success:^(id object) {
            [AD_MANAGER requestCaiGouRuKuShowAction:mDic success:^(id object) {
                [weakself CaiGouRuKuAction:object];
            }];
        }];
      
    }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
        [AD_MANAGER requestCaiGouTuiHuoShowAction:mDic success:^(id object) {
            [weakself CaiGouRuKuAction:object];
        }];
    }else if (ORDER_ISEQUAl(ZhiFaDan)){
        [AD_MANAGER requestZhiFaShowAction:mDic success:^(id object) {
            [weakself zhiFaAction:object];
        }];
    }
}
#pragma mark ========== 采购入库单 ==========
-(void)CaiGouRuKuAction:(NSDictionary *)object{
    
    self.resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
    self.lbl1Tag.text = @"供应商";
    self.lbl4Tag.text = @"经手人";
    [self.btn8 setTitle:@"供应商对账" forState:0];
    self.btn8.hidden = YES;
    self.lbl1.text = self.resultDic[@"gysmc"];
    self.lbl3.text = self.resultDic[@"ckmc"];
    self.lbl4.text = self.resultDic[@"jsrmc"];
    
    //商品总计
    double sumXsje = 0;
    for (NSDictionary * dic1 in ORDER_ISEQUAl(CaiGouTuiHuoDan) ? self.resultDic[@"tbnote_rkthcbs"] : self.resultDic[@"tbnote_sprkcbs"]) {
        sumXsje = [dic1[@"spje"] doubleValue] + sumXsje;
    }
    
    double je = 0;
    //全部金额 显示折扣
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
    for (NSDictionary * dic2 in self.resultDic[@"tbnote_sprkcb_zks"]) {
        [array2 addObject:[NSString stringWithFormat:@"(%@)",[dic2[@"zklxmc"] append:CCHANGE(dic2[@"je"])]]];
        je += [dic2[@"je"] doubleValue];
    }
    NSString * ksjeStr = [array2 componentsJoinedByString:@","];
    self.lbl5.text = [NSString stringWithFormat:@"%@\n%@",CCHANGE_DOUBLE(sumXsje - je),ksjeStr];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:self.lbl5.text];
    NSRange range2 = [[str1 string] rangeOfString:ksjeStr];
    [str1 addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range2];
    self.lbl5.attributedText = str1;
    
    
    
    
    
    self.lbl6.text = CCHANGE_DOUBLE(sumXsje);
    //已支付
    NSMutableArray * tbnote_skcb_zk = [[NSMutableArray alloc]init];;
    double sumSksje = 0;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_sprkcb_fks"]) {
        sumSksje = [dic1[@"fkje"] doubleValue] + sumSksje;
        if ([dic1[@"fkje"] doubleValue] != 0) {
            [tbnote_skcb_zk addObject:[NSString stringWithFormat:@"(%@)",[dic1[@"zhmc"] append:CCHANGE(dic1[@"fkje"])]]];
        }
    }
    NSString * ksjeStr1 = [tbnote_skcb_zk componentsJoinedByString:@","];
    self.lbl7.text = [NSString stringWithFormat:@"%@\n%@",CCHANGE_DOUBLE(sumSksje),ksjeStr1];;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.lbl7.text];
    NSRange range1 = [[str string] rangeOfString:ksjeStr1];
    [str addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range1];
    self.lbl7.attributedText = str;
    
    
    self.allQianKuanLbl.hidden = self.allQainKuanLblTag.hidden = NO;
    JDSelectClientModel * clientModel = [AD_SHARE_MANAGER inKeHuNameOutKeHuId:self.resultDic[@"gysmc"]];
    self.allQianKuanLbl.text =  CCHANGE_DOUBLE(clientModel.yfzk);
    
    //本单欠款
    self.lbl8.text = CCHANGE_DOUBLE(sumXsje - je - sumSksje);
    self.lbl9.text = self.resultDic[@"djhm"];
    self.lbl10.text = self.resultDic[@"zdrq"];
    self.lbl12.text = self.resultDic[@"mdmc"];
    self.bzTV.text = self.resultDic[@"djbz"];
    self.bzTV.userInteractionEnabled = NO;
    [self footerValue];

    REMOVE_ALL_CACHE;
    if (ORDER_ISEQUAl(CaiGouTuiHuoDan)) {
        self.timeLbl.text = @"退货时间";
        [AD_SHARE_MANAGER getCaiGouTuiHuoDan:self.resultDic];
    }else{
        [AD_SHARE_MANAGER getCaiGouRuKuList:self.resultDic];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark ========== 出库单  ==========
 -(void)ChuKuDanAction:(NSDictionary *)object{
     self.resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
     
     self.lbl1.text = self.resultDic[@"khmc"];//客户
     self.lbl3.text = self.resultDic[@"ckmc"];
     self.lbl4.text = self.resultDic[@"shrmc"];
     
     self.yifajineLbl.text = @"已发金额(应收)";
     self.lbl5.textColor = KRedColor;
     double yifajine = 0;
     NSString * ddhm = @"";
     for (NSDictionary * dic in self.resultDic[@"tbnote_spckcbs"]) {
         yifajine += [dic[@"xsje"] doubleValue];
         ddhm = dic[@"ddhm"];
     }
     self.lbl5.text = CCHANGE_DOUBLE(yifajine);
     
     self.lbl9.text =  self.resultDic[@"djhm"];
     self.lbl10.text = self.resultDic[@"rzrq"];
     self.lbl11.text = self.resultDic[@"ywymc"];
     self.lbl12.text = self.resultDic[@"mdmc"];
     
     self.connectLbl.text = ddhm;
     self.timeLbl.text = @"出库时间";
     REMOVE_ALL_CACHE;
     [self getFullData];
     [self.tableView reloadData];
     
 }
#pragma mark ========== 退货单 ==========
-(void)tuiHuoDanAction:(NSDictionary *)object{
    self.resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
    self.lbl1.text = self.resultDic[@"khmc"];
    self.lbl2.text = self.resultDic[@"shdz"];
    self.lbl3.text = self.resultDic[@"ckmc"];
    self.lbl4.text = self.resultDic[@"shrmc"];
    
    //订单金额
    double sumXsje = 0;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_xsthcbs"]) {
        sumXsje = [dic1[@"xsje"] doubleValue] + sumXsje;
    }
    self.lbl6.text = CCHANGE_DOUBLE(sumXsje);
    self.lbl8.text = @"";
    self.lbl8Tag.text = @"";
    self.lbl9.text = self.resultDic[@"djhm"];
    self.lbl10.text = self.resultDic[@"zdrq"];
    self.lbl11.text = self.resultDic[@"ywymc"];
    self.lbl12.text = self.resultDic[@"mdmc"];
    self.bzTV.text = self.resultDic[@"djbz"];
    self.bzTV.userInteractionEnabled = NO;
    REMOVE_ALL_CACHE;
    [self getFullData];
    [self.tableView reloadData];
}
#pragma mark ========== 直发单 ==========
-(void)zhiFaAction:(NSDictionary *)object{
    
    self.resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
    //供应商名称
    self.gysLbl.text = self.resultDic[@"gysmc"];
    //客户名称
    self.lbl1.text = self.resultDic[@"khmc"];
    //描述
    self.lbl2.text = self.resultDic[@"shdz"];
    //仓库名称
    self.lbl3.text = self.resultDic[@"ckmc"];
    //送货人名称
    self.lbl4.text = self.resultDic[@"shrmc"];

    //商品总计
    double sumXsje = 0;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_spzfcbs"]) {
        sumXsje = [dic1[@"xsje"] doubleValue] + sumXsje;
    }
    double je = 0;
    //全部金额 显示折扣
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
    for (NSDictionary * dic2 in self.resultDic[@"tbnote_spzfcb_khzks"]) {
        [array2 addObject:[NSString stringWithFormat:@"(%@)",[dic2[@"zklxmc"] append:CCHANGE(dic2[@"je"])]]];
        je += [dic2[@"je"] doubleValue];
    }
    NSString * ksjeStr = [array2 componentsJoinedByString:@","];
    self.lbl5.text = [NSString stringWithFormat:@"%@\n%@",CCHANGE_DOUBLE(sumXsje - je),ksjeStr];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:self.lbl5.text];
    NSRange range2 = [[str1 string] rangeOfString:ksjeStr];
    [str1 addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range2];
    self.lbl5.attributedText = str1;
    
    
    
    
    
    self.lbl6.text = CCHANGE_DOUBLE(sumXsje);
    //已支付
    NSMutableArray * tbnote_skcb_zk = [[NSMutableArray alloc]init];;
    double sumSksje = 0;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_spzfcb_sks"]) {
        sumSksje = [dic1[@"skje"] doubleValue] + sumSksje;
        if ([dic1[@"skje"] doubleValue] != 0) {
            [tbnote_skcb_zk addObject:[NSString stringWithFormat:@"(%@)",[dic1[@"zhmc"] append:CCHANGE(dic1[@"skje"])]]];
        }
    }
    NSString * ksjeStr1 = [tbnote_skcb_zk componentsJoinedByString:@","];
    self.lbl7.text = [NSString stringWithFormat:@"%@\n%@",CCHANGE_DOUBLE(sumSksje),ksjeStr1];;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.lbl7.text];
    NSRange range1 = [[str string] rangeOfString:ksjeStr1];
    [str addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range1];
    self.lbl7.attributedText = str;
    
    
    
    
    //本单欠款
    self.lbl8.text = CCHANGE_DOUBLE(sumXsje - je - sumSksje);
    self.lbl9.text = self.resultDic[@"djhm"];
    self.lbl10.text = self.resultDic[@"zdrq"];
    self.lbl11.text = self.resultDic[@"ywymc"];
    self.lbl12.text = self.resultDic[@"mdmc"];
    self.bzTV.text = self.resultDic[@"djbz"];
    self.bzTV.userInteractionEnabled = NO;
    REMOVE_ALL_CACHE;
    [self getZhiFaDanFullData];
    //    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark ========== 销售单 ==========
-(void)xianChengAction:(NSDictionary *)object{

    self.resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
    self.lbl1.text = self.resultDic[@"khmc"];
    self.lbl2.text = self.resultDic[@"shdz"];
    self.lbl3.text = self.resultDic[@"ckmc"];
    self.lbl4.text = self.resultDic[@"shrmc"];
    
    //商品总计
    double sumXsje = 0;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_spxscbs"]) {
        sumXsje = [dic1[@"xsje"] doubleValue] + sumXsje;
    }
    
    double je = 0;
    //全部金额 显示折扣
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
    for (NSDictionary * dic2 in self.resultDic[@"tbnote_spxscb_zks"]) {
        [array2 addObject:[NSString stringWithFormat:@"(%@)",[dic2[@"zklxmc"] append:CCHANGE(dic2[@"je"])]]];
        je += [dic2[@"je"] doubleValue];
    }
    NSString * ksjeStr = [array2 componentsJoinedByString:@","];
    self.lbl5.text = [NSString stringWithFormat:@"%@\n%@",CCHANGE_DOUBLE(sumXsje - je),ksjeStr];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:self.lbl5.text];
    NSRange range2 = [[str1 string] rangeOfString:ksjeStr];
    [str1 addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range2];
    self.lbl5.attributedText = str1;
    
    
    
    
    
    self.lbl6.text = CCHANGE_DOUBLE(sumXsje);
    //已支付
    NSMutableArray * tbnote_skcb_zk = [[NSMutableArray alloc]init];;
    double sumSksje = 0;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_spxscb_sks"]) {
        sumSksje = [dic1[@"skje"] doubleValue] + sumSksje;
        if ([dic1[@"skje"] doubleValue] != 0) {
            [tbnote_skcb_zk addObject:[NSString stringWithFormat:@"(%@)",[dic1[@"zhmc"] append:CCHANGE(dic1[@"skje"])]]];
        }
    }
    NSString * ksjeStr1 = [tbnote_skcb_zk componentsJoinedByString:@","];
    self.lbl7.text = [NSString stringWithFormat:@"%@\n%@",CCHANGE_DOUBLE(sumSksje),ksjeStr1];;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.lbl7.text];
    NSRange range1 = [[str string] rangeOfString:ksjeStr1];
    [str addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range1];
    self.lbl7.attributedText = str;
    
    
    
    
    //本单欠款
    self.lbl8.text = CCHANGE_DOUBLE(sumXsje - je - sumSksje);
    self.lbl9.text = self.resultDic[@"djhm"];
    self.lbl10.text = self.resultDic[@"zdrq"];
    self.lbl11.text = self.resultDic[@"ywymc"];
    self.lbl12.text = self.resultDic[@"mdmc"];
    self.bzTV.text = self.resultDic[@"djbz"];
    self.bzTV.userInteractionEnabled = NO;
    REMOVE_ALL_CACHE;
    [self getFullData];
//    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark ========== 样品单 ==========
-(void)yangPinAction:(NSDictionary *)object{
    self.resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
    self.lbl1.text = self.resultDic[@"khmc"];
    self.lbl2.text = self.resultDic[@"shdz"];
    self.lbl3.text = self.resultDic[@"ckmc"];
    self.lbl4.text = self.resultDic[@"shrmc"];
    
    
    //订单金额
    double sumXsje = 0;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_ypxscbs"]) {
        sumXsje = [dic1[@"xsje"] doubleValue] + sumXsje;
    }
    //减免金额
    double sumZksje = 0;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_ypxscb_zks"]) {
        sumZksje = [dic1[@"je"] doubleValue] + sumZksje;
    }
    //已支付
    double sumSksje = 0;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_ypxscb_sks"]) {
        sumSksje = [dic1[@"skje"] doubleValue] + sumSksje;
    }
    
    
    self.lbl5.text = [NSString stringWithFormat:@"%@\n(减免%@)",CCHANGE_DOUBLE(sumXsje - sumZksje),CCHANGE_DOUBLE(sumZksje)];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:self.lbl5.text];
    NSRange range2 = [[str1 string] rangeOfString:[NSString stringWithFormat:@"(减免%@)",CCHANGE_DOUBLE(sumZksje)]];
    [str1 addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range2];
    self.lbl5.attributedText = str1;
    

    self.lbl6.text = CCHANGE_DOUBLE(sumXsje);
    NSMutableArray * sksjeArray = [[NSMutableArray alloc]init];;
    for (NSDictionary * dic1 in self.resultDic[@"tbnote_ypxscb_sks"]) {
        if ([dic1[@"skje"] doubleValue] != 0) {
            [sksjeArray addObject:[NSString stringWithFormat:@"(%@)",[dic1[@"zhmc"] append:CCHANGE(dic1[@"skje"])]]];
        }
    }
    
    
    
    NSString * ksjeStr = [sksjeArray componentsJoinedByString:@","];
    self.lbl7.text = [NSString stringWithFormat:@"%@\n%@",CCHANGE_DOUBLE(sumSksje),ksjeStr] ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.lbl7.text];
    NSRange range1 = [[str string] rangeOfString:ksjeStr];
    [str addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range1];
    self.lbl7.attributedText = str;
    
    
    
    
    self.lbl8.text = CCHANGE_DOUBLE(sumXsje - sumZksje - sumSksje);
    
    self.lbl9.text = self.resultDic[@"djhm"];
    self.lbl10.text = self.resultDic[@"zdrq"];
    self.lbl11.text = self.resultDic[@"ywymc"];
    self.lbl12.text = self.resultDic[@"mdmc"];
    self.bzTV.text = self.resultDic[@"djbz"];
    self.bzTV.userInteractionEnabled = NO;
    

    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title =
    ORDER_ISEQUAl(YangPinDan) ? @"样品单详情" :
    ORDER_ISEQUAl(XiaoShouDan) ? @"销售单详情" :
    ORDER_ISEQUAl(TuiHuoDan) ? @"退货单详情" :
    ORDER_ISEQUAl(CaiGouRuKuDan) ? @"采购入库单详情" :
    ORDER_ISEQUAl(CaiGouTuiHuoDan) ? @"采购退货单详情" :
    ORDER_ISEQUAl(ZhiFaDan) ? @"直发单详情" :

    @"出库单详情";
    self.navigationController.navigationBar.hidden = NO;
}
-(void)setUI{
    [self setIsShowLiftBack:YES];
   ViewBorderRadius(self.btn8, 5, 0.5, JDRGBAColor(0, 163, 255));
    [self.tableView registerNib:[UINib nibWithNibName:@"JDYangPinDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDYangPinDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JDSalesAffirmRunTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSalesAffirmRunTableViewCell"];
    _resultArray = [[NSMutableArray alloc]init];
    _printWayArray = [[NSMutableArray alloc]init];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}



- (IBAction)btn8Action:(id)sender {
    if (!Quan_Xian(@"查看销售额权限")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"查看销售额权限",@"0")];
        return;
    }
    JDClientCheckingDetailViewController * VC = [[JDClientCheckingDetailViewController alloc]init];
    VC.paramtersDic = [NSMutableDictionary dictionaryWithDictionary:@{@"begindate":[NSString getThisWeekFirstDay],@"enddate":self.resultDic[@"rzrq"]}];
    [VC.paramtersDic setValue:self.resultDic[@"khid"] forKey:@"khid"];
    VC.clientLbl = self.resultDic[@"khmc"];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)getFullData{
    NSMutableArray * colorArray = [[NSMutableArray alloc]init];
    //最后一步开始造最难的colorModel
    //第一步先拿到颜色model的数组 tbnote_spckcbs
    NSMutableArray * spidArray = [[NSMutableArray alloc]init];
    NSString * typeString = ORDER_ISEQUAl(XiaoShouDan) ? @"tbnote_spxscbs" : ORDER_ISEQUAl(TuiHuoDan) ? @"tbnote_xsthcbs" : ORDER_ISEQUAl(ZhiFaDan) ? @"tbnote_spzfcbs" :@"tbnote_spckcbs";
    for (NSDictionary * dic in self.resultDic[typeString]) {
        JDAddColorModel * colorModel = [[JDAddColorModel alloc]init];
        [colorModel setValuesForKeysWithDictionary:dic];
        [colorModel setValue:doubleToNSString([dic[@"xsdj"] doubleValue]) forKey:@"savePrice"];
        [colorModel setValue:NSIntegerToNSString([dic[@"xsps"] integerValue]) forKey:@"savePishu"];
        [colorModel setValue:dic[@"khkh"] forKey:@"saveKhkh"];
        [colorModel setValue:dic[@"bz"] forKey:@"saveBz"];
        if (ORDER_ISEQUAl(ChuKuDan)) {
            [colorModel setValue:doubleToNSString([dic[@"spkc"] doubleValue]) forKey:@"savekongcha"];

        }else{
            [colorModel setValue:doubleToNSString([dic[@"mpkc"] doubleValue])  forKey:@"savekongcha"];

        }
        
        [colorModel setValue:dic[@"jldw"] forKey:@"saveDanWei"];
        [colorModel setValue:doubleToNSString([dic[@"xssl"] doubleValue]) forKey:@"saveCount"];
        
        [colorModel setValue:dic[@"fjldw"] forKey:@"saveFuDanWei"];
        [colorModel setValue:doubleToNSString([dic[@"xsfsl"] doubleValue]) forKey:@"saveFuCount"];
        
        [colorArray addObject:colorModel];
        [spidArray addObject:NSIntegerToNSString([dic[@"spid"] integerValue])];
    }
    NSSet *set = [NSSet setWithArray:spidArray];
    [spidArray removeAllObjects];
    //得到去除重复颜色的数组
    spidArray = [NSMutableArray arrayWithArray:[set allObjects]];
    //拼接出来以spid为key的数组
    for (NSString * spidStr in spidArray) {
        [AD_MANAGER.sectionArray addObject:@{spidStr:[[NSMutableArray alloc]init]}];
    }
    for (JDAddColorModel * colorModel in colorArray) {
        for (NSInteger i = 0; i < spidArray.count; i++) {
            if (colorModel.spid == [spidArray[i] integerValue]) {
                [AD_MANAGER.sectionArray[i][spidArray[i]] addObject:colorModel];
            }
        }
    }
    //销售单需要另外加一步，合并相同颜色的米数
    //算出相同颜色共有多少匹 多少米 然后再遍历数组，
    NSMutableArray * secCopyArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.sectionArray];
    for (NSInteger i = 0; i<secCopyArray.count; i++) {
        NSDictionary * dic2 = secCopyArray[i];
        //得到key后所有value
        NSArray * arr2 = dic2[[dic2 allKeys][0]];
        //先得到相同颜色的key
        NSMutableArray * ysArray = [[NSMutableArray alloc]init];
        for (JDAddColorModel * colorModel in arr2) {
            [ysArray addObject:colorModel.ys];
        }
        NSSet *set = [NSSet setWithArray:ysArray];
        [ysArray removeAllObjects];
        //得到去除重复颜色的数组
        ysArray = [NSMutableArray arrayWithArray:[set allObjects]];
        NSMutableDictionary * dic3 = [[NSMutableDictionary alloc]init];
        for (NSString * ysStr in ysArray) {
            NSMutableArray * psArray = [[NSMutableArray alloc]init];
            for (JDAddColorModel * colorModel in arr2) {
                if ([colorModel.ys isEqualToString:ysStr]) {
                    [psArray addObject:@{@"xssl":colorModel.saveCount,@"xsfsl":colorModel.saveFuCount}];
                }
            }
            [dic3 setValue:psArray forKey:ysStr];
        }
        // 去除数组中model重复
        //保留第一个元素，增加psarray
        NSMutableArray * arr4 = [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] copy];
        for (NSInteger k = 0; k < arr4.count; k++) {
            for (NSInteger j = k+1;j < arr4.count; j++) {
                JDAddColorModel  *tempModel = arr4[k];
                JDAddColorModel  *model = arr4[j];
                if ([tempModel.ys isEqualToString:model.ys]) {
                    [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] removeObject:model];
                }
            }
        }
        NSMutableArray * arr3 = AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]];
        for ( JDAddColorModel * colorModel3 in arr3) {
            colorModel3.psArray = dic3[colorModel3.ys];
            NSMutableArray * newArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in colorModel3.psArray) {
                [newArray addObject:dic[@"xssl"]];
            }
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
    
        
        if (ORDER_ISEQUAl(XiaoShouDan) ||
            ORDER_ISEQUAl(TuiHuoDan)||
            ORDER_ISEQUAl(ChuKuDan) ||
            ORDER_ISEQUAl(CaiGouRuKuDan) ||
            ORDER_ISEQUAl(CaiGouTuiHuoDan) ||
            ORDER_ISEQUAl(ZhiFaDan)

            ) {
            
            
            JDSalesAffirmRunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDSalesAffirmRunTableViewCell"];
            if(!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"JDSalesAffirmRunTableViewCell" owner:nil options:nil].lastObject;
            }
            //动态cell的方法
            [cell setRunColorValue:nil colorModel:[AD_SHARE_MANAGER getSectionAndRowCount][indexPath.row]];
            
            cell.titleLbl.hidden =  cell.editBtn.hidden =
            ![[AD_SHARE_MANAGER getSectionTitleArray] containsObject:@(indexPath.row)];
            
            if ([AD_SHARE_MANAGER getSectionTitleArray].count == 1) {
                cell.titleLbl.hidden = NO;
            }
            if (ORDER_ISEQUAl(ZhiFaDan)) {
                cell.upDownBtn.hidden = YES;
            }else{
                cell.upDownBtn.hidden = NO;
            }
            
            
            cell.editBtn.hidden = YES;
            kWeakSelf(self);
            cell.upDownBlock = ^(JDSalesAffirmRunTableViewCell *currentCell) {
                NSIndexPath *reloadIndexPath = [weakself.tableView indexPathForCell:currentCell];
                if (reloadIndexPath) {
                    [weakself.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            
            return cell;
        }else{
            JDYangPinDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDYangPinDetailTableViewCell" forIndexPath:indexPath];
            NSDictionary * cellDic;
              if (ORDER_ISEQUAl(YangPinDan)) {
                cellDic = self.resultDic[@"tbnote_ypxscbs"][indexPath.row];
            }
            cell.titleLbl.text = cellDic[@"sphh"];
            cell.lbl1.text =  cellDic[@"ys"];
            cell.lbl2.text = [doubleToNSString([cellDic[@"xsdj"] doubleValue]) append:@"元"];
            cell.lbl3.text = [doubleToNSString([cellDic[@"xssl"] doubleValue]) append:cellDic[@"jldw"]];
            return cell;
        }
     
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (ORDER_ISEQUAl(ChuKuDan)){
            if (indexPath.row == 2) {
                return 0;
            }else if (indexPath.row == 4){
                return 50;
            }
        }else if (ORDER_ISEQUAl(XiaoShouDan) ||
                   ORDER_ISEQUAl(TuiHuoDan) ||
                   ORDER_ISEQUAl(ChuKuDan) ||
                   ORDER_ISEQUAl(YangPinDan) ||
                   ORDER_ISEQUAl(ZhiFaDan)){
            if (indexPath.row == 5) {
                return 0;
            }else if (ORDER_ISEQUAl(ZhiFaDan) && indexPath.row == 1){
                return 50;
            }
        }else if (ORDER_ISEQUAl(CaiGouRuKuDan) ||  ORDER_ISEQUAl(CaiGouTuiHuoDan)){
            if (indexPath.row == 2 || indexPath.row == 5) {
                return 0;
            }
        }
    }else if (indexPath.section == 1) {
        if (ORDER_ISEQUAl(XiaoShouDan) ||
            ORDER_ISEQUAl(TuiHuoDan) ||
            ORDER_ISEQUAl(ChuKuDan) ||
            ORDER_ISEQUAl(CaiGouRuKuDan) ||
            ORDER_ISEQUAl(CaiGouTuiHuoDan)||
            ORDER_ISEQUAl(ZhiFaDan)
            ) {
            JDAddColorModel * model = [AD_SHARE_MANAGER getSectionAndRowCount][indexPath.row];
            if (model.isShowMore){
                NSInteger i = ([model.psArray count] + 3 - 1) / 3 ;
                return 40 * (i == 0 ? 1 : i) + 100;
            } else{
                return 100;
            }
        }else{
            return 100;
        }
    }else if (indexPath.section == 2){
        if (ORDER_ISEQUAl(TuiHuoDan)) {
            if ((indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 )) {
                     return 0;
            }
        }else if (ORDER_ISEQUAl(ChuKuDan)){
            if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5){
                return 0;
            }
        }else if (ORDER_ISEQUAl(XiaoShouDan) ||
                    ORDER_ISEQUAl(YangPinDan) ||
                  ORDER_ISEQUAl(CaiGouRuKuDan) ||
                  ORDER_ISEQUAl(ZhiFaDan)){
            if (indexPath.row == 2 || indexPath.row == 9) {
                return 0;
            }
        }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
            if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 9) {
                return 0;
            }
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (ORDER_ISEQUAl(YangPinDan)) {
            return  [self.resultDic[@"tbnote_ypxscbs"] count];
        }else if (ORDER_ISEQUAl(XiaoShouDan) ||
                  ORDER_ISEQUAl(TuiHuoDan) ||
                  ORDER_ISEQUAl(ChuKuDan) ||
                  ORDER_ISEQUAl(CaiGouRuKuDan)||
                  ORDER_ISEQUAl(CaiGouTuiHuoDan) ||
                  ORDER_ISEQUAl(ZhiFaDan)
                  ){
            if (AD_MANAGER.sectionArray.count == 0) {
                return 0;
            }else{
                NSInteger sumNum = [[AD_SHARE_MANAGER getSectionAndRowCount] count];
                return  sumNum;
                
            }
        }
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];

        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_dizhi"]];
        imageView.frame = CGRectMake(0, 0, kScreenWidth, 3);
        [view addSubview:imageView];
   
            UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 40)];
            HeaderLabel.backgroundColor = JDRGBAColor(247, 249, 251);
            HeaderLabel.font = [UIFont boldSystemFontOfSize:13];
            HeaderLabel.textColor = JDRGBAColor(153, 153, 153);
            HeaderLabel.text = @"    已选商品";
            [view addSubview:HeaderLabel];
     

        
        return view;
    }
    return  [super tableView:tableView viewForHeaderInSection:section];
    
    
}





#pragma mark ========== 尾视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        view.backgroundColor = KClearColor;
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"JDFooterView" owner:self options:nil];
        self.footerView = [nib objectAtIndex:0];
        self.footerView.frame = CGRectMake(0, 0, KScreenWidth, 50);
        [view addSubview:self.footerView];
        [self footerValue];
        //打印
        kWeakSelf(self);
        self.footerView.bt2Block = ^{
            AD_MANAGER.noteno = weakself.resultDic[@"djhm"];
            [AD_SHARE_MANAGER blueToothCommonActionNav:weakself.navigationController];
        };
        
        
        return view;
    }
    return [super tableView:tableView viewForFooterInSection:section];
    
}
-(void)footerValue{
    UIButton * btn1 = [self.footerView viewWithTag:30002];
    UIButton * btn2 = [self.footerView viewWithTag:30001];
    [btn2 setTitle:@"打印" forState:0];
    btn1.hidden = YES;
    
    UILabel * label1 = [self.footerView viewWithTag:30003];
    label1.text = @"总计";
    UILabel * label2 = [self.footerView viewWithTag:30004];
    label2.text = self.lbl6.text;
    
    
    if (ORDER_ISEQUAl(ChuKuDan)) {
        label2.text = self.lbl5.text;
    }
    if (ORDER_ISEQUAl(ZhiFaDan)) {
        btn2.hidden = YES;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 3 ? 50 : 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 5) {
        [self cellAShenHeAxtion:self.connectLbl.text];
    }
}
//点击预定单已审核
-(void)cellAShenHeAxtion:(NSString *)noteno{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDOrder1TableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDOrder1TableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = noteno;
    [self.navigationController pushViewController:VC animated:YES];
}
/**
 *  是否显示返回按钮
 */
- (void) setIsShowLiftBack:(BOOL)isShowLiftBack
{
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        [self addNavigationItemWithImageNames:@[@"icon_back"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
- (void)backBtnClicked
{
    for (UIViewController * VC in [self.navigationController viewControllers]) {
        if ([VC isKindOfClass:[JDAllOrderViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }else{
            
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)getZhiFaDanFullData{
    NSMutableArray * colorArray = [[NSMutableArray alloc]init];
    //最后一步开始造最难的colorModel
    //第一步先拿到颜色model的数组 tbnote_spckcbs
    NSMutableArray * spidArray = [[NSMutableArray alloc]init];
    NSString * typeString = @"tbnote_spzfcbs";
    for (NSDictionary * dic in self.resultDic[typeString]) {
        JDAddColorModel * colorModel = [[JDAddColorModel alloc]init];
        [colorModel setValuesForKeysWithDictionary:dic];
        [colorModel setValue:doubleToNSString([dic[@"xsdj"] doubleValue]) forKey:@"savePrice"];
        [colorModel setValue:NSIntegerToNSString([dic[@"spps"] integerValue]) forKey:@"savePishu"];
        [colorModel setValue:dic[@"khkh"] forKey:@"saveKhkh"];
        [colorModel setValue:dic[@"bz"] forKey:@"saveBz"];
        [colorModel setValue:doubleToNSString([dic[@"xskc"] doubleValue])  forKey:@"savekongcha"];
        
        [colorModel setValue:dic[@"jldw"] forKey:@"saveDanWei"];
        [colorModel setValue:doubleToNSString([dic[@"spsl"] doubleValue]) forKey:@"saveCount"];
        
        [colorModel setValue:dic[@"fjldw"] forKey:@"saveFuDanWei"];
        [colorModel setValue:doubleToNSString([dic[@"spfsl"] doubleValue]) forKey:@"saveFuCount"];
        
        [colorArray addObject:colorModel];
        [spidArray addObject:NSIntegerToNSString([dic[@"spid"] integerValue])];
    }
    NSSet *set = [NSSet setWithArray:spidArray];
    [spidArray removeAllObjects];
    //得到去除重复颜色的数组
    spidArray = [NSMutableArray arrayWithArray:[set allObjects]];
    //拼接出来以spid为key的数组
    for (NSString * spidStr in spidArray) {
        [AD_MANAGER.sectionArray addObject:@{spidStr:[[NSMutableArray alloc]init]}];
    }
    for (JDAddColorModel * colorModel in colorArray) {
        for (NSInteger i = 0; i < spidArray.count; i++) {
            if (colorModel.spid == [spidArray[i] integerValue]) {
                [AD_MANAGER.sectionArray[i][spidArray[i]] addObject:colorModel];
            }
        }
    }
    //销售单需要另外加一步，合并相同颜色的米数
    //算出相同颜色共有多少匹 多少米 然后再遍历数组，
    NSMutableArray * secCopyArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.sectionArray];
    for (NSInteger i = 0; i<secCopyArray.count; i++) {
        NSDictionary * dic2 = secCopyArray[i];
        //得到key后所有value
        NSArray * arr2 = dic2[[dic2 allKeys][0]];
        //先得到相同颜色的key
        NSMutableArray * ysArray = [[NSMutableArray alloc]init];
        for (JDAddColorModel * colorModel in arr2) {
            [ysArray addObject:colorModel.ys];
        }
        NSSet *set = [NSSet setWithArray:ysArray];
        [ysArray removeAllObjects];
        //得到去除重复颜色的数组
        ysArray = [NSMutableArray arrayWithArray:[set allObjects]];
        NSMutableDictionary * dic3 = [[NSMutableDictionary alloc]init];
        for (NSString * ysStr in ysArray) {
            NSMutableArray * psArray = [[NSMutableArray alloc]init];
            for (JDAddColorModel * colorModel in arr2) {
                if ([colorModel.ys isEqualToString:ysStr]) {
                    [psArray addObject:@{@"xssl":colorModel.saveCount,@"xsfsl":colorModel.saveFuCount}];
                }
            }
            [dic3 setValue:psArray forKey:ysStr];
        }
        // 去除数组中model重复
        //保留第一个元素，增加psarray
        NSMutableArray * arr4 = [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] copy];
        for (NSInteger k = 0; k < arr4.count; k++) {
            for (NSInteger j = k+1;j < arr4.count; j++) {
                JDAddColorModel  *tempModel = arr4[k];
                JDAddColorModel  *model = arr4[j];
                if ([tempModel.ys isEqualToString:model.ys]) {
                    [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] removeObject:model];
                }
            }
        }
        NSMutableArray * arr3 = AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]];
        for ( JDAddColorModel * colorModel3 in arr3) {
            colorModel3.psArray = dic3[colorModel3.ys];
            NSMutableArray * newArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in colorModel3.psArray) {
                [newArray addObject:dic[@"xssl"]];
            }
        }
    }
}

@end
