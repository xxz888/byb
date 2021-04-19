//
//  JDAllMdViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAllMdViewController.h"
#import "JDAllMdTableViewCell.h"
#import "JDAddMdViewController.h"
@interface JDAllMdViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * underTableView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation JDAllMdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc]init];
    self.searchTf.delegate = self;
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    [self requestData];
}
-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@(1),
                                                                             @"pagesize":@(1000),
                                                                             @"keywords":self.searchTf.text
                                                                             }];
    if ([self.whereCome isEqualToString:MMD]) {
        [AD_MANAGER requestAllMdAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }else if ([self.whereCome isEqualToString:YYHFS]){
        [AD_MANAGER requestYHFSListAction:mDic success:^(id object) {
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
        _underTableView = [[UITableView alloc]initWithFrame:self.bottomView.bounds style:UITableViewStylePlain];
        _underTableView.delegate = self;
        _underTableView.dataSource = self;
        _underTableView.backgroundColor = JDRGBAColor(247, 249, 251);
        _underTableView.tableFooterView = [[UIView alloc]init];
        _underTableView.separatorStyle = 0;
        [_underTableView registerNib:[UINib nibWithNibName:@"JDAllMdTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDAllMdTableViewCell"];
        [self.bottomView addSubview:_underTableView];
    }
    return _underTableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"JDAllMdTableViewCell";
    JDAllMdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[JDAllMdTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.selectionStyle = 0;
    NSDictionary * dic = self.dataSource[indexPath.row];
    cell.mdLbl.text =[self.whereCome isEqualToString:MMD]? dic[@"mdmc"] : dic[@"zklxmc"];
    cell.bzLbl.text = dic[@"bz"];
    cell.stateLBl.text = [dic[@"sfdj"] integerValue] == 1 ? @"已冻结" : @"使用中";
    cell.stateLBl.textColor = [dic[@"sfdj"] integerValue] == 1 ?  JDRGBAColor(38, 207, 126) : JDRGBAColor(246, 62, 32);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDAddMdViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAddMdViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = YES;
    VC.where = self.whereCome;
    VC.resultDic = [NSDictionary dictionaryWithDictionary:self.dataSource[indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)addNewBtnAction:(id)sender{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDAddMdViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAddMdViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = NO;
    VC.where = self.whereCome;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self requestData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestData];
    return YES;
}

- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
