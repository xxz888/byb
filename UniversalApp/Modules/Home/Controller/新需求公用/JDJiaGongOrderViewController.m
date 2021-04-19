//
//  JDJiaGongOrderViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDJiaGongOrderViewController.h"
#import "JDJiaGongOrderTableViewCell.h"
@interface JDJiaGongOrderViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataSource;

@end
@implementation JDJiaGongOrderViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"请选择单号";
    self.navigationController.navigationBar.hidden = NO;
    self.dataSource = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"JDJiaGongOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDJiaGongOrderTableViewCell"];
    
    NSDictionary * dic = @{
                                           @"begindate":@"2018-01-01T00:00:00",
                                           @"enddate":[NSString currentDateString],
                                           @"khddh":@"",
                                           @"kmnc":@"",
                                           @"djhm":@""
                         };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"condition":string}];
    kWeakSelf(self);
    [AD_MANAGER requestJiaGongOrderList:mDic success:^(id object) {
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:object[@"data"]];
        [weakself.yxTableView reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDJiaGongOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDJiaGongOrderTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataSource[indexPath.row];
    cell.nameLbl.text = [dic[@"khmc"] append:kGetString(dic[@"djhm"])];;
    cell.shuliangLbl.text = kGetString(dic[@"xssl"]);
    cell.pishuLbl.text = kGetString(dic[@"xsps"]);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataSource[indexPath.row];

    [AD_MANAGER.affrimDic setValue:kGetString(dic[@"djhm"]) forKey:@"ddhm"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
