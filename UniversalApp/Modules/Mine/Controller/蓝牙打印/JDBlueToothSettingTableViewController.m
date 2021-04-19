//
//  JDBlueToothSettingTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/18.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDBlueToothSettingTableViewController.h"
#import "SelectedListView.h"
@interface JDBlueToothSettingTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray * _wayTitleArray;
}

@end
#define titileArray  @[@"商品颜色合并",@"商品颜色缸号合并",@"商品合并"]
@implementation JDBlueToothSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated{
    self.dayinmokuaiLbl.text = AD_MANAGER.printWay[@"wayname"];
    if (!AD_MANAGER.printWay[@"wayname"] || [AD_MANAGER.printWay[@"wayname"] isEqualToString:@""]) {
        self.dayinmokuaiLbl.text = @"请选择打印模块";
    }
}
-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"":@""}];
    [AD_MANAGER requestBlueShow:mDic success:^(id object) {
        _resultDic = [[NSMutableDictionary alloc]initWithDictionary:object[@"data"]];
        
        //单位名称
        weakself.danweiTf.text = _resultDic[@"dW_DWMC"];
        //匹数
        weakself.pishuTf.text = NSIntegerToNSString([_resultDic[@"notE_MHDYPS"] integerValue]);
        //打印份数
        weakself.fenshuTf.text = NSIntegerToNSString([_resultDic[@"notE_ZDYSKKZ"] integerValue]);
        //单位1
        weakself.danwei1Tf.text = _resultDic[@"dW_DWXX1"];
        weakself.danwei2Tf.text = _resultDic[@"dW_DWXX2"];
        weakself.danwei3Tf.text = _resultDic[@"dW_DWXX3"];
        weakself.danwei4Tf.text = _resultDic[@"dW_DWXX4"];
        weakself.danwei5Tf.text = _resultDic[@"dW_DWXX5"];
        weakself.shujugeshiLbl.text = titileArray[[_resultDic[@"notE_DYGS"] integerValue]];
    }];
    
     //打印方式请求
    [self printWayStyle];
   

}
- (IBAction)dayinmokuaiAction:(id)sender {
    [self printAction:_wayTitleArray];

}
- (IBAction)fenleigeshiAtion:(id)sender {
    [self fenleiTypeAction];

}
//打印方式请求
-(void)printWayStyle{
    kWeakSelf(self);
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
    _wayTitleArray = [[NSMutableArray alloc]initWithArray:object[@"data"]];
    if (_wayTitleArray.count != 0) {
//        self.dayinmokuaiLbl.text = _wayTitleArray[0][@"name"];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
    }else if (indexPath.row == 5){
    }
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
            weakself.dayinmokuaiLbl.text = model.title;
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


//数据分类格式
- (void)fenleiTypeAction{
    
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    NSMutableArray * mArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0 ; i <  titileArray.count; i++) {
        [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:titileArray[i]]];
    }
    view.array = [NSArray arrayWithArray:mArray];
    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            weakself.shujugeshiLbl.text = model.title;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

@end
