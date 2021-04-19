//
//  JDSalesActionViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSalesActionViewController.h"
#import "JDSelectClientViewController.h"
#import "JDSalesTableViewCell.h"
#import "JDSelectClientModel.h"
#import "JDSelectOddViewController.h"
#import "JDSelectOddTagViewController.h"
#import "JDAddSpViewController.h"
#import "JDSalesTagViewController.h"



@interface JDSalesActionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;

@property (nonatomic,copy) UITableView * bottomTableView;


@end

@implementation JDSalesActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CaiGouBOOL ? @"选择供应商" : @"选择客户";
    self.searchTf.placeholder = CaiGouBOOL ? @"请输入供应商名称或手机号..." : @"请输入客户名称或手机号...";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self.searchTf becomeFirstResponder];
    
    if ([self.OpenType isEqualToString:@"SPVC"]) {
        [self.selectBtn setTitle:@"取消" forState:0];
    }
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========== 创建tableview ==========
#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:self.bottomView.bounds style:UITableViewStylePlain];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDSalesTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSalesTableViewCell"];
        [self.bottomView addSubview:_bottomTableView];
        _bottomTableView.tableFooterView = [[UIView alloc]init];
        _bottomTableView.separatorStyle = 0;
    }
    return _bottomTableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return AD_MANAGER.selectKhPageArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDSalesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDSalesTableViewCell" forIndexPath:indexPath];
    JDSelectClientModel * model = AD_MANAGER.selectKhPageArray[indexPath.row];

    cell.titleNameLbl.text = CaiGouBOOL ? model.gysmc : model.khmc;
    if (CaiGouBOOL) {
        cell.debtMoneyLbl.text = CCHANGE_DOUBLE(model.yfzk);

    }else{
        cell.debtMoneyLbl.text = CCHANGE_DOUBLE(model.yszk);

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JDSelectClientModel * model  = AD_MANAGER.selectKhPageArray[indexPath.row];
    if (CaiGouBOOL) {
        [AD_MANAGER.affrimDic setValue:model.gysmc forKey:@"gysmc"];

    }else{
        [AD_MANAGER.affrimDic setValue:model.khmc forKey:@"khmc"];
      
    }
    if (self.shoukuankehuBlock) {
              self.shoukuankehuBlock();
          }
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    kWeakSelf(self);
    if ([self.OpenType isEqualToString:@"SPVC"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if ([self.OpenType isEqualToString:@"QRVC"]){
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        JDSelectOddTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSelectOddTagViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }

}
#pragma mark ========== 选择按钮方法 ==========
- (IBAction)selectBtnAction:(id)sender {
    kWeakSelf(self);
    if ([self.selectBtn.titleLabel.text isEqualToString:@"取消"]) {
        if ([self.OpenType isEqualToString:@"SPVC"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self commonAction:self.searchTf];
    }
}
#pragma mark ========== 搜索框值改变，开始网络请求 ==========
- (IBAction)searchTfChanged:(UITextField *)tf {
    //改变的话，更改选择按钮的titile
    if (tf.text.length == 0) {
        [self.selectBtn setTitle:@"取消" forState:0];
    }else{
        [self.selectBtn setTitle:@"完成" forState:0];

    }
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@1,@"pagesize":@10000,@"keywords":[tf.text isEqualToString:@""] ? @"wwwppp" : tf.text}];
    kWeakSelf(self);

    if (CaiGouBOOL) {
        [AD_MANAGER requestGongYingShangListAction:mDic success:^(id object) {
            [weakself.bottomTableView reloadData];
        }];
    }else{
        [AD_MANAGER requestSelectKhPage:mDic success:^(id str) {
            [weakself.bottomTableView reloadData];
        }];
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self commonAction:textField];
    return YES;
}
-(void)commonAction:(UITextField *)textField{
    kWeakSelf(self);
    JDSelectClientModel * model  = [self getNoClientModel];
    if (CaiGouBOOL) {
        [AD_MANAGER.affrimDic setValue:model.gysmc forKey:@"gysmc"];
    }else{
        [AD_MANAGER.affrimDic setValue:model.khmc forKey:@"khmc"];
    }
    if ([weakself.OpenType isEqualToString:@"SPVC"]) {
        if (model.have) {
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString * title = CaiGouBOOL ? @"这个供应商尚未存档,将在下单后为你自动建档!" : @"这个客户尚未存档,将在下单后为你自动建档!";
            [weakself showToast:title];
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        self.selectFinshClientBlock(model);
        [weakself.navigationController popViewControllerAnimated:YES];
    }
}
-(JDSelectClientModel * )getNoClientModel{
        BOOL have = NO;
        JDSelectClientModel * sendModel;
        for (JDSelectClientModel * model in AD_MANAGER.selectKhPageArray) {
            if ([CaiGouBOOL ? model.gysmc : model.khmc contains:self.searchTf.text]) {
                have = YES;
                sendModel = model;
                sendModel.have = have;
                break;
            }else{
                have = NO;
                sendModel.have = have;
            }
        }
        if (have) {
            return sendModel;
        }else{
            JDSelectClientModel * model = [[JDSelectClientModel alloc]init];
            if (CaiGouBOOL) {
                [model setValue:self.searchTf.text forKey:@"gysmc"];
                [model setValue:@(0) forKey:@"gysid"];
            }else{
                [model setValue:self.searchTf.text forKey:@"khmc"];
                [model setValue:@(0) forKey:@"khid"];
            }
            return model;
        }
}
@end
