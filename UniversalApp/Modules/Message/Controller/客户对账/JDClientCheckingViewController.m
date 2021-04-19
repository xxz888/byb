//
//  JDClientCheckingViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDClientCheckingViewController.h"
#import "JDClientCheckingHeaderView.h"
#import "JDClientCheckingTableViewCell.h"
#import "JDClientCheckingDetailViewController.h"
#import "JDClientSouSuoDuiZhangViewController.h"

@interface JDClientCheckingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * bottomTableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSMutableArray * headerDataSource;

@property(nonatomic,strong)NSDictionary * dateTimeDic;
@property(nonatomic,strong)NSDictionary * headerDic;

@property(nonatomic,strong)JDClientCheckingHeaderView * checkingView;
@property(nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation JDClientCheckingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc]init];
    _headerDataSource = [[NSMutableArray alloc]init];
    
    [self configDateField];
    [self initDataPicker];
    [self closeInput];
    self.title = self.whereCome ? @"供应商对账" : @"客户对账";
    

    [self addNavigationItemWithTitles:@[@"查询"] isLeft:NO target:self action:@selector(searchKhmc) tags:nil];
}

-(void)configDateField
{
    self.beginField.delegate = self;
    self.endField.delegate = self;
    self.beginField.tag = 100;
    self.endField.tag = 101;
}
// return;
-(void)searchKhmc{
 
    JDClientSouSuoDuiZhangViewController * vc = [[JDClientSouSuoDuiZhangViewController alloc]init];
    vc.whereCome = self.whereCome;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:_dateTimeDic];
    if (self.whereCome) {
        [AD_MANAGER requestQueryyfzktj_list:mDic success:^(id object) {
            [weakself.dataSource  removeAllObjects];
            [weakself.dataSource addObjectsFromArray:object[@"data"][@"list"]];
            weakself.headerDic  = [NSDictionary dictionaryWithDictionary:object[@"data"][@"total"]];
            [weakself.bottomTableView reloadData];
        }];
    }else{
        // 客户对账逻辑
        [AD_MANAGER requestQueryyszktj_list:mDic success:^(id object) {
            [weakself.dataSource  removeAllObjects];
            [weakself.dataSource addObjectsFromArray:object[@"data"][@"list"]];
            weakself.headerDic  = [NSDictionary dictionaryWithDictionary:object[@"data"][@"total"]];
            [weakself.bottomTableView reloadData];
        }];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;

}
#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:self.bottomView.bounds style:UITableViewStyleGrouped];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        _bottomTableView.separatorStyle = 0;
        _bottomTableView.backgroundColor = KClearColor;
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDClientCheckingTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDClientCheckingTableViewCell"];
        [self.bottomView addSubview:_bottomTableView];
    }
    return _bottomTableView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"JDClientCheckingHeaderView" owner:self options:nil];
    self.checkingView = [nib objectAtIndex:0];
    self.checkingView.frame =CGRectMake(0, 0, KScreenWidth, 70);
    if (self.whereCome) {
        self.checkingView.lbl1.text = CCHANGE(self.headerDic[@"zjyf"]);
        self.checkingView.lbl2.text = CCHANGE(self.headerDic[@"jsyf"]);
        self.checkingView.lbl3.text = CCHANGE(self.headerDic[@"qmyf"]);
        self.checkingView.lbl1Tag.text = @"新增应付账款";
        self.checkingView.lbl2Tag.text = @"付款";
        self.checkingView.lbl3Tag.text = @"总应付款";

        
    }else{
        self.checkingView.lbl1.text = CCHANGE(self.headerDic[@"zjys"]);
        self.checkingView.lbl2.text = CCHANGE(self.headerDic[@"jsys"]);
        self.checkingView.lbl3.text = CCHANGE(self.headerDic[@"qmys"]);
        self.checkingView.lbl1Tag.text = @"新增应收账款";
        self.checkingView.lbl2Tag.text = @"收款";
        self.checkingView.lbl3Tag.text = @"总应收款";
    }

    [headerView addSubview:self.checkingView];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDClientCheckingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDClientCheckingTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = _dataSource[indexPath.row];
    cell.weixinBtn.hidden = YES;
    if (self.whereCome) {
        cell.clientLBl.text = dic[@"gysmc"];
 
        cell.qimoyingshouTag.text = @"期末应付:";
        cell.shoukuanTag.text = @"应付:";
        cell.weixinBtn.hidden = YES;
    }else{
        cell.clientLBl.text = dic[@"khmc"];
        cell.qimoyingshouTag.text = @"期末应收:";
        cell.shoukuanTag.text = @"应收:";

        
    }
    cell.lbl1.text = CCHANGE(dic[@"qcys"]);
    cell.lbl2.text = CCHANGE(dic[@"jsys"]);
    cell.lbl3.text = CCHANGE(dic[@"qmys"]);
    cell.lbl4.text = CCHANGE(dic[@"zjys"]);
    cell.lbl5.text = CCHANGE(dic[@"zkje"]);
    cell.lbl6.text = dic[@"lastrzrq"];
    cell.lbl7.text = NSIntegerToNSString([dic[@"wfsywts"] integerValue]);
    cell.rightLbl.text = dic[@"khtag"];
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = _dataSource[indexPath.row];
    JDClientCheckingDetailViewController * VC = [[JDClientCheckingDetailViewController alloc]init];
    VC.paramtersDic = [NSMutableDictionary dictionaryWithDictionary:_dateTimeDic];
    if (self.whereCome) {
//        if (!Quan_Xian(@"应付账款明细账")) {
//            [UIView showToast:QUANXIAN_ALERT_STRING(@"应付账款明细账")];
//            return;
//        }
        [VC.paramtersDic setValue:dic[@"gysid"] forKey:@"gysid"];
        VC.clientLbl = dic[@"gysmc"];
    }else{
//        if (!Quan_Xian(@"应收账款明细账")) {
//            [UIView showToast:QUANXIAN_ALERT_STRING(@"应收账款明细账")];
//            return;
//        }
        
        // 弹出客户对账详情，这里看下为啥有时候为空
        [VC.paramtersDic setValue:dic[@"khid"] forKey:@"khid"];
        VC.clientLbl = dic[@"khmc"];

    }
    VC.whereCome = self.whereCome;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 个button的公用方法 今日 昨日 近7天 近30天 ==========

- (UIView *)inputToolView
{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    container.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    [close setTitle:@"关闭" forState:UIControlStateNormal];
    NSInteger buttonWidth = 70;
    close.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - buttonWidth, 0, buttonWidth, 44);
    [container addSubview:close];
    [close addTarget:self action:@selector(closeInput) forControlEvents:UIControlEventTouchUpInside];
    return container;
}

-(void)closeInput
{
    [self.view endEditing:YES];
    _dateTimeDic = @{@"begindate":self.beginField.text,
                     @"enddate":self.endField.text};
    [self requestData];
}

-(void)initDataPicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    //设置地区: zh-中国
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    // 设置当前显示时间
    [datePicker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [datePicker setMaximumDate:[NSDate date]];
    
    //设置时间格式
    datePicker.datePickerMode = UIDatePickerModeDate;
    //监听DataPicker的滚动
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    self.datePicker = datePicker;
    //设置时间输入框的键盘框样式为时间选择器
    self.beginField.inputView = self.endField.inputView = datePicker;
    self.beginField.inputAccessoryView = self.endField.inputAccessoryView = [self inputToolView];
    
    self.beginField.text = [NSString getThisYearFirstDay];
    self.endField.text = [NSString getCurrentDate];
}

+ (NSDateFormatter *) dataFormatter
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    return formatter;
}

static __weak UITextField *_currentTextField = nil;
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.datePicker setDate:[[JDClientCheckingViewController dataFormatter] dateFromString:textField.text]];
    _currentTextField = textField;
}

//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return NO;
}

- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [JDClientCheckingViewController dataFormatter];
    
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    
    _currentTextField.text = dateStr;
}

@end
