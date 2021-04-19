//
//  JDJiaGongShouHuo4ViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDJiaGongShouHuo4ViewController.h"
#import "SelectedListView.h"
#import "WTTableAlertView.h"
#import "JDSetViewController.h"
#import "JDYangPinDanTableViewCell.h"
#import "JDSalesActionViewController.h"
#import "JDSelectOddTagViewController.h"
#import "JDSalesTagViewController.h"
#import "JDAddNewClientTableViewController.h"
#import "JDJiaGongFaHuo2ViewController.h"
#import "JDJiaGongFaHuo4ViewController.h"
#import "JDJiaGongZhuanChang4ViewController.h"
#import "JDJiaGongShouHuo5ViewController.h"

@interface JDJiaGongShouHuo4ViewController ()<UITableViewDelegate,UITableViewDataSource,JDCellPriceChangeDelegate,DissmissVCJiaGongFaHuoDelegate,spVCDissmissVCDelegate,JDYangPinDanChangeDelegate,UITextFieldDelegate>{
    NSInteger _autoCellHeight;//样品单的高度
    CGRect scrollRect;
    UIView * view;
}
@property (nonatomic,strong) UIView * JDSalesNavigationBar;
@property (nonatomic,assign)int n;
@property (nonatomic,strong)UIButton * button;


@end

@implementation JDJiaGongShouHuo4ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionItemCount = 0;
    _autoCellHeight = 130;
    //配置和初始化
    [self initUI];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    kWeakSelf(self);
    
    
    [self.clientBtn setTitle:AD_MANAGER.affrimDic[@"gysmc"]  forState:UIControlStateNormal];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    [AD_MANAGER requestSelectSpPage:mDic success:^(id str) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:AD_MANAGER.selectSpPageArray];
        [AD_MANAGER.selectSpPageArray removeAllObjects];
        AD_MANAGER.selectSpPageArray = [[NSMutableArray alloc]initWithArray:[array arrayByAddingObjectsFromArray:AD_MANAGER.debugNewGoodsArray]];
        [UIView performWithoutAnimation:^{
            [weakself.underTableView reloadData];
        }];
    }];
    
    
    
    
}
-(void)scrollToHeaderFrame{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (AD_MANAGER.sectionArray.count != 0) {
            CGRect frame =  [self.underTableView rectForHeaderInSection:AD_MANAGER.sectionArray.count-1];
            [self.underTableView setContentOffset:CGPointMake(frame.origin.x, frame.origin.y) animated:NO];
        }
    });
}
-(void)backBtnClicked{
    
    for (UIViewController * VC in [self.navigationController viewControllers]) {
        if ([VC isKindOfClass:[JDSelectOddTagViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }else if ([VC isKindOfClass:[JDJiaGongFaHuo4ViewController class]]){
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }else{
            
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)initUI{
    
    self.title = @"添加商品";
    
    //总计
    self.totalPrice.text = @"";
    self.jiagongPrice.delegate = self;
    //右标题
    [self addNavigationItemWithTitles:@[@"设置"] isLeft:NO target:self action:@selector(setSelectPushUI:) tags:nil];
    //进页面，弹出键盘
    [_underTableView registerNib:[UINib nibWithNibName:@"JDAddColorTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDAddColorTableViewCell"];
    [_underTableView registerNib:[UINib nibWithNibName:@"JDYangPinDanTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDYangPinDanTableViewCell"];
}

//设置按钮
-(void)setSelectPushUI:(UIButton *)btn{
    kWeakSelf(self);
    NSArray* array ;
    [self.view endEditing:YES];
    array = @[@"空差",@"客户款号",@"备注商品"];
    
    WTTableAlertView* alertview = [WTTableAlertView initWithTitle:@"请选择你需要设置的选项" options:array singleSelection:NO selectedItems:AD_MANAGER.markArray completionHandler:^(NSArray * _Nullable options) {
        [AD_MANAGER.markArray removeAllObjects];
        [AD_MANAGER.markArray addObjectsFromArray:options];
        //这个方法里返回一个索引数组，貌似是屏幕中显示所有cell 的索引
        NSArray *arr = [self.underTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in arr) {
            JDAddColorTableViewCell *cell = [self.underTableView cellForRowAtIndexPath:indexPath];
            JDYangPinDanTableViewCell *cell1 = [self.underTableView cellForRowAtIndexPath:indexPath];
            
            [weakself setYuDingDanShowHidden:cell1];
            
        }
        [weakself beginEndUpDataes];
        
    }];
    [alertview show];
}
//退货单
-(void)setTuiHuoDanShowHidden:(JDAddColorTableViewCell *)cell{
    BOOL kcViewBOOL = [AD_MANAGER.markArray containsObject:@(0)];
    BOOL bxViewBOOL= [AD_MANAGER.markArray containsObject:@(1)];
    
    
    if (kcViewBOOL && bxViewBOOL) {
        cell.kcView.hidden = NO;
        cell.bzView.hidden = NO;
        cell.khkhHeight.constant = 70;
        cell.changeAddCountLayout.constant = 100;
    }else if (kcViewBOOL && !bxViewBOOL){
        cell.kcView.hidden = NO;
        cell.bzView.hidden = YES;
        cell.changeAddCountLayout.constant = 70;
        
    }else if (!kcViewBOOL && bxViewBOOL){
        cell.bzView.hidden = NO;
        cell.kcView.hidden = YES;
        cell.khkhHeight.constant = 0;
        cell.changeAddCountLayout.constant = 30;
        
    }else if (!kcViewBOOL && !bxViewBOOL){
        cell.bzView.hidden = YES;
        cell.kcView.hidden = YES;
        cell.changeAddCountLayout.constant = 0;
        
    }
    
    if (cell.kcView.hidden) {
        cell.kcHeight.constant = 0;
    }else{
        cell.kcHeight.constant = 70;
    }
    
    if (cell.bzView.hidden) {
        cell.bzHeight.constant = 0;
    }else{
        cell.bzHeight.constant = 30;
    }
}
//样品单
-(void)setYangPinDanShowHidden:(JDYangPinDanTableViewCell *)cell{
    //如果数组为0，就隐藏设置view
    if (AD_MANAGER.markArray.count == 0) {
        cell.bottomView.hidden = YES;
        _autoCellHeight = 130;
    }else{
        cell.bottomView.hidden = NO;
        _autoCellHeight = 130 + 140;
    }
    cell.beizhuConstraint.constant = 80;
    
    //客户款号
    if ([AD_MANAGER.markArray containsObject:@(0)]){
        cell.view1.hidden = NO;
        if (![AD_MANAGER.markArray containsObject:@(1)]) {
            _autoCellHeight = 130 + 140 - 50;
            cell.beizhuConstraint.constant = 80;
            cell.bottomConstraint.constant = 140 - 80;
        }
    }else{
        cell.view1.hidden = YES;
    }
    //备注
    if ([AD_MANAGER.markArray containsObject:@(1)]){
        cell.view3.hidden = NO;
        if (![AD_MANAGER.markArray containsObject:@(0)]) {
            _autoCellHeight = 130 + 140 - 70;
            cell.beizhuConstraint.constant = 10;
            cell.bottomConstraint.constant = 140 - 90;
        }
    }else{
        cell.view3.hidden = YES;
        
        if (![AD_MANAGER.markArray containsObject:@(0)]) {
            _autoCellHeight = 130 ;
        }
    }
}
//预定单显示和隐藏的view
-(void)setYuDingDanShowHidden:(JDYangPinDanTableViewCell *)cell{
    //如果数组为0，就隐藏设置view
    if (AD_MANAGER.markArray.count == 0) {
        cell.bottomView.hidden = YES;
        _autoCellHeight = 130;
    }else{
        cell.bottomView.hidden = NO;
        _autoCellHeight = 130 + 140;
    }
    //客户款号
    if ([AD_MANAGER.markArray containsObject:@(1)]){
        cell.view1.hidden = NO;
        cell.kongchaConstraint.constant = 160;
    }else{
        cell.view1.hidden = YES;
        cell.kongchaConstraint.constant = 0;
    }
    //空差
    if ([AD_MANAGER.markArray containsObject:@(0)]) {
        cell.view2.hidden = NO;
    }else{
        cell.view2.hidden = YES;
    }
    cell.beizhuConstraint.constant = 80;
    //备注
    if ([AD_MANAGER.markArray containsObject:@(2)]){
        cell.view3.hidden = NO;
        if (![AD_MANAGER.markArray containsObject:@(0)] && ![AD_MANAGER.markArray containsObject:@(1)]) {
            _autoCellHeight = 130 + 140 - 70;
            cell.beizhuConstraint.constant = 10;
            cell.bottomConstraint.constant = 140 - 90;
        }
    }else{
        cell.view3.hidden = YES;
        if ([AD_MANAGER.markArray containsObject:@(0)] || [AD_MANAGER.markArray containsObject:@(1)]) {
            _autoCellHeight = 130 + 140 - 50;
            cell.beizhuConstraint.constant = 80;
            cell.bottomConstraint.constant = 140 - 80;
        }else{
            _autoCellHeight = 130;
            
        }
    }
    
    
    
}
-(void)threeViewHeight:(JDAddColorTableViewCell *)cell{
    if (cell.khkhView.hidden) {
        cell.khkhHeight.constant = 0;
        cell.khkhWidth.constant = 0;
    }else{
        cell.khkhHeight.constant = 70;
        cell.khkhWidth.constant = 150;
        
    }
    
    if (cell.kcView.hidden) {
        cell.kcHeight.constant = 0;
    }else{
        cell.kcHeight.constant = 70;
    }
    
    if (cell.bzView.hidden) {
        cell.bzHeight.constant = 0;
    }else{
        cell.bzHeight.constant = 30;
    }
}
//销售单显示和隐藏的view
-(void)setShowHiddenInCell:(JDAddColorTableViewCell *)cell{
    
    BOOL khkhViewBOOL = [AD_MANAGER.markArray containsObject:@(1)];
    BOOL kcViewBOOL   = [AD_MANAGER.markArray containsObject:@(0)];
    BOOL bxViewBOOL   = [AD_MANAGER.markArray containsObject:@(2)];
    //YES为显示。NO为隐藏
    if (khkhViewBOOL && kcViewBOOL && bxViewBOOL) {//全部显示
        cell.khkhView.hidden = cell.kcView.hidden = cell.bzView.hidden = NO;
        cell.changeAddCountLayout.constant = 100;
    }else if (!khkhViewBOOL && !kcViewBOOL && !bxViewBOOL){//全部隐藏
        cell.khkhView.hidden = cell.kcView.hidden = cell.bzView.hidden = YES;
        cell.changeAddCountLayout.constant = 0;
    }else if (khkhViewBOOL && !kcViewBOOL && !bxViewBOOL){//款号显示，空差和备注不显示
        cell.khkhView.hidden = NO; cell.kcView.hidden = cell.bzView.hidden = YES;
        cell.changeAddCountLayout.constant  = 70;
    }else if (khkhViewBOOL && kcViewBOOL && !bxViewBOOL){//款号空差显示，备注不显示
        cell.khkhView.hidden = cell.kcView.hidden = NO;  cell.bzView.hidden = YES;
        cell.changeAddCountLayout.constant = 70;
    }else if (!khkhViewBOOL && kcViewBOOL && !bxViewBOOL){//款号备注不显示，空差显示
        cell.khkhView.hidden = cell.bzView.hidden = YES;  cell.kcView.hidden = NO;
        cell.changeAddCountLayout.constant = 70 ;
    }else if (!khkhViewBOOL && !kcViewBOOL && bxViewBOOL){//款号备注不显示，空差显示
        cell.khkhView.hidden = cell.kcView.hidden = YES;  cell.bzView.hidden = NO;
        cell.changeAddCountLayout.constant = 30 ;
    }else if (khkhViewBOOL && !kcViewBOOL && bxViewBOOL){//款号备注不显示，空差显示
        cell.khkhView.hidden = cell.bzView.hidden = NO;  cell.kcView.hidden = YES;
        cell.changeAddCountLayout.constant = 100 ;
    }
    [self threeViewHeight:cell];
}

#pragma mark ========== 样品单tf变哈 ==========
-(void)priceYpChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getYangPinSectionRowColorModel:tf];
    colorModel.savePrice = tf.text;
}
-(void)piShuChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getYangPinSectionRowColorModel:tf];
    colorModel.savePishu = tf.text;
}
-(void)ChangDuChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getYangPinSectionRowColorModel:tf];
    colorModel.saveCount = tf.text;
}
-(void)khkhChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getYangPinSectionRowColorModel:tf];
    colorModel.saveKhkh = tf.text;
}
- (void)kongchaChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getYangPinSectionRowColorModel:tf];
    colorModel.savekongcha = tf.text;
}
- (void)beizhuChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getYangPinSectionRowColorModel:tf];
    colorModel.saveBz = tf.text;
}
-(void)danweiChangeAction:(UILabel *)lbl{
    JDAddColorModel * colorModel = [self getYangPinSectionRowColorModel:lbl];
    colorModel.saveDanWei = lbl.text;
}
-(void)zhuFuDanWeiTag:(NSInteger)tag label:(UILabel *)label{
    JDAddColorModel * colorModel = [self getYangPinSectionRowColorModel:label];
    colorModel.saveZhuFuTag = tag;
}


-(JDAddColorModel *)getYangPinSectionRowColorModel:(UIView *)tf{
    // 获取'textfield'所在的cell
    JDYangPinDanTableViewCell * cell;
    
    if ([[[[[tf superview] superview] superview] superview] class] == [JDYangPinDanTableViewCell class]) {
        cell = (JDYangPinDanTableViewCell *)[[[[tf superview] superview] superview] superview];
    }else{
        cell = (JDYangPinDanTableViewCell *)[[[[[tf superview] superview] superview] superview] superview];
    }
    
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.underTableView indexPathForCell:cell];
    NSString * key = [AD_MANAGER.sectionArray[indexPath.section] allKeys][0];
    NSArray * countArr = AD_MANAGER.sectionArray[indexPath.section][key];
    JDAddColorModel * colorModel = countArr[indexPath.row];
    return colorModel;
}
#pragma mark ========== 销售单tf变哈 ==========
-(void)priceChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getSectionRowColorModel:tf];
    colorModel.savePrice = tf.text;
}
//主单位
-(void)countChangeAction:(NSString *)sumCount tf:(UITextField *)countTf{
    JDAddColorModel * colorModel = [self getSectionRowColorModel:countTf];
    [colorModel.psArray addObject:@{@"xssl":doubleToNSString([countTf.text doubleValue])}];
    
    [self beginEndUpDataes];
}
//副单位
-(void)fcountChangeAction:(NSString *)sumCount count:(UITextField *)countTf fcount:(UITextField *)fcountTf{
    JDAddColorModel * colorModel = [self getSectionRowColorModel:countTf];
    [colorModel.psArray addObject:@{@"xssl":doubleToNSString([countTf.text doubleValue]),@"xsfsl":doubleToNSString([fcountTf.text doubleValue])}];
    [self beginEndUpDataes];
}
-(void)zhuFuDanWeiTagAction:(NSInteger)tag label:(UILabel *)label{
    JDAddColorModel * colorModel = [self getSectionRowColorModel:label];
    colorModel.saveZhuFuTag = tag;
}

-(void)countMinusAction:(NSString *)sumCount tf:(UITextField *)countTf count:(NSInteger)index{
    JDAddColorModel * colorModel = [self getSectionRowColorModel:countTf];
    [colorModel.psArray removeObjectAtIndex:index];
    
    [self beginEndUpDataes];
}
-(void)beginEndUpDataes{
    kWeakSelf(self);
    [UIView performWithoutAnimation:^{
        [weakself.underTableView beginUpdates];
        [weakself.underTableView endUpdates];
    }];
}
-(void)saveKhkhChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getSectionRowColorModel:tf];
    colorModel.saveKhkh = tf.text;
}
-(void)xcbeizhuChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getSectionRowColorModel:tf];
    colorModel.saveBz = tf.text;
}
- (void)savekongchaChangeAction:(UITextField *)tf{
    JDAddColorModel * colorModel = [self getSectionRowColorModel:tf];
    colorModel.savekongcha = tf.text;
}



#pragma mark ========== 商品界面的代理方法 ==========
- (void)spVCdissmissValue{
    kWeakSelf(self);
    [UIView performWithoutAnimation:^{
        [weakself.underTableView reloadData];
    }];
}
-(JDAddColorModel *)getSectionRowColorModel:(UIView *)tf{
    // 获取'textfield'所在的cell
    JDAddColorTableViewCell * cell;
    if ([[[[[tf superview] superview] superview] superview] class] == [JDAddColorTableViewCell class]) {
        cell = (JDAddColorTableViewCell *)[[[[tf superview] superview] superview] superview];
    }else{
        cell = (JDAddColorTableViewCell *)[[[[[tf superview] superview] superview] superview] superview];
    }
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.underTableView indexPathForCell:cell];
    NSString * key = [AD_MANAGER.sectionArray[indexPath.section] allKeys][0];
    NSArray * countArr = AD_MANAGER.sectionArray[indexPath.section][key];
    JDAddColorModel * colorModel = countArr[indexPath.row];
    return colorModel;
}
#pragma mark ========== 下一步按钮 ==========
- (IBAction)selectOKAction:(id)sender {
    if (AD_MANAGER.sectionArray.count != 2) {
        [self showToast:@"请选择成品货号或者坯布货号"];
        return;
    }
    
    
    
    BOOL have = NO;
    for (NSInteger i = 0 ; i < AD_MANAGER.sectionArray.count; i++) {
        NSString * key = [AD_MANAGER.sectionArray[i] allKeys][0];
        NSArray * countArr = AD_MANAGER.sectionArray[i][key];
        if (countArr.count > 0) {
            have = YES;
        }
    }
    if (!have) {
        [self showToast:@"请选择商品颜色"];
        return;
    }
    
    

    
    //检查页面参数
    for (NSDictionary * dic in AD_MANAGER.sectionArray) {
        if (dic[[dic allKeys][0]]) {
            for (JDAddColorModel * colorModel in dic[[dic allKeys][0]]) {
                NSString *title = nil;
                for (JDSelectSpModel * spModle in AD_MANAGER.selectSpPageArray) {
                    if (spModle.spid == colorModel.spid) {
                        title = spModle.spmc;
                    }
                }
                
                if ([colorModel.savePishu doubleValue] == 0){
                    [self showToast:[NSString stringWithFormat:@"请输入【%@】的匹数",title]];
                    return;
                }else if ([colorModel.saveCount doubleValue] == 0){
                    [self showToast:[NSString stringWithFormat:@"请输入【%@】的长度",title]];
                    return;
                }
            }
        }
    }
    
    
    if ([self.jiagongStyleBtn.titleLabel.text isEqualToString:@"点击选择加工方式"]) {
        [self showToast:@"请选择加工方式"];
        return;
    }
    if ([self.jiagongPrice.text isEqualToString:@""] || self.jiagongPrice.text.length == 0) {
        [self showToast:@"请填写加工单价"];
        return;
    }
    
    NSMutableArray * array1 = [NSMutableArray arrayWithArray:AD_MANAGER.sectionArray];
    //这里判断，删除有组名，没有内容的
    for (NSInteger i =0 ; i<array1.count; i++) {
        NSDictionary * dic = array1[i];
        if ([dic[[dic allKeys][0]] count] == 0) {
            [AD_MANAGER.sectionArray removeObject:dic];
        }
    }
    [AD_MANAGER.affrimDic setValue:self.totalPrice.text forKey:@"allPrice"];
    
        UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"JiaGongShouHuo" bundle:nil];
        JDJiaGongShouHuo5ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDJiaGongShouHuo5ViewController"];
        [AD_MANAGER.affrimDic setValue:@([self.jiagongPrice.text doubleValue]) forKey:@"jgfdj"];

        [self.navigationController pushViewController:VC animated:YES];

    
    
    
    
    
    
    
    
    
    
}
#pragma mark ========== 添加颜色界面的代理方法 ==========
-(void)dissmissValue:(JDAddColorModel *)model{
    
    NSMutableArray * copyArr = [[NSMutableArray alloc]initWithArray:AD_MANAGER.sectionArray];
    //找出商品id对应的数组下标
    NSInteger spidIndex = 0;
    NSInteger row = 0;
    for (NSInteger i = 0; i < copyArr.count; i++) {
        if (model.spid == [[copyArr[i] allKeys][0] intValue]) {
            spidIndex = i;
        }
    }
    NSMutableArray * oldArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.sectionArray[spidIndex][NSIntegerToNSString(model.spid)]];
    BOOL colorBool = NO;
    //判断颜色是否存在，存在的话就不用加了
    for (JDAddColorModel * colorModel in oldArray) {
        if ([colorModel.ys isEqualToString:model.ys]) {
            colorBool = YES;
        }
    }
    if (colorBool) {
        
    }else{
        row = [AD_MANAGER.sectionArray[spidIndex][NSIntegerToNSString(model.spid)] count];
        if (row == 1) {
            [AD_MANAGER.sectionArray[spidIndex][NSIntegerToNSString(model.spid)] replaceObjectAtIndex:0 withObject:model];
        }else if (row == 2){
                   [AD_MANAGER.sectionArray[spidIndex][NSIntegerToNSString(model.spid)] replaceObjectAtIndex:1 withObject:model];
        }else{
            [AD_MANAGER.sectionArray[spidIndex][NSIntegerToNSString(model.spid)] addObject:model];

        }
     
        
    }
    
    kWeakSelf(self);
    [UIView performWithoutAnimation:^{
        [weakself.underTableView reloadData];
    }];


    
}
#pragma mark ========== 添加颜色的present方法 ==========
-(void)addColorBtnclicked:(UIButton *)btn{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"JiaGongFaHuo" bundle:nil];
    JDJiaGongFaHuoColor3ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDJiaGongFaHuoColor3ViewController"];
    
    VC.delegate = self;
    for (JDSelectSpModel * spModle in AD_MANAGER.selectSpPageArray) {
        if ([[AD_MANAGER.sectionArray[btn.tag-100] allKeys][0] intValue] == spModle.spid) {
            VC.spid = NSIntegerToNSString(spModle.spid);
            VC.spModel = spModle;
    
        }
    }
    [self presentViewController:VC animated:YES completion:^{
  
    }];
}

#pragma mark ========== tableview代理方法 ==========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AD_MANAGER.sectionArray.count;//商品组的数组
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString * key = [AD_MANAGER.sectionArray[section] allKeys][0];
    NSArray * countArr = AD_MANAGER.sectionArray[section][key];
    return [countArr count];//商品颜色的数组
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _autoCellHeight;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"JDYangPinDanTableViewCell";
    JDYangPinDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    cell.yangpinDelegate = self;
    cell.tf1.backgroundColor = JDRGBAColor(235, 235, 235);
    cell.tf1.text = @"";
    cell.btn1.hidden = YES;
    //        [cell.tf1 becomeFirstResponder];
    NSString * key = [AD_MANAGER.sectionArray[indexPath.section] allKeys][0];
    NSArray * countArr = AD_MANAGER.sectionArray[indexPath.section][key];
    JDAddColorModel * colorModel = countArr[indexPath.row];
    for (JDSelectSpModel * spModel in AD_MANAGER.selectSpPageArray) {
        if (spModel.spid == colorModel.spid) {
            self.spModel = spModel;
        }
    }
    kWeakSelf(self);
    
    [cell setCellValueData:self.spModel color:countArr[indexPath.row]];
    [self setYuDingDanShowHidden:cell];
    
    cell.editFinfishBlock = ^{
        [weakself jisuanJiaGongFei];
    };
    return cell;
    
}
-(void)jisuanJiaGongFei{
    //键盘消失的时候，开始计算总计价格
    double price = 0;

    if (AD_MANAGER.sectionArray.count > 0) {
        NSString * key = [AD_MANAGER.sectionArray[0] allKeys][0];
        NSArray * countArr = AD_MANAGER.sectionArray[0][key];
        for (JDAddColorModel * colorModel in countArr) {
            price = [self.jiagongPrice.text doubleValue] * [colorModel.saveCount doubleValue];
        }
    }
    self.totalPrice.text = [[NSString stringWithFormat:@"%.2f",price] concate:@"¥"];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self jisuanJiaGongFei];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.jiagongPrice resignFirstResponder];
    return YES;
}
#pragma mark ==========  头视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    NSInteger spid = [[AD_MANAGER.sectionArray[section] allKeys][0] integerValue];
    
    if (section == 0) {
        title = [@"成品: " append:[AD_SHARE_MANAGER inShangPinIdOutName:spid]];
    }else if (section == 1) {
        title = [@"坯布: " append:[AD_SHARE_MANAGER inShangPinIdOutName:spid]];
    }

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 40)];
    view.backgroundColor = KWhiteColor;
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, KScreenWidth, 40)];
    HeaderLabel.font = [UIFont boldSystemFontOfSize:16];
    HeaderLabel.textColor = JDRGBAColor(25, 25, 25);
    HeaderLabel.text = title;
    [view addSubview:HeaderLabel];
    
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = JDRGBAColor(235, 235, 235);
    imageView.frame = CGRectMake(0, 39, KScreenWidth,0.5);
    [view addSubview:imageView];
    return view;
}
//头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
#pragma mark ========== 尾视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 90)];
    //    view.backgroundColor = KClearColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 113, 30);
    btn.center = view.center;
    [btn setTitle:@"+ 添加颜色" forState:UIControlStateNormal];
    [btn setTitleColor:JDRGBAColor(0, 163, 255) forState:UIControlStateNormal];
    ViewBorderRadius(btn, 5, 0.5, JDRGBAColor(0, 163, 255));
    btn.font = [UIFont systemFontOfSize:13];
    btn.tag = section+100;
    [btn addTarget:self action:@selector(addColorBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == AD_MANAGER.sectionArray.count-1) {
        return 180;
    }else{
        return  90;
    }
}
#pragma mark ========== 创建tablevidew ==========
-(UITableView *)underTableView {
    if (!_underTableView) {
        _underTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.underView.frame.size.height) style:1];
        _underTableView.delegate = self;
        _underTableView.dataSource = self;
        //        _underTableView.backgroundColor = JDRGBAColor(247, 249, 251);
        _underTableView.backgroundColor = KClearColor;
        [_underTableView registerNib:[UINib nibWithNibName:@"JDAddColorTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDAddColorTableViewCell"];
        [_underTableView registerNib:[UINib nibWithNibName:@"JDYangPinDanTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDYangPinDanTableViewCell"];
        _underTableView.separatorStyle = 0;
        [self.underView addSubview:_underTableView];
    }
    return _underTableView;
}
- (void)closeKeyboard:(UITapGestureRecognizer *)recognizer{
    [super closeKeyboard:recognizer];
    
}

-(void)againVerificationYangPinDanValue{
    //遍历所有tf
    //这个方法里返回一个索引数组，貌似是屏幕中显示所有cell 的索引
    NSArray *arr = [self.underTableView indexPathsForVisibleRows];
    
    for (NSIndexPath *indexPath in arr) {
        //根据索引，获取cell 然后就可以做你想做的事情啦
        JDYangPinDanTableViewCell * cell = [self.underTableView cellForRowAtIndexPath:indexPath];
        // 获取cell的indexPath
        NSIndexPath *indexPath = [self.underTableView indexPathForCell:cell];
        NSString * key = [AD_MANAGER.sectionArray[indexPath.section] allKeys][0];
        NSArray * countArr = AD_MANAGER.sectionArray[indexPath.section][key];
        JDAddColorModel * colorModel = countArr[indexPath.row];
        colorModel.savePrice = cell.tf1.text;
        colorModel.savePishu = cell.tf2.text;
        colorModel.saveCount = cell.tf3.text;
        colorModel.saveKhkh = cell.tf4.text;
        colorModel.savekongcha = cell.tf5.text;
        colorModel.saveBz = cell.view3.text;
    }
}




-(void)setCountLblValue{
    self.countLBl.text = NSIntegerToNSString(AD_MANAGER.sectionArray.count);
    ViewBorderRadius(self.countLBl, 5, 1, [UIColor redColor]);
}

//加工方式弹框
- (IBAction)jiagongStleAction:(id)sender {
    kWeakSelf(self);
    NSMutableDictionary* mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pagesize":@(500),@"pageno":@(1),@"keywords":@""}];
    [AD_MANAGER requestJiaGongFangShi:mDic success:^(id object) {
        
        if ([object[@"data"][@"totalCount"] integerValue] == 0) {
            [weakself showToast:@"没有可选的加工方式"];
        }else{
            SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
            view.isSingle = YES;
            NSMutableArray * mArray = [[NSMutableArray alloc]init];
            for (NSInteger i = 0 ; i <  [object[@"data"][@"list"] count]; i++) {
                [mArray addObject:[[SelectedListModel alloc] initWithSid:[object[@"data"][@"list"][i][@"jgfsid"] integerValue] Title:object[@"data"][@"list"][i][@"jgfsmc"]]];
            }
            view.array = [NSArray arrayWithArray:mArray];
            view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                [LEEAlert closeWithCompletionBlock:^{
                    SelectedListModel * model = array[0];
                    [weakself.jiagongStyleBtn setTitle:model.title forState:0];
                    [AD_MANAGER.affrimDic setValue:@(model.sid) forKey:@"jgfsid"];
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
        
    }];
}
@end
