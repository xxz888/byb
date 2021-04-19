//
//  JDClientCheckingDetailViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDClientCheckingDetailViewController.h"
#import "JDClientCheckingDetailTableViewCell.h"
@interface JDClientCheckingDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * bottomTableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSMutableArray * optData;
@end

@implementation JDClientCheckingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.whereCome ? @"供应商应付账款明细" : @"客户应收账款明细";
    [self requestData];
}

-(void)requestData{
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:self.paramtersDic];
    kWeakSelf(self);

    if (self.whereCome) {
        [AD_MANAGER requestQueryyfzkmx_list:mDic success:^(id object) {
            weakself.dataSource = [NSMutableArray arrayWithArray:object[@"data"][@"list"]];
            [weakself.bottomTableView reloadData];
        }];
    }else{
        NSString * string = [ADTool dicConvertToNSString:@{
                                @"begindate":_paramtersDic[@"begindate"],
                                @"enddate":_paramtersDic[@"enddate"],
                                @"khid":_paramtersDic[@"khid"],
                                @"xsqc":@(1),
                                @"xsbyhj":@(1),
                                @"mobile":@(1)}];
        NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"Condition":string}];
        [AD_MANAGER requestQueryyszkmx_list:mDic success:^(id object1) {
            [AD_MANAGER requestKeHuYszk:mDic2 success:^(id object2) {
                       NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
                           NSString *djhm = evaluatedObject[@"djhm"];
                           return djhm.length > 0;
                       }];
                       NSArray *result = [NSMutableArray arrayWithArray:object2[@"data"][@"data"]];
                       result = [result filteredArrayUsingPredicate:predicate];
                       weakself.optData = [result mutableCopy];
                       weakself.dataSource = [NSMutableArray arrayWithArray:object1[@"data"][@"list"]];
                       [weakself.bottomTableView reloadData];
                   }];
        }];
    }
}

-(NSDictionary *)getItemFromOptByDjhm:(NSString *)djhm_target
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
        return [djhm_target isEqualToString:evaluatedObject[@"djhm"]];
    }];
    return [[self.optData filteredArrayUsingPredicate:predicate] firstObject];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:0];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        _bottomTableView.separatorStyle = 0;
        _bottomTableView.backgroundColor = KClearColor;
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDClientCheckingDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDClientCheckingDetailTableViewCell"];
        [self.view addSubview:_bottomTableView];
    }
    return _bottomTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDClientCheckingDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDClientCheckingDetailTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = _dataSource[indexPath.row];
    NSDictionary *dic_opt = [self getItemFromOptByDjhm:dic[@"djhm"]];
    cell.clientLbl.text = self.clientLbl;//
    cell.lbl1.text = self.whereCome ? [CCHANGE_OTHER(dic[@"rkps"]) append:@"匹"] :  [CCHANGE_OTHER(dic[@"xsps"]) append:@"匹"];
    cell.lbl2.text = self.whereCome ?  CCHANGE(dic[@"jsje"]): CCHANGE(dic[@"zjje"]);
    cell.lbl3.text =  CCHANGE(dic[@"zkje"]);
    cell.lbl4.text = self.whereCome ?  CCHANGE(dic[@"rksl"]):  CCHANGE_OTHER(dic[@"xssl"]);
    cell.lbl5.text = CCHANGE(dic[@"jsje"]);
    cell.lbl6.text = dic[@"djhm"];
    cell.lbl7.text =  self.whereCome ?  dic[@"jsrmc"]: dic[@"ywymc"];
    cell.rightLbl.text = dic[@"djlx"];
    cell.lastAmountLabel.hidden = self.whereCome;
    cell.lastAmountLabel.text = [NSString stringWithFormat:@"¥ %.2f", [dic_opt[@"jeqm"] floatValue]];
    
    // cell.lastAmountLabel.text = self.whereCome ? @"" : dic[@"zjje"];
    // 这个地方用哪个日期？
    cell.dateLabel.text = dic[@"zdrq"];
    return cell;
}

@end
