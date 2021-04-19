//
//  JDClientSouSuoDuiZhangViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2020/3/4.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "JDClientSouSuoDuiZhangViewController.h"
#import "JDClientCheckingTableViewCell.h"
#import "JDClientCheckingDetailViewController.h"
#import "JDDuiZhangExcelViewController.h"
#import "XJCalendarSelecteViewController.h"
#import "SelectedListView.h"
@interface JDClientSouSuoDuiZhangViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSDictionary * dateTimeDic;
@property(nonatomic,strong)NSString * beginrq;
@property(nonatomic,strong)NSString * endrq;
@property (nonatomic, assign) NSInteger  khid;
@property(nonatomic,strong)NSString * wayName;
@property(nonatomic,assign)NSInteger iscloud;


@end

@implementation JDClientSouSuoDuiZhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc]init];
    _searchTf.delegate = self;
    _searchTf.placeholder = self.whereCome ? @"请输入供应商名称" : @"请输入客户名称";

    [self addNavigationItemWithTitles:@[@"查询"] isLeft:NO target:self action:@selector(searchKhmc) tags:nil];
    _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        _bottomTableView.separatorStyle = 0;
        _bottomTableView.backgroundColor = KClearColor;
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDClientCheckingTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDClientCheckingTableViewCell"];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.whereCome) {
        _dateTimeDic = @{@"begindate":@"2015-01-01",
                         @"enddate":[NSString currentDateStringyyyyMMdd],
                         @"gysmc":textField.text};
    }else{
        _dateTimeDic = @{@"begindate":@"2015-01-01",
                         @"enddate":[NSString currentDateStringyyyyMMdd],
                         @"khmc":textField.text};
    }

    [self requestData];
    return YES;
}
-(void)searchKhmc{
    JDClientSouSuoDuiZhangViewController * vc = [[JDClientSouSuoDuiZhangViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:_dateTimeDic];
    if (self.whereCome) {
        [AD_MANAGER requestQueryyfzktj_list:mDic success:^(id object) {
            [weakself.dataSource  removeAllObjects];
            [weakself.dataSource addObjectsFromArray:object[@"data"][@"list"]];
            if (weakself.dataSource.count == 0) {
                [UIView showToast:@"未搜索出结果"];
            }
            [weakself.bottomTableView reloadData];
            [weakself.view endEditing:YES];
        }];
    }else{
        [AD_MANAGER requestQueryyszktj_list:mDic success:^(id object) {
            [weakself.dataSource  removeAllObjects];
            [weakself.dataSource addObjectsFromArray:object[@"data"][@"list"]];
            if (weakself.dataSource.count == 0) {
                [UIView showToast:@"未搜索出结果"];
            }
            [weakself.bottomTableView reloadData];
            [weakself.view endEditing:YES];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDClientCheckingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDClientCheckingTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = _dataSource[indexPath.row];
    cell.weixinBtn.tag = [dic[@"khid"] integerValue];
    if (self.whereCome) {
        cell.clientLBl.text = dic[@"gysmc"];
 
        cell.qimoyingshouTag.text = @"期末应付:";
        cell.shoukuanTag.text = @"应付:";
        cell.weixinBtn.hidden = YES;

    }else{
        cell.clientLBl.text = dic[@"khmc"];
        
        cell.qimoyingshouTag.text = @"期末应收:";
        cell.shoukuanTag.text = @"应收:";
        cell.weixinBtn.hidden = NO;

    }
    cell.lbl1.text = CCHANGE(dic[@"qcys"]);
    cell.lbl2.text = CCHANGE(dic[@"jsys"]);
    cell.lbl3.text = CCHANGE(dic[@"qmys"]);
    cell.lbl4.text = CCHANGE(dic[@"zjys"]);
    cell.lbl5.text = CCHANGE(dic[@"zkje"]);
    cell.lbl6.text = dic[@"lastrzrq"];
    cell.lbl7.text = NSIntegerToNSString([dic[@"wfsywts"] integerValue]);
    cell.rightLbl.text = dic[@"khtag"];
    
    
    __weak typeof(self) weakSelf = self;
    cell.weixinblock = ^(NSInteger index) {
        weakSelf.khid = index;
        [weakSelf selectWay];
        
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = _dataSource[indexPath.row];
    JDClientCheckingDetailViewController * VC = [[JDClientCheckingDetailViewController alloc]init];
    VC.paramtersDic = [NSMutableDictionary dictionaryWithDictionary:_dateTimeDic];
    if (self.whereCome) {
//        if (!Quan_Xian(@"应付账款明细账")) {
//            [UIView showToast:QUANXIAN_ALERT_STRING(@"应付账款明细账")];
//            return;
//        }
        [VC.paramtersDic setValue:dic[@"gysid"] forKey:@"gysid"];
        VC.clientLbl = dic[@"gysmc"];
    }else{
//        if (!Quan_Xian(@"应收账款明细账")) {
//            [UIView showToast:QUANXIAN_ALERT_STRING(@"应收账款明细账")];
//            return;
//        }
        [VC.paramtersDic setValue:dic[@"khid"] forKey:@"khid"];
        VC.clientLbl = dic[@"khmc"];

    }
    VC.whereCome = self.whereCome;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}




- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)selectWay{
    //获取打印方案
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    [AD_MANAGER requestKeHuDuiZhangDanGetWay:mDic1 success:^(id object) {
        if ([object count] == 0) {
            [UIView showToast:@"没有可选择的方案"];
            return;
        }
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in object[@"data"]) {
            [mArray addObject:[[SelectedListModel alloc] initWithSid:[dic[@"cloud"] integerValue] Title:dic[@"name"]]];
        }
        view.array = [NSArray arrayWithArray:mArray];
        kWeakSelf(self);
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                weakself.wayName = model.title;
                weakself.iscloud = model.sid;
                [weakself selectTime];
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
    }];

}

-(void)selectTime{
       kWeakSelf(self);
       XJCalendarSelecteViewController *VC = [[XJCalendarSelecteViewController alloc] init];
       VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
       VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
       [self presentViewController:VC animated:NO completion:nil];
       VC.userSelcetResultBlock = ^(NSMutableDictionary *resultDictM) {
           if (![resultDictM[@"endTime"] isEqualToString:@"结束时间"]) {
               weakself.beginrq = resultDictM[@"startTime"];
               weakself.endrq = resultDictM[@"endTime"];
               [weakself requestFenXiangData];
           }
       };
}
-(void)requestFenXiangData{
    if ([self.beginrq isEqualToString:@"-"] && [self.endrq isEqualToString:@"-"]) {
        [UIView showToast:@"请选择开始时间和结束时间"];
        return;
    }
    if ([self.beginrq isEqualToString:@"-"]) {
        [UIView showToast:@"请选择开始时间"];
         return;
    }
    if ([self.endrq isEqualToString:@"-"]) {
        [UIView showToast:@"请选择结束时间"];
        return;
    }
    
    
    kWeakSelf(self);
 

        //获取页数
        NSString * string = [ADTool dicConvertToNSString:@{
                                      @"begindate":weakself.beginrq,
                                      @"enddate":weakself.endrq,
                                      @"khid":@(weakself.khid),
                                      @"xsqc":@(1),
                                      @"xsbyhj":@(1),
                                      @"mobile":@(1)}];
    NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"Condition":string,@"wayname":self.wayName}];
        [AD_MANAGER requestKeHuDuiZhangDanYeShu:mDic2 success:^(id object) {
            NSInteger count = [object[@"data"] integerValue];
            dispatch_group_t group = dispatch_group_create();
            NSMutableArray * allArray = [[NSMutableArray alloc]init];
            for (NSInteger i = 0; i < count; i++) {
                  dispatch_group_enter(group);
                  //获取最终图片，分页的
                  NSMutableDictionary * mDic3 = [AD_SHARE_MANAGER requestSameParamtersDic:@{
                                 @"Condition":string,
                                 @"aDpiX":@180,
                                 @"aDpiY":@180,
                                 @"Wayname":self.wayName,
                                 @"curpage":@(i+1)}];
                [AD_MANAGER requestKeHuDuiZhangDanTuPian:mDic3 success:^(id object) {
                        [allArray addObject:object[@"img"]];
                         dispatch_group_leave(group);
                }];
            };
            dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //主线程执行
                    NSArray *items = [NSArray arrayWithArray:allArray];
                        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
                    [weakself presentViewController:activityVC animated:TRUE completion:nil];
               });
            });
        }];
   
}
@end
