//
//  JDSalesActionViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDZhiFaDan1ViewController.h"
#import "JDSelectClientViewController.h"
#import "JDSalesTableViewCell.h"
#import "JDSelectClientModel.h"
#import "JDSelectOddViewController.h"
#import "JDSelectOddTagViewController.h"
#import "JDAddSpViewController.h"
#import "JDZhiFaDan2ViewController.h"

@interface JDZhiFaDan1ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;

@property (nonatomic,copy) UITableView * bottomTableView;


@end

@implementation JDZhiFaDan1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title =  @"选择供应商" ;
    self.searchTf.placeholder = @"请输入供应商名称或手机号..." ;
    
    aa = [[JDParModel alloc]init];
    
    aa.tbnote_spzfcbs = [[NSMutableArray alloc]init];
    aa.tbnote_spzfcb_gyszks = [[NSMutableArray alloc]init];
    aa.tbnote_spzfcb_fks = [[NSMutableArray alloc]init];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    cell.titleNameLbl.text =model.gysmc ;
    cell.debtMoneyLbl.text = CCHANGE_DOUBLE(model.yfzk);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JDSelectClientModel * model  = AD_MANAGER.selectKhPageArray[indexPath.row];
    [AD_MANAGER.affrimDic setValue:model forKey:@"gongyingshang"];
    aa.gysid = intToNSString(model.gysid);
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"XinXuQiu" bundle:nil];
    JDZhiFaDan2ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDZhiFaDan2ViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 选择按钮方法 ==========
- (IBAction)selectBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========== 搜索框值改变，开始网络请求 ==========
- (IBAction)searchTfChanged:(UITextField *)tf {

    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@1,@"pagesize":@10000,@"keywords":[tf.text isEqualToString:@""] ? @"wwwppp" : tf.text}];
    kWeakSelf(self);
    [AD_MANAGER requestGongYingShangListAction:mDic success:^(id object) {
        [weakself.bottomTableView reloadData];
    }];
    
}
-(JDSelectClientModel * )getNoClientModel{
    BOOL have = NO;
    JDSelectClientModel * sendModel;
    for (JDSelectClientModel * model in AD_MANAGER.selectKhPageArray) {
        if ([model.gysmc  contains:self.searchTf.text]) {
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
        [model setValue:self.searchTf.text forKey:@"gysmc"];
        [model setValue:@(0) forKey:@"gysid"];
        return model;
    }
}
@end
