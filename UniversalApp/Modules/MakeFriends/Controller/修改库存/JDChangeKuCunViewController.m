//
//  JDChangeKuCunViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/25.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDChangeKuCunViewController.h"
#import "JDChangeKuCunTableViewCell.h"
#import "SelectedListView.h"
@interface JDChangeKuCunViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _ckid;
}
@property(nonatomic,strong)UITableView * bottomTableView;
@property (nonatomic,strong) NSMutableArray * allCkDataSource;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation JDChangeKuCunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改库存";
    _dataSource = [[NSMutableArray alloc]init];
    
    _allCkDataSource = [[NSMutableArray alloc]init];
    
    [self addNavigationItemWithTitles:@[@"保存"] isLeft:NO target:self action:@selector(saveInfo:) tags:@[@9001]];
    
    
    [self requestData];
}
-(void)saveInfo:(UIButton *)btn{
    NSMutableArray * countArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < _dataSource.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        JDChangeKuCunTableViewCell * cell = [self.bottomTableView cellForRowAtIndexPath:indexPath];
        [countArray addObject:@{@"spsl":@([cell.kcTf.text doubleValue]),
                                @"spps":@([cell.psTf.text doubleValue]),
                                @"ckid":@(_ckid),
                                @"spid":@(_spid),
                                @"sh":@([_dataSource[i][@"sh"] integerValue]),
                                }];
    }
    
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":[ADTool arrayConvertToNSString:countArray]}];
    
    [AD_MANAGER requestSaveKuCunAction:mDic success:^(id object) {
       
        [weakself showToast:@"保存成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)requestData{
    kWeakSelf(self);

    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pagesize":@10000}];

    [AD_MANAGER requestSelectCkPage:mDic success:^(id object) {
        [_allCkDataSource removeAllObjects];
        [_allCkDataSource addObjectsFromArray:object[@"data"][@"list"]];
    
        if (_allCkDataSource.count > 0) {
            [weakself.selectCangKuBtn setTitle:_allCkDataSource[0][@"ckmc"] forState:0];
            _ckid = [_allCkDataSource[0][@"ckid"] integerValue];
            [weakself requestDetail:_ckid];
        }
    }];

}
-(void)requestDetail:(NSInteger)ckid{
    kWeakSelf(self);
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"sh":@"",@"spid":@(self.spid),@"ckid":@(ckid)}];
    [AD_MANAGER requestChangeKuCunAction:mDic1 success:^(id object) {
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:object[@"data"]];
        [weakself.bottomTableView reloadData];
    }];
}
#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:self.bottomView.bounds style:UITableViewStylePlain];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDChangeKuCunTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDChangeKuCunTableViewCell"];
        _bottomTableView.separatorStyle = 0;
        [self.bottomView addSubview:_bottomTableView];
    }
    return _bottomTableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"JDChangeKuCunTableViewCell";
    JDChangeKuCunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.selectionStyle = 0;
    if (!cell) {
        cell = [[JDChangeKuCunTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    NSDictionary * dic = _dataSource[indexPath.row];
    cell.ysLbl.text = dic[@"ys"];
    cell.psTf.text = NSIntegerToNSString([dic[@"kczps"] doubleValue]);
    cell.kcTf.text = NSIntegerToNSString([dic[@"kczsl"] doubleValue]);

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (IBAction)selectCangKuAction:(id)sender {
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < _allCkDataSource.count; i++) {
        [array addObject:[[SelectedListModel alloc] initWithSid:[_allCkDataSource[i][@"ckid"] integerValue] Title:_allCkDataSource[i][@"ckmc"]]];
    }
    view.array = [NSArray arrayWithArray:array];
    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            [weakself.selectCangKuBtn setTitle:model.title forState:0];
            _ckid = model.sid;
            [weakself requestDetail:model.sid];
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


@end
