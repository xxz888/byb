//
//  JDCKManagerViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDCKManagerViewController.h"
#import "JDCKTableViewCell.h"
#import "JDAddCKViewController.h"
#import "JDAddCWGLViewController.h"
#import "JDShrDetailViewController.h"
@interface JDCKManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * underTableView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation JDCKManagerViewController
//财务和仓库 送货员管理，优惠方式管理  公用一个vc
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
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@(1),
                                                                             @"pagesize":@(1000),
                                                                             @"keywords":self.searchTf.text
                                                                             }];
    kWeakSelf(self);
    if ([self.whereCome isEqualToString:CCK]) {
        [AD_MANAGER requestCKListAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }else if ([self.whereCome isEqualToString:CCWGL]){
        [AD_MANAGER requestCWGLListAction:mDic success:^(id object) {
            [weakself refreshVC:object];
        }];
    }else if ([self.whereCome isEqualToString:SSHR]){
        [AD_MANAGER requestSHRListAction:mDic success:^(id object) {
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
        [_underTableView registerNib:[UINib nibWithNibName:@"JDCKTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDCKTableViewCell"];
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
    JDCKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDCKTableViewCell" forIndexPath:indexPath];

    cell.selectionStyle = 0;
    NSDictionary * dic = self.dataSource[indexPath.row];
    
    
    if ([self.whereCome isEqualToString:CCK]) {
        [self cckCell:dic cell:cell];
    }else if ([self.whereCome isEqualToString:CCWGL]){
        [self ccwglCell:dic cell:cell];
    }else if ([self.whereCome isEqualToString:SSHR]){
        [self shrCell:dic cell:cell];
    }

    cell.bzLbl.text = dic[@"bz"];
    cell.statusLbl.text = [dic[@"sfdj"] integerValue] == 1 ? @"已冻结" : @"使用中";
    cell.statusLbl.textColor = [dic[@"sfdj"] integerValue] == 1 ?  JDRGBAColor(38, 207, 126) : JDRGBAColor(246, 62, 32);
    return cell;
}
-(void)yyhfsCell:(NSDictionary *)dic cell:(JDCKTableViewCell *)cell{
    cell.titleLbl.text = dic[@"zklxmc"];
    cell.addressLbl.hidden = cell.adressLblTag.hidden = cell.typeLBl.hidden = cell.typeLBlTag.hidden = YES;

}
-(void)shrCell:(NSDictionary *)dic cell:(JDCKTableViewCell *)cell{
    cell.titleLbl.text = dic[@"shrmc"];
    cell.typeLBlTag.text = @"手机";
    cell.typeLBl.text = dic[@"sjhm"];
    cell.addressLbl.hidden = cell.adressLblTag.hidden = YES;

}
    
    
-(void)ccwglCell:(NSDictionary *)dic cell:(JDCKTableViewCell *)cell{
    cell.titleLbl.text = dic[@"zhmc"];
    cell.typeLBl.text = [NSString stringWithFormat:@"%@    %@%@",dic[@"zhjc"],@"账号",dic[@"zh"]];
    cell.typeLBlTag.text = @"简称";
    cell.adressLblTag.text = @"账户类型";
    cell.addressLbl.text = [dic[@"zhlx"] integerValue] == 0 ? @"现金" :
    [dic[@"zhlx"] integerValue] == 1 ? @"银行" :
    [dic[@"zhlx"] integerValue] == 2 ? @"支付宝" :
    [dic[@"zhlx"] integerValue] == 3 ? @"微信" : @"其他";
    //账户类型 0:现 1:银行 2:支付宝 3:微信 4:其他
    
    
}

-(void)cckCell:(NSDictionary *)dic cell:(JDCKTableViewCell *)cell{
    cell.titleLbl.text = dic[@"ckmc"];
    
    NSString * str = doubleToNSString([dic[@"cdmj"] doubleValue]);
    
    //仓库类型 0:配货仓 1:储存仓 2:退货仓 3:次品仓
    NSString * str1 = [dic[@"cklx"] integerValue] == 0 ? @"配货仓" :
    [dic[@"cklx"] integerValue] == 1 ? @"储存仓":
    [dic[@"cklx"] integerValue] == 2 ? @"退货仓":@"次品仓";
    cell.typeLBl.text = [NSString stringWithFormat:@"%@%@    %@%@",str1,str,@"联系电话",dic[@"lxdh"]];
    
    cell.addressLbl.text = [NSString stringWithFormat:@"%@%@%@%@",dic[@"sf"],dic[@"cs"],dic[@"dq"],dic[@"jtdz"]];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];

    if ([self.whereCome isEqualToString:CCK]){
        JDAddCKViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAddCKViewController"];
        VC.hidesBottomBarWhenPushed = YES;
        VC.whereCome = YES;
        VC.ckid = [self.dataSource[indexPath.row][@"ckid"] integerValue];
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([self.whereCome isEqualToString:CCWGL]) {//财务管理
        JDAddCWGLViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAddCWGLViewController"];
        VC.hidesBottomBarWhenPushed = YES;
        VC.whereCome = YES;
        VC.navigationController.navigationBar.hidden = NO;
        VC.cwuglId = [self.dataSource[indexPath.row][@"zhid"] integerValue];
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([self.whereCome isEqualToString:SSHR]){
        JDShrDetailViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDShrDetailViewController"];
        VC.hidesBottomBarWhenPushed = YES;
        VC.whereCome = YES;
        VC.navigationController.navigationBar.hidden = NO;
        VC.shrid = [self.dataSource[indexPath.row][@"shrid"] integerValue];
        [self.navigationController pushViewController:VC animated:YES];
        
    }

}

- (IBAction)addNewBtnAction:(id)sender{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    if ([self.whereCome isEqualToString:CCK]) {
        JDAddCKViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAddCKViewController"];
        VC.hidesBottomBarWhenPushed = YES;
        VC.whereCome = NO;
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([self.whereCome isEqualToString:CCWGL]){
        JDAddCWGLViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAddCWGLViewController"];
        VC.hidesBottomBarWhenPushed = YES;
        VC.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([self.whereCome isEqualToString:SSHR]){
        JDShrDetailViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDShrDetailViewController"];
        VC.hidesBottomBarWhenPushed = YES;
        VC.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:VC animated:YES];
        
    }

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
