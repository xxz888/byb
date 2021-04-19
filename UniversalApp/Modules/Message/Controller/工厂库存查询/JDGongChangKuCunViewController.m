//
//  JDGongChangKuCunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDGongChangKuCunViewController.h"
#import "JDGongChangKuCunTableViewCell.h"

@interface JDGongChangKuCunViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation JDGongChangKuCunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工厂库存查询";
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableVIew registerNib:[UINib nibWithNibName:@"JDGongChangKuCunTableViewCell" bundle:nil ] forCellReuseIdentifier:@"JDGongChangKuCunTableViewCell"];
    self.tabBarController.tabBar.hidden = YES;

    
    NSDictionary * dic = @{
                           @"gcmc":@"",
                           @"spvalue":@"",
                           @"ys ":@"",
                           };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"condition":string,@"pageno":@(1),@"pagesize":@(200)}];
    kWeakSelf(self);
    [AD_MANAGER requestGongChangKuCun:mDic success:^(id object) {
        [weakself.dataArray addObjectsFromArray:object[@"data"][@"data"]];
        [weakself.yxTableVIew reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDGongChangKuCunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDGongChangKuCunTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.nameLbl.text = dic[@"jgcmc"];
    cell.shangpinLbl.text = dic[@"spmc"];
    cell.yanseLbl.text = dic[@"ys"];
    cell.pishuLbl.text = kGetString(dic[@"spps"]);
    cell.shuliangLbl.text = doubleToNSString([dic[@"spsl"] doubleValue]);
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
