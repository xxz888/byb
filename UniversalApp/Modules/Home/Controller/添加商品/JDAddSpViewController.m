//
//  JDAddSpViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddSpViewController.h"
#import "SelectedListView.h"
#import "WTTableAlertView.h"
#import "JDSetViewController.h"
#import "JDYangPinDanTableViewCell.h"
#import "JDSalesActionViewController.h"
#import "JDSelectOddTagViewController.h"
#import "JDSalesTagViewController.h"
#import "JDAddNewClientTableViewController.h"
@interface JDAddSpViewController ()<UITableViewDelegate,UITableViewDataSource,JDCellPriceChangeDelegate,DissmissVCDelegate,spVCDissmissVCDelegate,JDYangPinDanChangeDelegate>{
    NSInteger _autoCellHeight;//样品单的高度
    CGRect scrollRect;
}
@property (nonatomic,strong) UIView * JDSalesNavigationBar;
@property (nonatomic,assign)int n;
@property (nonatomic,strong)UIButton * button;


@end

@implementation JDAddSpViewController

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

   
    [self.clientBtn setTitle:CaiGouBOOL ?AD_MANAGER.affrimDic[@"gysmc"]  :  AD_MANAGER.affrimDic[@"khmc"] forState:UIControlStateNormal];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    [AD_MANAGER requestSelectSpPage:mDic success:^(id str) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:AD_MANAGER.selectSpPageArray];
        [AD_MANAGER.selectSpPageArray removeAllObjects];
        AD_MANAGER.selectSpPageArray = [[NSMutableArray alloc]initWithArray:[array arrayByAddingObjectsFromArray:AD_MANAGER.debugNewGoodsArray]];
     
        
        
        
        [weakself jisuanAllPrice];
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
        }else if ([VC isKindOfClass:[JDSalesAffirmViewController class]]){
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
    if (ORDER_ISEQUAl(XiaoShouDan) || ORDER_ISEQUAl(YuDingDan) || CaiGouBOOL) {//销售单
       array = @[@"空差",@"客户款号",@"备注商品"];
    }else if(ORDER_ISEQUAl(YangPinDan)){
        array = @[@"客户款号",@"备注商品"];
    }else{
         array = @[@"空差",@"备注商品"];
    }
    
    WTTableAlertView* alertview = [WTTableAlertView initWithTitle:@"请选择你需要设置的选项" options:array singleSelection:NO selectedItems:AD_MANAGER.markArray completionHandler:^(NSArray * _Nullable options) {
        [AD_MANAGER.markArray removeAllObjects];
        [AD_MANAGER.markArray addObjectsFromArray:options];
        //这个方法里返回一个索引数组，貌似是屏幕中显示所有cell 的索引
        NSArray *arr = [self.underTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in arr) {
            JDAddColorTableViewCell *cell = [self.underTableView cellForRowAtIndexPath:indexPath];
            JDYangPinDanTableViewCell *cell1 = [self.underTableView cellForRowAtIndexPath:indexPath];

            if (ORDER_ISEQUAl(XiaoShouDan) || ORDER_ISEQUAl(CaiGouRuKuDan)) {
                [weakself setShowHiddenInCell:cell];
            }else  if (ORDER_ISEQUAl(YuDingDan)){//预定单
                [weakself setYuDingDanShowHidden:cell1];
            }else if (ORDER_ISEQUAl(TuiHuoDan) || ORDER_ISEQUAl(CaiGouTuiHuoDan)){
                [weakself setTuiHuoDanShowHidden:cell];
            }else{
                [weakself setYangPinDanShowHidden:cell1];
            }
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
    [self jisuanAllPrice];
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
    [self jisuanAllPrice];
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
    [self jisuanAllPrice];
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
    if (AD_MANAGER.sectionArray.count == 0) {
        [self showToast:@"请选择一个商品"];
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
    
    
    
    
    
    
    if (ORDER_ISEQUAl(YuDingDan)) {
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
        
    }else if (ORDER_ISEQUAl(XiaoShouDan) || ORDER_ISEQUAl(TuiHuoDan) || CaiGouBOOL){
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
                    
               if (colorModel.psArray.count == 0){
                        [self showToast:[NSString stringWithFormat:@"请输入【%@】的明细",title]];
                        return;
                    }
                }
            }
        }
    }else if (ORDER_ISEQUAl(YangPinDan)){
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
                    
                if ([colorModel.saveCount doubleValue] == 0){
                        [self showToast:[NSString stringWithFormat:@"请输入【%@】的长度",title]];
                        return;
                    }
                }
            }
        }
        
    }
   

    
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDSalesAffirmViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesAffirmViewController"];
    
    NSMutableArray * array1 = [NSMutableArray arrayWithArray:AD_MANAGER.sectionArray];
    //这里判断，删除有组名，没有内容的
    for (NSInteger i =0 ; i<array1.count; i++) {
        NSDictionary * dic = array1[i];
        if ([dic[[dic allKeys][0]] count] == 0) {
            [AD_MANAGER.sectionArray removeObject:dic];
        }
    }
    


    [AD_MANAGER.affrimDic setValue:self.totalPrice.text forKey:@"allPrice"];
                
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
        [AD_MANAGER.sectionArray[spidIndex][NSIntegerToNSString(model.spid)] addObject:model];
        
    }
    [self jisuanAllPrice];
    
    kWeakSelf(self);
    [UIView performWithoutAnimation:^{
        [weakself.underTableView reloadData];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.underTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:spidIndex] animated:NO scrollPosition:UITableViewScrollPositionBottom];

    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //显示键盘
        if (AD_MANAGER.sectionArray.count != 0) {
            if (ORDER_ISEQUAl(YuDingDan) || ORDER_ISEQUAl(YangPinDan)) {
                JDYangPinDanTableViewCell * cell2 = [self.underTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:spidIndex]];
                [cell2.tf1 becomeFirstResponder];
            }else{
                JDAddColorTableViewCell * cell1 = [self.underTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:spidIndex]];
                [cell1.sigPriceTf becomeFirstResponder];
            }
        }
    });
    
    


}
#pragma mark ========== 添加新商品present方法 ==========
- (IBAction)newAddSpBtnAction:(id)sender {
    

    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDSelectOddTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSelectOddTagViewController"];
    VC.OpenType = @"SPVC";
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 添加颜色的present方法 ==========
-(void)addColorBtnclicked:(UIButton *)btn{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDAddColorViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddColorViewController"];

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
    if (ORDER_ISEQUAl(XiaoShouDan) || ORDER_ISEQUAl(TuiHuoDan) || CaiGouBOOL) {
      //固定320高度
    NSString * key = [AD_MANAGER.sectionArray[indexPath.section] allKeys][0];
    NSArray * countArr = AD_MANAGER.sectionArray[indexPath.section][key];
    JDAddColorModel * colorModel = countArr[indexPath.row];
    
        BOOL khkhViewBOOL = [AD_MANAGER.markArray containsObject:@(1)];
        BOOL kcViewBOOL   = [AD_MANAGER.markArray containsObject:@(0)];
        BOOL bxViewBOOL   = [AD_MANAGER.markArray containsObject:@(2)];
        CGFloat heightH = 300;
        //YES为显示。NO为隐藏
        if (khkhViewBOOL && kcViewBOOL && bxViewBOOL) {//全部显示
        }else if (!khkhViewBOOL && !kcViewBOOL && !bxViewBOOL){//全部隐藏
            heightH = 300 - 110;
        }else if (khkhViewBOOL && !kcViewBOOL && !bxViewBOOL){//款号显示，空差和备注不显示
            heightH = 300 - 30;
        }else if (khkhViewBOOL && kcViewBOOL && !bxViewBOOL){//款号空差显示，备注不显示
            heightH = 300 - 30;
        }else if (!khkhViewBOOL && kcViewBOOL && !bxViewBOOL){//款号备注不显示，空差显示
             heightH = 300 - 30;
        }else if (!khkhViewBOOL && !kcViewBOOL && bxViewBOOL){//款号空差不显示，备注显示
            heightH = 300 - 70;
        }else if (khkhViewBOOL && !kcViewBOOL && bxViewBOOL){//款号备注不显示，空差显示
            heightH = 300 - 30;
        }
        
        

    NSInteger i = ([colorModel.psArray count] + 3 - 1) / 3 ;
        return i * 45  + heightH;
    }else{
        return _autoCellHeight;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (ORDER_ISEQUAl(YuDingDan)) {//预定单
        static NSString *identify = @"JDYangPinDanTableViewCell";
        JDYangPinDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.yangpinDelegate = self;
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
        cell.editFinfishBlock = ^{
            [weakself jisuanAllPrice];
        };
        [cell setCellValueData:self.spModel color:countArr[indexPath.row]];
        [self setYuDingDanShowHidden:cell];
        return cell;
    }else if (ORDER_ISEQUAl(XiaoShouDan) || ORDER_ISEQUAl(TuiHuoDan) || CaiGouBOOL){//销售单和退货单
        static NSString *identify = @"JDAddColorTableViewCell";
        JDAddColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.priceDelegate = self;
        cell.countDelegate = self;
        NSString * key = [AD_MANAGER.sectionArray[indexPath.section] allKeys][0];
        NSArray * countArr = AD_MANAGER.sectionArray[indexPath.section][key];
        JDAddColorModel * colorModel = countArr[indexPath.row];
        
        for (JDSelectSpModel * spModel in AD_MANAGER.selectSpPageArray) {
            if (spModel.spid == colorModel.spid) {
                self.spModel = spModel;
            }
        }
        kWeakSelf(self);
        cell.editFinfishBlock = ^{
            [weakself jisuanAllPrice];
        };
        [cell setCellValueData:self.spModel color:colorModel];
        [self setShowHiddenInCell:cell];
        return cell;
        
    }else if(ORDER_ISEQUAl(YangPinDan)){//样品单
        static NSString *identify = @"JDYangPinDanTableViewCell";
        JDYangPinDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.yangpinDelegate = self;
        NSString * key = [AD_MANAGER.sectionArray[indexPath.section] allKeys][0];
        NSArray * countArr = AD_MANAGER.sectionArray[indexPath.section][key];
        JDAddColorModel * colorModel = countArr[indexPath.row];
        
        for (JDSelectSpModel * spModel in AD_MANAGER.selectSpPageArray) {
            if (spModel.spid == colorModel.spid) {
                self.spModel = spModel;
            }
        }
        kWeakSelf(self);
        cell.editFinfishBlock = ^{
            [weakself jisuanAllPrice];
        };
        [cell setCellValueData:self.spModel color:colorModel];
        cell.psWidth.constant = 0;
        cell.psView.hidden = YES;
        [self setYangPinDanShowHidden:cell];
        return cell;
    }else{
        return nil;
    }

}

#pragma mark ==========  头视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    
    
    for (JDSelectSpModel * spModle in AD_MANAGER.selectSpPageArray) {
        if ([[AD_MANAGER.sectionArray[section] allKeys][0] intValue] == spModle.spid) {
            title = spModle.spmc;
        }
    }
    //如果没找到新加的商品，就直接在debug商品数组里面找
    if (!title) {
        for (JDSelectSpModel * spModle in AD_MANAGER.debugNewGoodsArray) {
            if ([[AD_MANAGER.sectionArray[section] allKeys][0] intValue] == spModle.spid) {
                title = spModle.spmc;
            }
        }
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
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 90)];
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
 
    [self jisuanAllPrice];
 
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
-(void)jisuanAllPrice{
    
    if (ORDER_ISEQUAl(YuDingDan) || ORDER_ISEQUAl(YangPinDan)) {
        double allPrice  = 0;
        //键盘消失的时候，开始计算总计价格
        for (NSInteger i = 0 ; i < AD_MANAGER.sectionArray.count; i++) {
            NSString * key = [AD_MANAGER.sectionArray[i] allKeys][0];
            NSArray * countArr = AD_MANAGER.sectionArray[i][key];
            
            for (JDAddColorModel * colorModel in countArr) {
                double price = ([colorModel.savePrice doubleValue] * [colorModel.saveCount doubleValue]) + ([colorModel.savekongcha doubleValue] * [colorModel.savePrice doubleValue]);
                allPrice = price + allPrice;
            }
        }
        self.totalPrice.text = [[NSString stringWithFormat:@"%.2f",allPrice] concate:@"¥"];
        
        
    }else{
        double allPrice  = 0;
        NSInteger allCount = 0;
        //键盘消失的时候，开始计算总计价格
        for (NSInteger i = 0 ; i < AD_MANAGER.sectionArray.count; i++) {
            NSString * key = [AD_MANAGER.sectionArray[i] allKeys][0];
            NSArray * countArr = AD_MANAGER.sectionArray[i][key];
            
            for (JDAddColorModel * colorModel in countArr) {
                double sumCount = [self inZhuFuTagOutAllCount:colorModel.saveZhuFuTag colorModel:colorModel];
                double price = [colorModel.savePrice doubleValue] * sumCount;
                allCount = sumCount + allCount;
                allPrice = price + allPrice;
            }
        }
        self.totalPrice.text = [[NSString stringWithFormat:@"%.2f",allPrice] concate:@"¥"];
    }
     [self setCountLblValue];
}
-(double)inZhuFuTagOutAllCount:(NSInteger)tag colorModel:(JDAddColorModel *)colorModel{
    //判断用的主单位还是副单位
    double sumCount = 0;
    for (NSDictionary * dic in colorModel.psArray) {
        if (colorModel.saveZhuFuTag == 0) {
            double smallCount1 = [dic[@"xssl"] doubleValue] +  [colorModel.savekongcha doubleValue] == 0 ? 0 : [dic[@"xssl"] doubleValue] +  [colorModel.savekongcha doubleValue];
            sumCount += smallCount1;
        }else{
            double smallCount2 = [dic[@"xsfsl"] doubleValue] +  [colorModel.savekongcha doubleValue] == 0 ? 0 : [dic[@"xsfsl"] doubleValue] +  [colorModel.savekongcha doubleValue];
            sumCount += smallCount2;
        }
    }
    return sumCount;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //1、先得到key
        //得到所有keys的数组
        NSMutableArray * keysArr = [[NSMutableArray alloc]init];
        if (AD_MANAGER.sectionArray.count > 0) {
            for (NSDictionary * dic in AD_MANAGER.sectionArray) {
                [keysArr addObject:[dic allKeys][0]];
            }
        }
        //2、得到index 下标对应的model,然后删除
        NSInteger row = indexPath.row ? indexPath.row : 0;
        NSDictionary * dic = AD_MANAGER.sectionArray[indexPath.section];
        [dic[[dic allKeys][0]] removeObjectAtIndex:row];
        
        
        for (NSInteger i = 0; i < AD_MANAGER.sectionArray.count ; i++) {
            NSString * key = [AD_MANAGER.sectionArray[i] allKeys][0];
            NSArray * countArr = AD_MANAGER.sectionArray[i][key];
            if (countArr.count == 0) {
                [AD_MANAGER.sectionArray removeObjectAtIndex:i];
            }
        }

        NSMutableArray * array1 = [NSMutableArray arrayWithArray:AD_MANAGER.sectionArray];
        //这里判断，删除有组名，没有内容的
        for (NSInteger i =0 ; i<array1.count; i++) {
            NSDictionary * dic = array1[i];
            if ([dic[[dic allKeys][0]] count] == 0) {
                [AD_MANAGER.sectionArray removeObject:dic];
            }
        }
        
        [self jisuanAllPrice];
        [UIView performWithoutAnimation:^{
            [self.underTableView reloadData];
        }];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)setCountLblValue{
    self.countLBl.text = NSIntegerToNSString(AD_MANAGER.sectionArray.count);
    ViewBorderRadius(self.countLBl, 5, 1, [UIColor redColor]);
}
//点击更改客户
- (IBAction)changeClientAction:(id)sender {
    kWeakSelf(self);
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDSalesActionViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesActionViewController"];
    VC.OpenType = @"SPVC";
    [self presentViewController:VC animated:YES completion:nil];
    /*
    kWeakSelf(self);
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDSalesTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesTagViewController"];
    VC.OpenType = @"SPVC";
//    VC.changeClientBlock = ^(JDSelectClientModel *model) {
//        weakself.clientModel = model;
//        [weakself.clientBtn setTitle:weakself.clientModel.khmc forState:UIControlStateNormal];
//    };
    [self.navigationController pushViewController:VC animated:YES];
     */
}
@end
