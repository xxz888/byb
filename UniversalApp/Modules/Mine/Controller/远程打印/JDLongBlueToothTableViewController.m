
//
//  JDLongBlueToothTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDLongBlueToothTableViewController.h"
#import "JDBlueToothSettingViewController.h"
#import "JDBluePreviewViewController.h"
#import "SelectedListView.h"
@interface JDLongBlueToothTableViewController ()
@property (nonatomic,strong) NSMutableArray * printWayArray;

@end

@implementation JDLongBlueToothTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _printWayArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    self.title = @"打印设置";
    if (self.whereCome) {
        [self requestSpData];
    }else{
        [self addNavigationItemWithTitles:@[@"打印设置 "] isLeft:NO target:self action:@selector(longPrintSetting:) tags:@[@900]];
        [self requestData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
    self.printstyleLbl.text = AD_MANAGER.printWay[@"wayname"];
    if (!AD_MANAGER.printWay[@"wayname"] || [AD_MANAGER.printWay[@"wayname"] isEqualToString:@""]) {
        self.printstyleLbl.text = @"请选择打印模块";
    }
}
//打印设置
-(void)longPrintSetting:(UIButton *)btn{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"OtherVC" bundle:nil];
    JDBlueToothSettingViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDBlueToothSettingViewController"];
    VC.shArray = [[NSMutableArray alloc]initWithArray:self.shArray];
    VC.spid = self.spid;
    [self.navigationController pushViewController:VC animated:YES];
}
//单子的请求方法
-(void)requestData{
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
    }
}
-(void)getWayArray:(id)object{
    if ([object isKindOfClass:[NSArray class]]) {
        [_printWayArray addObjectsFromArray:object];
    }
    if ([object isKindOfClass:[NSDictionary class]] && object[@"data"]) {
        [_printWayArray addObjectsFromArray:object[@"data"]];
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.whereCome) {
        if (indexPath.row == 2) {
            return 0;
        }
    }else{
        if (indexPath.row == 2) {
            return 50;
        }else if (indexPath.row == 3){
            return 0;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    }
}
//远程打印
- (IBAction)longPrintAction:(id)sender{
    [self printe];
}
#define showAlertStringAction [weakself showToast:@"远程打印命令发送成功"]
//开始远程打印
- (void)printe{
    kWeakSelf(self);

        
        if (ORDER_ISEQUAl(ChuKuDan)) {
            if ([self chenckParamters]) {
                [AD_MANAGER printChuKuLongPrintSaveAction:[self sameParamters]  success:^(id object) {
                    showAlertStringAction;
                }];
            }
        }else if (ORDER_ISEQUAl(XiaoShouDan)){
            if ([self chenckParamters]) {
                [AD_MANAGER printXiaoShouLongPrintSaveAction:[self sameParamters] success:^(id object) {
                    showAlertStringAction;
                }];
            }
        }else if (ORDER_ISEQUAl(YuDingDan)) {
            if ([self chenckParamters]) {
                [AD_MANAGER printYuDingDanLongPrintSaveAction:[self sameParamters]  success:^(id object) {
                    showAlertStringAction;
                }];
            }
        }else if (ORDER_ISEQUAl(YangPinDan)) {
            if ([self chenckParamters]) {
                [AD_MANAGER printYangPinDanLongPrintSaveAction:[self sameParamters]  success:^(id object) {
                    showAlertStringAction;
                }];
            }
        }else if (ORDER_ISEQUAl(TuiHuoDan)) {
            if ([self chenckParamters]) {
                [AD_MANAGER printTuiHuoDanLongPrintSaveAction:[self sameParamters]  success:^(id object) {
                    showAlertStringAction;
                }];
            }
        }else if (ORDER_ISEQUAl(ShouKuanDan)) {
            if ([self chenckParamters]) {
                [AD_MANAGER printShouKuanDanLongPrintSaveAction:[self sameParamters]  success:^(id object) {
                    showAlertStringAction;
                }];
            }
        }else if (ORDER_ISEQUAl(CaiGouRuKuDan)) {
            if ([self chenckParamters]) {
                [AD_MANAGER printCaiGouRuKuDanLongPrintSaveAction:[self sameParamters]  success:^(id object) {
                    showAlertStringAction;
                }];
            }
        }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)) {
            if ([self chenckParamters]) {
                [AD_MANAGER printCaiGouChuKuDanLongPrintSaveAction:[self sameParamters]  success:^(id object) {
                    showAlertStringAction;
                }];
            }
        }else if (ORDER_ISEQUAl(FuKuanDan)) {
            if ([self chenckParamters]) {
                [AD_MANAGER printFuKuanDanLongPrintSaveAction:[self sameParamters]  success:^(id object) {
                    showAlertStringAction;
                }];
            }
        }
        
        
        
        
        
        
        
        
        else if ([AD_MANAGER.orderType isEqualToString:SPDA]){
            NSString * wayname = [AD_MANAGER.printWay[@"wayname"] replaceAll:@"[定制]" target:@""];
            NSInteger cloud = [AD_MANAGER.printWay[@"cloud"] integerValue];
            for (NSString * string in self.shArray) {
                NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"spid":@(self.spid), //商品id
                                                                                          @"sh":@([string integerValue]),
                                                                                         @"iscloud":@(cloud),
                                                                                         @"wayname":wayname,
                                                                                         @"copies":@([self.countLbl.text integerValue]),
                                                                                         }];
                [AD_MANAGER requestSPDALastStepPrintInfoAction:mDic1 success:^(id object) {
                    [weakself showToast:@"远程打印命令发送成功"];
                }];
            }
           
        }
}
-(NSDictionary *)sameParamters{
    NSString * wayname = [AD_MANAGER.printWay[@"wayname"] replaceAll:@"[定制]" target:@""];
    if (wayname) {
        NSInteger cloud = [AD_MANAGER.printWay[@"cloud"] integerValue];
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":AD_MANAGER.noteno, //商品id
                                                                                 @"iscloud":@(cloud),
                                                                                 @"wayname":wayname,
                                                                                 @"copies":@([self.countLbl.text integerValue]),
                                                                                 }];
        return mDic;
    }else{
        [self showToast:@"请选择打印模块"];
        return @{};
    }
}
-(BOOL)chenckParamters{
    return  [[[self sameParamters] allKeys] count] == 0 ? NO : YES;
}
//打印模版
- (void)printAction:(NSMutableArray *)titleArray{
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    NSMutableArray * mArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0 ; i <  titleArray.count; i++) {
        NSInteger cloud = [titleArray[i][@"cloud"] integerValue];
        NSString * string = cloud == 0 ? [@"[定制]" append:titleArray[i][@"name"]]: titleArray[i][@"name"];
        [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:string]];
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
            weakself.printstyleLbl.text = model.title;
            NSInteger cloud = [model.title containsString:@"[定制]"] ? 0 : 1;
            //保存打印参数
            [AD_MANAGER.printWay setValue:model.title forKey:@"wayname"];
            [AD_MANAGER.printWay setValue:@(cloud) forKey:@"cloud"];
            
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

//预览
- (IBAction)printPriviewAction:(id)sender {
    kWeakSelf(self);
    //色卡和单子的参数不一样
    if ([AD_MANAGER.orderType isEqualToString:SPDA]){
        [AD_MANAGER printSPDAPreviewAction:[self spdaParamters]  success:^(id object) {
            [AD_SHARE_MANAGER pushYuLanAction:object nv:weakself.navigationController];
        }];
    }else{
        [AD_SHARE_MANAGER pushPrintYuLan:self.navigationController];
    }
}

- (IBAction)printSelectAction:(id)sender {
    [self printAction:_printWayArray];
}





#pragma mark ========== spda方法 ==========
//spda请求
-(void)requestSpData{
    kWeakSelf(self);
    [_printWayArray removeAllObjects];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    [AD_MANAGER requestSpBQWayAction:mDic success:^(id object) {
        [weakself getWayArray:object[@"data"]];
    }];
}

//spda不一样的参数
-(NSMutableDictionary *)spdaParamters{
    NSString * wayname = AD_MANAGER.printWay[@"wayname"];
    NSInteger cloud = [AD_MANAGER.printWay[@"cloud"] integerValue];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"DpiX":@180,
                                                                             @"cloud":@(cloud),
                                                                             @"wayname":wayname,
                                                                             @"DpiY":@180,
                                                                             @"spid":@(self.spid),
                                                                             @"sh":self.shArray[0]
                                                                             }];
    return mDic;
}
//spda远程打印命令
- (IBAction)spPrintAction:(id)sender {
    kWeakSelf(self);
    NSString * wayname = [self.printstyleLbl.text containsString:@"[定制]"] ? [self.printstyleLbl.text replaceAll:@"[定制]" target:@""] : self.printstyleLbl.text;
    NSInteger iscloud = 0;
    for (NSDictionary * dic in self.printWayArray) {
        if ([dic[@"name"] isEqualToString:wayname]) {
            iscloud = [dic[@"cloud"] integerValue];
        }
    }
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"spid":@(self.spid), //商品id
                                                                             @"iscloud":@(iscloud),
                                                                             @"wayname":wayname,
                                                                             @"copies":@([self.countLbl.text integerValue]),
                                                                             }];
    
    
    [AD_MANAGER printSPDAPrintSendMessageAction:mDic  success:^(id object) {
        [weakself showToast:@"远程打印命令发送成功"];
    }];
}
@end
