//
//  JDWaringViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDWaringViewController.h"
#import "SelectedListView.h"
#import "JDSelectCkPageModel.h"
#import "JDWaringTableViewCell.h"
@interface JDWaringViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * bottomTableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation JDWaringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"库存预警";
    _dataSource = [[NSMutableArray alloc]init];
    [self requestData:@""];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:self.bottomView.bounds style:UITableViewStylePlain];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        _bottomTableView.separatorStyle = 0;
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDWaringTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDWaringTableViewCell"];
        [self.bottomView addSubview:_bottomTableView];
    }
    return _bottomTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDWaringTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDWaringTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = _dataSource[indexPath.row];
    cell.clientLbl.text = dic[@"spmc"];
    cell.lbl1.text = [NSString stringWithFormat:@"%@(%@)",dic[@"ys"],dic[@"sh"]];
    cell.lbl2.text = doubleToNSString([dic[@"spps"] doubleValue]);
    cell.lbl3.text = doubleToNSString([dic[@"spsl"] doubleValue]);
    cell.lbl4.text = doubleToNSString([dic[@"zdkcspsl"] doubleValue]);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)requestData:(NSString *)parameters{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic;
    if ([self.selectBtn.titleLabel.text isEqualToString:@"所有仓库"]) {
        mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"100"}];
    }else{
        mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"100",@"ckmc":parameters}];
    }
    [AD_MANAGER requestQueryckbj_list:mDic success:^(id object) {
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:object[@"data"][@"list"]];
        [weakself.bottomTableView reloadData];
    }];
}



- (IBAction)selectStock:(id)sender {
    NSMutableDictionary* mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pagesize":@"500"}];
    [AD_MANAGER requestSelectCkPage:mDic1 success:^(id object) {
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i <  AD_MANAGER.selectCkPageArray.count; i++) {
            JDSelectCkPageModel * ckModel = AD_MANAGER.selectCkPageArray[i];
            [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:ckModel.ckmc]];
        }
        [mArray insertObject:[[SelectedListModel alloc] initWithSid:0 Title:@"所有仓库"] atIndex:0];
        view.array = [NSArray arrayWithArray:mArray];
        kWeakSelf(self);
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                [weakself.selectBtn setTitle:model.title forState:0];
                [weakself requestData:model.title];
    
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
@end
