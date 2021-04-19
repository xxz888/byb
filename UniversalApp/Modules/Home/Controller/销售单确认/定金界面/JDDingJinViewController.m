//
//  JDDingJinViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDDingJinViewController.h"
#import "JDDingJinTableViewCell.h"
@interface JDDingJinViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,copy) UITableView * underTableView;

@end

@implementation JDDingJinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定金确认";
    self.payArray = [[NSMutableArray alloc]init];
    [self requestData];
    
    [self addNavigationItemWithTitles:@[@"完成"] isLeft:NO target:self action:@selector(clickRightBackBtn:) tags:nil];
}

//取支付方式的值
-(NSArray *)getPayWayArray{
    //zhid 微信/支付宝。  skje //收款金额
    NSMutableArray * payWayArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0 ; i < AD_MANAGER.selectZHArray.count; i++) {
    }
    return payWayArr;
}
-(void)clickRightBackBtn:(UIButton *)btn{
    double allPrice = 0;
    NSArray * arr = [self.underTableView indexPathsForVisibleRows];
    [self.payArray removeAllObjects];
    for (NSIndexPath *indexPath in arr) {
        NSInteger skdnxh = 0;
        
        JDDingJinTableViewCell *cell = [self.underTableView cellForRowAtIndexPath:indexPath];
        allPrice = [cell.pagWayTf.text doubleValue] + allPrice;
        
            if (cell.pagWayTf.text.length != 0) {
                [self.payArray addObject:@{
                                          @"zhid":AD_MANAGER.selectZHArray[indexPath.row][@"zhid"],
                                          @"skje":cell.pagWayTf.text,
                                          @"zhmc":AD_MANAGER.selectZHArray[indexPath.row][@"zhmc"],
                                          @"dnxh":NSIntegerToNSString(skdnxh),
                                          @"zhbm":NSIntegerToNSString(skdnxh),
                                          }];
            skdnxh += 1;
        }
        
       
    }

    
    
    [AD_MANAGER.affrimDic setValue:doubleToNSString(allPrice) forKey:@"dingjin"];
    [AD_MANAGER.affrimDic setValue:self.payArray forKey:@"dingjinArray"];

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    //支付方式
    [AD_MANAGER requestSelectZH:mDic success:^(id object) {
        [weakself.underTableView reloadData];
    }];
    
}


#pragma mark ========== 创建tablevidew ==========
-(UITableView *)underTableView {
    if (!_underTableView) {
        _underTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        _underTableView.delegate = self;
        _underTableView.dataSource = self;
        _underTableView.backgroundColor = KWhiteColor;
        _underTableView.separatorStyle = 0;
        [_underTableView registerNib:[UINib nibWithNibName:@"JDDingJinTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDDingJinTableViewCell"];
        [self.view addSubview:_underTableView];
    }
    return _underTableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return AD_MANAGER.selectZHArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDDingJinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDDingJinTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = @{@"微信":@"icon_weixinzhifu",@"支付宝":@"icon_zhifubao",@"现金":@"icon_xianjin",@"银行卡":@"icon_wangyin",@"QQ":@"icon_qita"};
    cell.pagWayTf.tag = indexPath.row + 1;
    cell.pagWayTf.delegate = self;
    NSString * imgStr = AD_MANAGER.selectZHArray[indexPath.row][@"zhmc"];
    if ([imgStr isEqualToString:@"微信"] || [imgStr isEqualToString:@"支付宝"] ||  [imgStr isEqualToString:@"现金"] ||  [imgStr isEqualToString:@"银行卡"]) {
      
    }else{
        imgStr = @"QQ";
    }
    //图片
    cell.payWayImg.image =[UIImage imageNamed:dic[imgStr]];
    //名字
    cell.pagWayName.text = AD_MANAGER.selectZHArray[indexPath.row][@"zhmc"];
    
    
    
    NSArray * dingjinArr = AD_MANAGER.affrimDic[@"dingjinArray"];
    if (dingjinArr && dingjinArr.count > 0) {
        for (NSDictionary * dic in dingjinArr) {
            if ([dic[@"zhmc"] isEqualToString:cell.pagWayName.text]) {
                cell.pagWayTf.text = doubleToNSString([dic[@"skje"] doubleValue]);
            }
        }
    }
    return cell;
}
//自动跳转下一个textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    JDDingJinTableViewCell * cell1 = [self.underTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-1 inSection:0]];
    JDDingJinTableViewCell * cell2 = [self.underTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];

    if (cell1.pagWayTf == textField) {
        [cell1.pagWayTf resignFirstResponder];
        [cell2.pagWayTf becomeFirstResponder];
    }
    return YES;
}
@end
