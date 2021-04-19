//
//  JDNewAddShouKuanTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/10.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDNewAddShouKuanTableViewController.h"
#import "JDDingJinTableViewCell.h"
#import "JDSelectClientViewController.h"
#import "JDYouHuiStyleTableViewCell.h"
#import "SelectedListView.h"
#import "YBPopupMenu.h"
#import "JDSalesActionViewController.h"
@interface JDNewAddShouKuanTableViewController ()<UITextFieldDelegate,YBPopupMenuDelegate>{
 
}

//@property (nonatomic,strong) NSMutableArray * section1Array;
//@property (nonatomic,strong) NSMutableArray * section2Array;
//@property (nonatomic,strong) NSMutableArray * section2TagArray;
@property (nonatomic,strong) NSMutableDictionary * resultDic;;


@end

@implementation JDNewAddShouKuanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ORDER_ISEQUAl(ShouKuanDan) ? @"新增收款单" : @"新增付款单";
    [self.tableView registerNib:[UINib nibWithNibName:@"JDDingJinTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDDingJinTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JDYouHuiStyleTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDYouHuiStyleTableViewCell"];
    _section3Show = NO;
    _section12Show = YES;
    LoginModel * model = AD_USERDATAARRAY;
    self.beizhuTf.delegate = self;
    self.menDianLbl.text = model.mdmc;
    self.qiankuanLbl.text = @"";
    self.tableView.separatorStyle = 0;
    _resultDic = [[NSMutableDictionary alloc]init];
    self.bencishoukuanLblTag.text =  ORDER_ISEQUAl(ShouKuanDan) ? @"本次收款":@"本次付款" ;
    self.clientLblTag.text =  ORDER_ISEQUAl(ShouKuanDan) ? @"客户":@"供应商";
    self.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)closeKeyboard:(UITapGestureRecognizer *)recognizer{
    [super closeKeyboard:recognizer];
    self.bencishoukuanLbl.text =  CCHANGE_DOUBLE([self jisuanShouKuan]);
    self.zhekoujineLbl.text = CCHANGE_DOUBLE([self jisuanZheKouJine]) ;
    
}
- (void)nextTextField:(NSNotification *)notification{
        [self textFieldShouldReturn:[notification object][@"tag"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextTextField:) name:@"xxxx" object:nil];
    self.navigationController.navigationBar.hidden = NO;
    
    self.clientLbl.text = ORDER_ISEQUAl(ShouKuanDan) ? AD_MANAGER.affrimDic[@"khmc"] : AD_MANAGER.affrimDic[@"gysmc"];
    self.clientLbl.text =   [self.clientLbl.text isEqualToString:@""] || !self.clientLbl.text ?  @"请选择" : self.clientLbl.text;

    if (self.djzt == 1) {//草稿
        self.beizhuTf.userInteractionEnabled = YES;
    }else if (self.djzt == 2){//审核
        _section12Show = NO;
        [self.btn1 setTitle:@"打印" forState:0];
        [self.btn2 setTitle:@"分享" forState:0];
        self.beizhuTf.userInteractionEnabled = NO;
    }
    
    if (ORDER_ISEQUAl(ShouKuanDan) && (self.djzt == 1 || self.djzt == 2)) {
        if (AD_MANAGER.affrimDic[@"jsrmc"] && ![AD_MANAGER.affrimDic[@"jsrmc"] isEqualToString:@""]){
            self.jingshourenLbl.text = AD_MANAGER.affrimDic[@"jsrmc"];
        }

    }
    
    if ([self.noteno isEqualToString:@""]) {
        [self requestData];
    }else if (self.noteno.length != 0){
        self.title = ORDER_ISEQUAl(ShouKuanDan) ?  @"收款单详情" : @"付款单详情";
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
        //支付方式
        self.section3Show = YES;
        kWeakSelf(self);
        [AD_MANAGER requestSelectZH:mDic success:^(id object) {
            [weakself showCaoGaoList:weakself.noteno];
        }];
        
    }
    
    [self getMuQianHaiQianKuan:self.clientLbl.text];
}
-(void)showAndHiddenMoreBtn{
    if (_moreBtn) {
        [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@9009]];

    }else{
        [self addNavigationItemWithTitles:@[@""] isLeft:NO target:self action:@selector(moreAction:) tags:@[@9009]];

    }

}

//取支付方式的值
-(NSMutableArray *)getPayWayArray{
    
    return AD_MANAGER.affrimDic[@"dingjinArray"];
}
//优惠方式取值
-(NSMutableArray *)getSalesWayArray{
    NSMutableArray * copyArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.affrimDic[@"zhekouArray"]];
    for (NSInteger i = 0; i <copyArray.count ; i++) {
        for (NSDictionary * dic1 in AD_MANAGER.selectZHlxArray) {
            
            if ([dic1[@"zklxmc"] isEqualToString:copyArray[i][@"zklxmc"]]) {
                if ([[AD_MANAGER.affrimDic[@"zhekouArray"][i] allKeys] count] == 2) {
                    
                    [AD_MANAGER.affrimDic[@"zhekouArray"][i] setValue:@2 forKey:@"dnxh"];
                    [AD_MANAGER.affrimDic[@"zhekouArray"][i] setValue:dic1[@"bz"] forKey:@"bz"];
                    [AD_MANAGER.affrimDic[@"zhekouArray"][i] setValue:dic1[@"zklxbm"] forKey:@"zklxbm"];
                    [AD_MANAGER.affrimDic[@"zhekouArray"][i] setValue:@([dic1[@"zklxid"] integerValue]) forKey:@"zklxid"];
                }
                
            }
        }
        
    }
    return AD_MANAGER.affrimDic[@"zhekouArray"];
}
#define TITLES1 @[@"草稿",@"提交",@"打印",@"删单"]
#define TITLES2 @[@"回到草稿",@"打印",@"远程打印"]

-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:_section12Show ? TITLES1 : TITLES2 icons:nil menuWidth:120 delegate:self];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":_resultDic[@"djhm"]}];
    if (_section12Show) {
        if (index == 0) {//草稿
            [self commonAction:0];
        }else if (index == 1){//提交
            [self commonAction:1];
        }else if (index == 2){//打印
            AD_MANAGER.noteno = self.noteno;
            [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
        }else if (index == 3){//删单
            if (ORDER_ISEQUAl(ShouKuanDan)) {
                [AD_MANAGER requestDelskdan:mDic success:^(id object) {
                    [weakself showToast:@"删除订单成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakself.navigationController popToRootViewControllerAnimated:YES];
                    });
                }];
            }else if (ORDER_ISEQUAl(FuKuanDan)){
                [AD_MANAGER requestDelFuKuandan:mDic success:^(id object) {
                    [weakself showToast:@"删除订单成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakself.navigationController popToRootViewControllerAnimated:YES];
                    });
                }];
            }
          
        }
    }else{
        AD_MANAGER.noteno = self.noteno;
        if (index == 1) {
            [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
        }else if (index == 2){
            [AD_SHARE_MANAGER longBlueToothCommonActionNav:self.navigationController];
        }
        
        else{
            //回到草稿,需要先进行反审
            NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"state":@(1),@"noteno":_resultDic[@"djhm"]}];
            if (ORDER_ISEQUAl(ShouKuanDan)) {
                [AD_MANAGER requestShouKuanDanFanShen:mDic1 success:^(id object) {
                    self.djzt = [object[@"djzt"] integerValue];
                    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
                    //支付方式
                    self.section3Show = YES;
                    kWeakSelf(self);
                    [AD_MANAGER requestSelectZH:mDic success:^(id object) {
                        weakself.section12Show = YES;
                        
                        [weakself.btn1 setTitle:@"草稿" forState:0];
                        [weakself.btn2 setTitle:@"提交" forState:0];
                        [weakself showCaoGaoList:weakself.noteno];
                    }];
                    
                }];
            }else if (ORDER_ISEQUAl(FuKuanDan)){
                [AD_MANAGER requestFuKuanDanFanShen:mDic1 success:^(id object) {
                    self.djzt = [object[@"djzt"] integerValue];
                    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
                    //支付方式
                    self.section3Show = YES;
                    kWeakSelf(self);
                    [AD_MANAGER requestSelectZH:mDic success:^(id object) {
                        weakself.section12Show = YES;
                        
                        [weakself.btn1 setTitle:@"草稿" forState:0];
                        [weakself.btn2 setTitle:@"提交" forState:0];
                        [weakself showCaoGaoList:weakself.noteno];
                    }];
                    
                }];
            }
 
        }
    }

}

#pragma mark ========== 收款方式 或 付款方式请求 ==========
-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    //支付方式
    [AD_MANAGER requestSelectZH:mDic success:^(id object) {
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
        //优惠方式
        [AD_MANAGER requestSelectZklx:mDic success:^(id object) {
            if (!AD_MANAGER.affrimDic[@"zhekouArray"] || [AD_MANAGER.affrimDic[@"zhekouArray"] count] == 0) {
                [AD_MANAGER.affrimDic setValue:AD_MANAGER.selectZHlxArray forKey:@"zhekouArray"];
            }
            if (!AD_MANAGER.affrimDic[@"dingjinArray"] || [AD_MANAGER.affrimDic[@"dingjinArray"] count] == 0) {
                [AD_MANAGER.affrimDic setValue:AD_MANAGER.selectZHArray forKey:@"dingjinArray"];
            }
            weakself.djzt = [self.resultDic[@"djzt"] integerValue];
            [weakself.tableView reloadData];
        }];
    }];
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }if(2 == indexPath.section){
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:2]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (ORDER_ISEQUAl(ShouKuanDan)) {
            return 4;
        }else{
            return 3;
        }
        
    }else if (section == 1) {
 
            return  [AD_MANAGER.affrimDic[@"dingjinArray"] count];

    }else if (section == 2){
        return  [AD_MANAGER.affrimDic[@"zhekouArray"] count];
    }else if (section == 4){
        if (_section3Show) {
            return 4;
        }else{
            return 0;
        }
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (_section12Show) {
            return 50;

        }else{
            return 0;
        }
    }else if (indexPath.section == 2){
        if (_section12Show) {
            return 105;

        }else{
            return 0;
        }
    }else if (indexPath.section == 4 ){
        if (_section3Show) {
            return  50;
        }else{
            return 0;
        }
    }
    else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 40)];

        if (_section12Show) {
            //titile
            UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, KScreenWidth, 40)];
            HeaderLabel.font = [UIFont systemFontOfSize:15];
            HeaderLabel.text = @"支付方式";
            HeaderLabel.textColor = JDRGBAColor(153, 153, 153);
            HeaderLabel.backgroundColor = KClearColor;
            view.backgroundColor = JDRGBAColor(245, 247, 250);
            [view addSubview:HeaderLabel];
        }else{
            view.hidden = YES;
        }
  
        return view;
        
    }else if (section == 2){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 10)];
        view.backgroundColor = JDRGBAColor(245, 247, 250);
        return view;
    }
    else{
        return [self tableView:tableView viewForHeaderInSection:section];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 if (section == 1) {
        if (_section12Show) {
            return 33;
        }else{
            return 0;
        }
    }else if (section == 2 ) {
        if (_section12Show) {
            return 10;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        JDDingJinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDDingJinTableViewCell" forIndexPath:indexPath];
        if (_section12Show) {
            
            NSArray * imgArr =  @[@"icon_xianjin",@"icon_wangyin",@"icon_zhifubao",@"icon_weixinzhifu",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita"];
            NSDictionary * dic  = AD_MANAGER.affrimDic[@"dingjinArray"][indexPath.row];
                cell.pagWayTf.tag = 1000+indexPath.row;
                cell.pagWayTf.delegate = self;
                NSInteger index = 0;
                if ([dic[@"zhlx"] integerValue] > imgArr.count) {
                    index = 5;
                }else{
                    index = [dic[@"zhlx"] integerValue];
                }
                cell.payWayImg.image =[UIImage imageNamed:imgArr[index]];
                cell.pagWayName.text =dic[@"zhmc"];
                cell.pagWayTf.text = ORDER_ISEQUAl(FuKuanDan) ? doubleToNSString([dic[@"fkje"] doubleValue]) : doubleToNSString([dic[@"skje"] doubleValue]);
                
                
                if ([cell.pagWayTf.text doubleValue] == 0) {
                    cell.pagWayTf.text  = @"";
                }
                self.bencishoukuanLbl.text =  CCHANGE_DOUBLE([self jisuanShouKuan]);
        }else{
            cell.hidden = YES;
        }
        return cell;

    }else if (indexPath.section == 2){
        JDYouHuiStyleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDYouHuiStyleTableViewCell" forIndexPath:indexPath];
        if (_section12Show) {
            NSDictionary * dic = AD_MANAGER.affrimDic[@"zhekouArray"][indexPath.row];

            cell.priceTf.tag = 3000 + indexPath.row;
            cell.priceTf.delegate = self;
            cell.priceTf.text = doubleToNSString([dic[@"je"] doubleValue]);
            [cell.styleBtn setTitle:dic[@"zklxmc"] forState:0];
            cell.styleTitle.text = [dic[@"zklxmc"]append:@"金额"];
            
        
            if ([cell.priceTf.text doubleValue] == 0) {
                cell.priceTf.text  = @"";
            }
            self.zhekoujineLbl.text = CCHANGE_DOUBLE([self jisuanZheKouJine]) ;
        }else{
            cell.hidden = YES;
        }
       
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}
#pragma mark ========== 优惠方式的点击方法 ==========
-(void)selectStyleBtn:(UIButton *)btn{
        //点击优惠方式，改变界面的控件
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i <  AD_MANAGER.selectZHlxArray.count; i++) {
            [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:AD_MANAGER.selectZHlxArray[i][@"zklxmc"]]];
        }
        view.array = [NSArray arrayWithArray:mArray];
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:btn.tag-30000 inSection:2];
                JDYouHuiStyleTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.styleTitle.text = [model.title append:@"金额"];
                [cell.styleBtn setTitle:model.title forState:UIControlStateNormal];
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 112)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 100, 113, 30);
        btn.center = view.center;
        [btn setTitle:@"+ 添加优惠" forState:UIControlStateNormal];
        [btn setTitleColor:JDRGBAColor(0, 163, 255) forState:UIControlStateNormal];
        ViewBorderRadius(btn, 5, 0.5, JDRGBAColor(0, 163, 255));
        btn.font = [UIFont systemFontOfSize:13];
        btn.tag = section+100;
        [btn addTarget:self action:@selector(addsalesBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        return view;
    }else{
        return nil;
    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView { CGFloat sectionFooterHeight = 112; CGFloat ButtomHeight = scrollView.contentSize.height - self.tableView.frame.size.height; if (ButtomHeight-sectionFooterHeight <= scrollView.contentOffset.y && scrollView.contentSize.height > 0) { scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); } else { scrollView.contentInset = UIEdgeInsetsMake(0, 0, -(sectionFooterHeight), 0); } }

-(void)addsalesBtnclicked:(UIButton *)btn{
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:@"" forKey:@"zklxmc"];
//    [dic setValue:@"" forKey:@"je"];
//    [_section2Array addObject:@{NSIntegerToNSString(_section2Array.count):dic}];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
//    self.djzt = [self.resultDic[@"djzt"] integerValue];

}

//计算本次收款
-(double)jisuanShouKuan{
    double payPrice = 0;
    for (NSDictionary * dic in [self getPayWayArray]) {
        payPrice += CaiGouBOOL ?[dic[@"fkje"] doubleValue] : [dic[@"skje"] doubleValue];
    }
    return payPrice;
}
//计算折扣金额
-(double)jisuanZheKouJine{
    double salesPrice = 0;
    for (NSDictionary * dic in [self getSalesWayArray]) {
        salesPrice += [dic[@"je"] doubleValue];
    }
    return salesPrice;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        if (_section12Show) {
            return 112;

        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section  == 0 && indexPath.row == 1) {

        if (self.djzt == 2) {
            return;
        }else{
            kWeakSelf(self);
            UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
            JDSalesActionViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesActionViewController"];
            weakself.clientLbl.text = ORDER_ISEQUAl(ShouKuanDan) ? AD_MANAGER.affrimDic[@"khmc"] : AD_MANAGER.affrimDic[@"gysmc"] ;
            VC.shoukuankehuBlock = ^{
                weakself.clientLbl.text = ORDER_ISEQUAl(ShouKuanDan) ? AD_MANAGER.affrimDic[@"khmc"] : AD_MANAGER.affrimDic[@"gysmc"] ;
                [weakself getMuQianHaiQianKuan:weakself.clientLbl.text];
            };
            VC.OpenType = @"SPVC";
            [self presentViewController:VC animated:YES completion:nil];
            
        }
 
    }else if (indexPath.section  == 0 && indexPath.row == 3){
        if (self.djzt == 2) {
            return;
        }else{
            [self selectJingShouRen];
        }
    }
}
-(void)selectJingShouRen{
    NSMutableDictionary* mDic3 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pagesize":@"500",@"pon":@"",@"keywords":@""}];
    [AD_MANAGER requestSelectYgPage:mDic3 success:^(id object) {
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i <  AD_MANAGER.selectYgPageArray.count; i++) {
            JDSelectYgModel * ygModel = AD_MANAGER.selectYgPageArray[i];
            [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:ygModel.ygmc]];
        }
        view.array = [NSArray arrayWithArray:mArray];
        kWeakSelf(self);
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                weakself.jingshourenLbl.text = model.title;
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
    }];
}
//下单提交
- (IBAction)tijiaoAction:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"分享"]) {
        [self shareAction];
    }else{
        [self commonAction:1];
    }
}
//草稿提交
- (IBAction)caogaoAction:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"打印"]) {
        AD_MANAGER.noteno = self.noteno;
        [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
    }else{
        [self commonAction:0];
    }

}
-(void)commonAction:(NSInteger)autocheck{
    NSMutableDictionary * resultDic = [[NSMutableDictionary alloc]initWithDictionary:_resultDic];
    
    NSString * djhmStr = @"";
    if (_resultDic && ![_resultDic[@"djhm"] isEqualToString:@""]) {
        djhmStr = _resultDic[@"djhm"];
    }
    
    
    
    
    
    
    
    [resultDic setValue:djhmStr forKey:@"djhm"];//单据号码 新增时传空字符串
    [resultDic setValue:[NSString currentDateStringyyyyMMdd] forKey:@"rzrq"];
    JDSelectClientModel * clientModel = [AD_SHARE_MANAGER inKeHuNameOutKeHuId:ORDER_ISEQUAl(ShouKuanDan) ? AD_MANAGER.affrimDic[@"khmc"] :  AD_MANAGER.affrimDic[@"gysmc"]];
    [resultDic setValue:ORDER_ISEQUAl(ShouKuanDan) ? @(clientModel.Khid) : @(clientModel.gysid) forKey:ORDER_ISEQUAl(ShouKuanDan) ? @"khid" : @"gysid"];
    
    
    if ([self.jingshourenLbl.text isEqualToString:@"请选择"] || [self.jingshourenLbl.text isEqualToString:@""] || !self.jingshourenLbl.text) {
        [resultDic setValue:@(0) forKey:@"jsrid"];

    }else{
        [resultDic setValue:@([AD_SHARE_MANAGER inYeWuYuanNameOutYeWuYuanId:self.jingshourenLbl.text]) forKey:@"jsrid"];

    }
    
    [resultDic setValue:self.beizhuTf.text forKey:@"djbz"];
    [resultDic setValue:@"" forKey:@"bjmc"];
    double djzt = 0;
    if (_resultDic && [_resultDic[@"djzt"] doubleValue] != 0) {
        djzt = [_resultDic[@"djzt"] doubleValue];
    }
    [resultDic setValue:@(djzt) forKey:@"djzt"];
    [resultDic setValue:AD_MANAGER.affrimDic[@"dingjinArray"] forKey:ORDER_ISEQUAl(ShouKuanDan) ? @"tbnote_skcbs" : @"tbnote_fkcbs"];
    [resultDic setValue:AD_MANAGER.affrimDic[@"zhekouArray"] forKey:ORDER_ISEQUAl(ShouKuanDan) ?  @"tbnote_skcb_zks" : @"tbnote_fkcb_zks"];
    NSString * string = [ADTool dicConvertToNSString:resultDic];
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autocheck)}];
    
    
    if (ORDER_ISEQUAl(ShouKuanDan)) {
        if ([self.jingshourenLbl.text isEqualToString:@"请选择"] || [self.jingshourenLbl.text isEqualToString:@""] || !self.jingshourenLbl.text) {
            [self showToast:@"请选择经手人"];
            return;
        }
        [resultDic setValue:@([AD_SHARE_MANAGER inYeWuYuanNameOutYeWuYuanId:self.jingshourenLbl.text]) forKey:@"jsrid"];
        //支付方式
        [AD_MANAGER requestSaveShouKuanDan:mDic success:^(id object) {
            [weakself commonTiJiaoAction:autocheck object:object];
            
        }];
    }else if(ORDER_ISEQUAl(FuKuanDan)){
        //支付方式
        [AD_MANAGER requestSaveFuKuanDan:mDic success:^(id object) {
            [weakself commonTiJiaoAction:autocheck object:object];

            
        }];
    }
    
    
    
  
}
-(void)commonTiJiaoAction:(NSInteger)autocheck object:(id)object{
    kWeakSelf(self);
    if (autocheck == 0) {
        [weakself showToast:[@"草稿单保存成功" append:object[@"data"]]];
        
        //刷新出来第3组
        _section3Show = YES;
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
        //请求草稿单
        [weakself showCaoGaoList:object[@"data"]];
        
    }else{
        _section3Show = YES;
        _section12Show = NO;
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        NSString * alertString = ORDER_ISEQUAl(ShouKuanDan) ? @"收款单提交成功" : @"付款单提交成功";
        [weakself showToast:[alertString append:object[@"data"]]];
        [weakself showCaoGaoList:object[@"data"]];
        
        
        //如果是提交成功后，显示打印和分享
        [weakself.btn1 setTitle:@"打印" forState:0];
        [weakself.btn2 setTitle:@"分享" forState:0];
        
    }
    
    weakself.moreBtn = YES;
    [weakself showAndHiddenMoreBtn];
    weakself.djzt = [weakself.resultDic[@"djzt"] integerValue];
}
-(void)showCaoGaoList:(NSString *)noteno{

    kWeakSelf(self);

    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":noteno}];
    
    
    if (ORDER_ISEQUAl(FuKuanDan)) {
        [AD_MANAGER requestShowFKList:mDic success:^(id object) {
            [weakself commonListAction:object];
        }];
    }else if (ORDER_ISEQUAl(ShouKuanDan)){
        [AD_MANAGER requestShowSKList:mDic success:^(id object) {
            [weakself commonListAction:object];
        }];
    }
   
    
}
-(void)commonListAction:(id)object{
    kWeakSelf(self);

    NSDictionary * dic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
    _resultDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    //重新给界面赋值
    //客户
    weakself.clientLbl.text = ORDER_ISEQUAl(ShouKuanDan) ?  dic[@"khmc"] : dic[@"gysmc"];
    weakself.clientLbl.text =   [weakself.clientLbl.text isEqualToString:@""] ?  @"请选择" : weakself.clientLbl.text;
    //门店
    weakself.menDianLbl.text = dic[@"mdmc"];
    //支付方式
    
    
    
    
    //优惠方式
    
    //本次收款
    double sumSk = 0;
    for (NSDictionary * dic1 in ORDER_ISEQUAl(ShouKuanDan) ? dic[@"tbnote_skcbs"] : dic[@"tbnote_fkcbs"]) {
        if (ORDER_ISEQUAl(ShouKuanDan) ? [dic1[@"skje"] doubleValue] :[dic1[@"fkje"] doubleValue]  != 0) {
            sumSk += ORDER_ISEQUAl(ShouKuanDan) ? [dic1[@"skje"] doubleValue] :[dic1[@"fkje"] doubleValue] ;
        }
    }
    weakself.bencishoukuanLbl.text = CCHANGE_DOUBLE(sumSk);
    
    
    //折扣金额
    double sumZk = 0;
    for (NSDictionary * dic1 in ORDER_ISEQUAl(ShouKuanDan) ? dic[@"tbnote_skcb_zks"] :  dic[@"tbnote_fkcb_zks"]) {
        if ([dic1[@"je"] doubleValue] != 0) {
            sumZk += [dic1[@"je"] doubleValue];
        }
    }
    
    weakself.zhekoujineLbl.text = CCHANGE_DOUBLE(sumZk);

    
    weakself.danjuhaoLbl.text = dic[@"djhm"];
    weakself.caozuoTimeLbl.text = dic[@"zdrq"];
    weakself.caozuoyuanLbl.text = dic[@"zdrmc"];
    
    weakself.bencishoukuanDetail.hidden = NO;
    weakself.zhekoujineDetail.hidden = NO;
    
    NSMutableArray * sksjeArray = [[NSMutableArray alloc]init];;
    for (NSDictionary * dic1 in ORDER_ISEQUAl(ShouKuanDan) ? dic[@"tbnote_skcbs"] : dic[@"tbnote_fkcbs"]) {
        if (ORDER_ISEQUAl(ShouKuanDan) ? [dic1[@"skje"] doubleValue] :[dic1[@"fkje"] doubleValue] != 0) {
            [sksjeArray addObject:[NSString stringWithFormat:@"(%@)",[dic1[@"zhmc"] append:ORDER_ISEQUAl(ShouKuanDan) ? CCHANGE(dic1[@"skje"]) : CCHANGE(dic1[@"fkje"])]]];
        }
    }
    NSString * ksjeStr = [sksjeArray componentsJoinedByString:@","];
    weakself.bencishoukuanDetail.text = [NSString stringWithFormat:@"%@",ksjeStr] ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:weakself.bencishoukuanDetail.text];
    NSRange range1 = [[str string] rangeOfString:ksjeStr];
    [str addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range1];
    weakself.bencishoukuanDetail.attributedText = str;
    
    NSMutableArray * tbnote_skcb_zk = [[NSMutableArray alloc]init];;
    for (NSDictionary * dic1 in ORDER_ISEQUAl(ShouKuanDan) ? dic[@"tbnote_skcb_zks"] :  dic[@"tbnote_fkcb_zks"]) {
        if ([dic1[@"je"] doubleValue] != 0) {
            [tbnote_skcb_zk addObject:[NSString stringWithFormat:@"(%@)",[dic1[@"zklxmc"] append:CCHANGE(dic1[@"je"])]]];
        }
    }
    NSString * ksjeStr1 = [tbnote_skcb_zk componentsJoinedByString:@","];
    weakself.zhekoujineDetail.text = [NSString stringWithFormat:@"%@",ksjeStr1] ;
    NSMutableAttributedString *str11 = [[NSMutableAttributedString alloc] initWithString:weakself.zhekoujineDetail.text];
    NSRange range11 = [[str string] rangeOfString:ksjeStr1];
    [str11 addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(153, 153, 153) range:range11];
    weakself.zhekoujineDetail.attributedText = str11;
    
    AD_MANAGER.affrimDic[@"zhekouArray"] = [NSMutableArray arrayWithArray:ORDER_ISEQUAl(ShouKuanDan) ?  _resultDic[@"tbnote_skcb_zks"] : _resultDic[@"tbnote_fkcb_zks"]];
    AD_MANAGER.affrimDic[@"dingjinArray"] = [NSMutableArray arrayWithArray:ORDER_ISEQUAl(ShouKuanDan) ?  _resultDic[@"tbnote_skcbs"] : _resultDic[@"tbnote_fkcbs"]];
    
    
    
    [weakself getMuQianHaiQianKuan:ORDER_ISEQUAl(ShouKuanDan) ? dic[@"khmc"] : dic[@"gysmc"]];
    
    [weakself.tableView reloadData];
    
    self.djzt = [self.resultDic[@"djzt"] integerValue];
    weakself.moreBtn = YES;
    
    [weakself showAndHiddenMoreBtn];

    
}


-(void)getMuQianHaiQianKuan:(NSString *)name{
    //目前还欠款
    JDSelectClientModel * clientModel = [AD_SHARE_MANAGER inKeHuNameOutKeHuId:name];
    
    self.qiankuanLbl.text = ORDER_ISEQUAl(ShouKuanDan) ? CCHANGE_DOUBLE(clientModel.yszk) : CCHANGE_DOUBLE(clientModel.yfzk);
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldShouldReturn:textField];
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UITextField * tf0 = [self.view viewWithTag:1000];
    UITextField * tf1 = [self.view viewWithTag:1001];
    UITextField * tf2 = [self.view viewWithTag:1002];
    UITextField * tf3 = [self.view viewWithTag:1003];
    UITextField * tf4 = [self.view viewWithTag:1004];
    UITextField * tf5 = [self.view viewWithTag:1005];
    UITextField * tf6 = [self.view viewWithTag:1006];
    UITextField * tf7 = [self.view viewWithTag:1007];
    UITextField * tf8 = [self.view viewWithTag:1008];
    UITextField * tf9 = [self.view viewWithTag:1009];
    UITextField * tf10 = [self.view viewWithTag:1010];

    if (textField.tag == 1000) {
        [tf0 resignFirstResponder];
        [tf1 becomeFirstResponder];
    }else if (textField.tag == 1001) {
        [tf1 resignFirstResponder];
        [tf2 becomeFirstResponder];
    }else if (textField.tag == 1002){
        [tf2 resignFirstResponder];
        [tf3 becomeFirstResponder];
    }else if (textField.tag == 1003){
        [tf3 resignFirstResponder];
        [tf4 becomeFirstResponder];
    }else if (textField.tag == 1004){
        [tf4 resignFirstResponder];
        [tf5 becomeFirstResponder];
    }else if (textField.tag == 1005){
        [tf5 resignFirstResponder];
        [tf6 becomeFirstResponder];
    }else if (textField.tag == 1006){
        [tf6 resignFirstResponder];
        [tf7 becomeFirstResponder];
    }else if (textField.tag == 1007){
        [tf7 resignFirstResponder];
        [tf8 becomeFirstResponder];
    }else if (textField.tag == 1008){
        [tf8 resignFirstResponder];
        [tf9 becomeFirstResponder];
    }else if (textField.tag == 1009){
        [tf9 resignFirstResponder];
        [tf10 becomeFirstResponder];
    }else if (textField.tag == 1010){
        [self.view endEditing:YES];
    }else{
        [self.view endEditing:YES];

    }

    
    if (textField.tag) {
        if (textField.tag-1000 >= 0  && textField.tag-1000 <= 100) {
            NSMutableArray * dingjinArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.affrimDic[@"dingjinArray"]];
            NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:dingjinArray[textField.tag-1000]];
            [muDic setValue:@([textField.text doubleValue]) forKey:ORDER_ISEQUAl(FuKuanDan) ? @"fkje" : @"skje"];
            [dingjinArray replaceObjectAtIndex:textField.tag-1000 withObject:muDic];
            [AD_MANAGER.affrimDic setValue:dingjinArray forKey:@"dingjinArray"];
        }else{
            NSMutableArray * zkArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.affrimDic[@"zhekouArray"]];
            NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:zkArray[textField.tag-3000]];
            [muDic setValue:@([textField.text doubleValue]) forKey:@"je"];
            [zkArray replaceObjectAtIndex:textField.tag-3000 withObject:muDic];
            [AD_MANAGER.affrimDic setValue:zkArray forKey:@"zhekouArray"];
        }
    }
 
    
    self.bencishoukuanLbl.text =  CCHANGE_DOUBLE([self jisuanShouKuan]);
    self.zhekoujineLbl.text = CCHANGE_DOUBLE([self jisuanZheKouJine]) ;
    
    return YES;
    
    
}

-(void)shareAction{
    if (ORDER_ISEQUAl(ShouKuanDan)) {
        [self requestDataShareData];

    }
}

-(void)requestDataShareData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":self.noteno}];
    [AD_MANAGER requestShareWeiXin:mDic success:^(id object) {
        [AD_SHARE_MANAGER showShareView:object[@"data"]];
    } notetype:@"sk"];
}
@end
