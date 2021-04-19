//
//  JDDYManagerViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDDYManagerViewController.h"
#import "JDDYManagerTableViewCell.h"
#import "JDDYDetailTableViewController.h"
#import "JDDYManagerTableViewCell.h"

@interface JDDYManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * underTableView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation JDDYManagerViewController

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
                                                                             @"qx":@(1),

                                                                             @"keywords":self.searchTf.text
                                                                             }];
    [AD_MANAGER requestDYListAction:mDic success:^(id object) {
        [weakself refreshVC:object];
    }];
    
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
        [_underTableView registerNib:[UINib nibWithNibName:@"JDDYManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDDYManagerTableViewCell"];
        [self.bottomView addSubview:_underTableView];
    }
    return _underTableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDDYManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDDYManagerTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    NSDictionary * dic = self.dataSource[indexPath.row];
    cell.titleLbl.text = dic[@"ygmc"];
    cell.bmLbl.text = dic[@"ygbm"];
    NSString *string1  = @"";
    if (dic[@"tbsys_ygjs"] && dic[@"tbsys_ygjs"] != [NSNull null]) {
        NSMutableArray * arr1 = [[NSMutableArray alloc]init];
        for (NSDictionary * dic1 in dic[@"tbsys_ygjs"]) {
           [arr1 addObject:dic1[@"jsmc"]];
        }
         string1  = [arr1 componentsJoinedByString:@","];
    }
    cell.qxLbl.text = string1;
    cell.phoneLbl.text = dic[@""];
    NSString *string2 = @"";
    if (dic[@"tbsys_ygckczqxs"] && dic[@"tbsys_ygckczqxs"]!= [NSNull null]) {
        NSMutableArray * arr2 = [[NSMutableArray alloc]init];
        for (NSDictionary * dic2 in dic[@"tbsys_ygckczqxs"]) {
            [arr2 addObject:dic2[@"ckmc"]];
        }
        string2 = [arr2 componentsJoinedByString:@","];
    }
    cell.addressLbl.text = string2;
    cell.bzLbl.text = dic[@"bz"];
    cell.statusLb.text = [dic[@"sfdj"] integerValue] == 1 ? @"已冻结" : @"使用中";
    cell.statusLb.textColor = [dic[@"sfdj"] integerValue] == 1 ?  JDRGBAColor(38, 207, 126) : JDRGBAColor(246, 62, 32);
    return cell;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self requestData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestData];
    return YES;
}
- (IBAction)addAction:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDDYDetailTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDDYDetailTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDDYDetailTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDDYDetailTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    NSDictionary * dic = self.dataSource[indexPath.row];
    VC.ygid = [dic[@"ygid"] integerValue];
    VC.phoneStr = dic[@"sjhm"];
    VC.whereCome = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
