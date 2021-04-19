
//
//  JDMdCaoZuoViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDMdCaoZuoViewController.h"
#import "JDMdCaoZuoTableViewCell.h"
@interface JDMdCaoZuoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * underTableView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation JDMdCaoZuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"操作记录";
    _dataSource = [[NSMutableArray alloc]init];
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    self.underTableView.tableFooterView = [[UIView alloc]init];
    [self requestData];
}
-(void)requestData{
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@(1),
                                                                             @"pagesize":@(1000),
                                                                             @"key":@(self.key)
                                                                             }];
    kWeakSelf(self);
    //仓库管理操作记录
    if (self.type == 1) {
        [AD_MANAGER requestCKCaoZuoJiLuAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
        //门店管理操作记录
    }else if (self.type == 2){
    [AD_MANAGER requestMdCaoZuoJiLuAction:mDic success:^(id object) {
        [weakself refreshVC:object];
    }];
    //财务管理操作记录
    }else if (self.type == 3){
        [AD_MANAGER requestCWGLCaoZuoAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }//折扣类型
    else if (self.type == 4){
        [AD_MANAGER requestYHFSCaoZuoAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }//送货人管理
    else if (self.type == 5){
        [AD_MANAGER requestSHRCaoZuoAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }//店员管理
    else if (self.type == 6){
        [AD_MANAGER requestDYCaoZuoAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }//商品管理
    else if (self.type == 7){
        [AD_MANAGER requestSpCaoZuoAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }//商品管理
    else if (self.type == 8){
        [AD_MANAGER requestKeHuCaoZuoAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }//供应商管理
    else if (self.type == 9){
        [AD_MANAGER requestGYSCaoZuoAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }
    
}
-(void)refreshVC:(id)object{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:object[@"data"][@"list"]];
    [self.underTableView reloadData];
}
#pragma mark lazy loading...
-(UITableView *)underTableView {
    if (!_underTableView) {
        _underTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-49) style:UITableViewStylePlain];
        _underTableView.delegate = self;
        _underTableView.dataSource = self;
        [_underTableView registerNib:[UINib nibWithNibName:@"JDMdCaoZuoTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDMdCaoZuoTableViewCell"];
        [self.view addSubview:_underTableView];
    }
    return _underTableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDMdCaoZuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDMdCaoZuoTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataSource[indexPath.row];
    cell.titleLb.text = dic[@"ygmc"];
    cell.detailLbl.text =  dic[@"cznr"];
    cell.timeLbl.text = dic[@"czsj"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
