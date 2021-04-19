//
//  JDSalesSearchTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/13.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSalesSearchTableViewController.h"
#import "SelectedListView.h"
#import "JDSelectClientViewController.h"
@interface JDSalesSearchTableViewController (){
    NSMutableDictionary * _resultDic;
}

@end
@implementation JDSalesSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询条件";
    _resultDic = [[NSMutableDictionary alloc]init];
    [self addNavigationItemWithTitles:@[@"清空"] isLeft:NO target:self action:@selector(clearData:) tags:nil];
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (AD_MANAGER.affrimDic[@"khmc"]) {
        [self.khmcBtn setTitle:AD_MANAGER.affrimDic[@"khmc"] forState:0];
        [self.khmcBtn setTitleColor:KBlackColor forState:0];

    }
}
-(void)clearData:(UIButton *)btn{
    [self.startBtn setTitle:@"开始时间" forState:0];
    [self.endBtn setTitle:@"结束时间" forState:0];
    [self.khbqBtn setTitle:@"" forState:0];
    [self.khmcBtn setTitle:@"" forState:0];
    self.spmcTf.text = @"";
    self.ystf.text = @"";
    [self.ywyBtn setTitle:@"" forState:0];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (IBAction)khbqAction:(id)sender {
    
    [self requestData];
}

-(void)requestData{
    
    NSMutableDictionary* mDic3 = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    [AD_MANAGER requestKeHuBiaoQianList:mDic3 success:^(id object) {
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i <  [object[@"data"] count]; i++) {
            [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:object[@"data"][i]]];
        }
        view.array = [NSArray arrayWithArray:mArray];
        kWeakSelf(self);
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                [weakself.khbqBtn setTitleColor:KBlackColor forState:0];
                
                [weakself.khbqBtn setTitle:model.title forState:0];
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
- (IBAction)khmcAction:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDSelectClientViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSelectClientViewController"];
    VC.whereInteger = 1;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)ywyAction:(id)sender {
    NSMutableDictionary* mDic3 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pagesize":@"500",@"pon":@"",@"keywords":@""}];
    [AD_MANAGER requestSelectYgPage:mDic3 success:^(id object) {
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i <  AD_MANAGER.selectYgPageArray.count; i++) {
            JDSelectYgModel * ygModel = AD_MANAGER.selectYgPageArray[i];
            [mArray addObject:[[SelectedListModel alloc] initWithSid:ygModel.ygid Title:ygModel.ygmc]];
        }
        view.array = [NSArray arrayWithArray:mArray];
        kWeakSelf(self);
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                [weakself.ywyBtn setTitleColor:KBlackColor forState:0];
                [_resultDic setValue:@(model.sid) forKey:@"ywyid"];

                [weakself.ywyBtn setTitle:model.title forState:0];
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
- (IBAction)startTimeAction:(id)sender{
    kWeakSelf(self);
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(0, 40, KScreenWidth, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    ipad_alertController;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        [weakself.startBtn setTitleColor:KBlackColor forState:0];
        [weakself.startBtn setTitle:[date stringWithFormat:@"yyyy-MM-dd"] forState:0];
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)endTimeBtnAction:(id)sender{
    kWeakSelf(self);
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    
    picker.frame = CGRectMake(0, 40, KScreenWidth, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    ipad_alertController;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        [weakself.endBtn setTitleColor:KBlackColor forState:0];

        [weakself.endBtn setTitle:[date stringWithFormat:@"yyyy-MM-dd"] forState:0];

    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//{"pagesize":20,"khid":"3","khtag":"大客户","ys":"","spvalue":"","ywyid":"3","pageno":1,"enddate":"2018-8-13","begindate":"2017-8-13"}

- (IBAction)searchAction:(id)sender {
    [_resultDic setValue:@1 forKey:@"pageno"];
    [_resultDic setValue:@1000 forKey:@"pagesize"];
    [_resultDic setValue:@([AD_SHARE_MANAGER inCangkuNameOutCangkuId:self.khmcBtn.titleLabel.text]) forKey:@"khid"];
    [_resultDic setValue:[self.khbqBtn.titleLabel.text isEqualToString:@"请选择客户标签"] ? @"" :self.khbqBtn.titleLabel.text  forKey:@"khtag"];

    [_resultDic setValue:self.ystf.text forKey:@"ys"];
    [_resultDic setValue:self.spmcTf.text forKey:@"spvalue"];
    [_resultDic setValue:self.endBtn.titleLabel.text forKey:@"enddate"];
    [_resultDic setValue:self.startBtn.titleLabel.text forKey:@"begindate"];

    self.sendBlock(_resultDic);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
