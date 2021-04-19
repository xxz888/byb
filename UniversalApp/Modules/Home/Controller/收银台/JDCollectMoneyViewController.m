//
//  JDCollectMoneyViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/6/24.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDCollectMoneyViewController.h"
#import "JDCMFirstTableViewCell.h"
#import "JDSalesView.h"
#import "JDPayWayView.h"
#import "SelectedListView.h"
#import "JDSelectSpModel.h"
#import "JDAddColorModel.h"
#import "JDAllOrderViewController.h"
#import "JDSuccessVCViewController.h"

@interface JDCollectMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,copy) UITableView * underTableView;
@end

@implementation JDCollectMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收银台";

    
    self.view.backgroundColor = JDRGBAColor(245, 247, 250);

    self.allPriceLbl.text = AD_MANAGER.affrimDic[@"allPrice"] ;

    [self requestData];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    - (void)nextTextField:(NSNotification *)notification{
        [self textFieldShouldReturn:[notification object][@"tag"]];
    }

- (void)closeKeyboard:(UITapGestureRecognizer *)recognizer{
    [super closeKeyboard:recognizer];
    self.allPriceLbl.text = doubleToNSString([self getNowPrice]);
    
}
-(double)getNowPrice{
    double payPrice = 0;
    for (NSDictionary * dic in [self getPayWayArray]) {
        payPrice += CaiGouBOOL ?[dic[@"fkje"] doubleValue] : [dic[@"skje"] doubleValue];
    }
    
    double salesPrice = 0;
    for (NSDictionary * dic in [self getSalesWayArray]) {
        salesPrice += [dic[@"je"] doubleValue];
    }

    return [[self.allPrice replaceAll:@"¥" target:@""] doubleValue] - payPrice - salesPrice;
}
-(double)willComeIn{
    double payPrice = 0;
    for (NSDictionary * dic in AD_MANAGER.affrimDic[@"dingjinArray"]) {
        payPrice += CaiGouBOOL ?[dic[@"fkje"] doubleValue] : [dic[@"skje"] doubleValue];
    }
    
    double salesPrice = 0;
    for (NSDictionary * dic in AD_MANAGER.affrimDic[@"zhekouArray"]) {
        salesPrice += [dic[@"je"] doubleValue];
    }
    
    return [[self.allPrice replaceAll:@"¥" target:@""] doubleValue] - payPrice - salesPrice;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextTextField:) name:@"xxxx" object:nil];

    
     self.allPriceLbl.text = doubleToNSString([self willComeIn]);
}
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
            }else{
                NSMutableArray * copyArray = [NSMutableArray arrayWithArray:AD_MANAGER.affrimDic[@"dingjinArray"]];
                for (NSDictionary * dic3 in AD_MANAGER.affrimDic[@"dingjinArray"]) {
                    NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:dic3];
                    [copyArray removeObject:dic3];
                    [copyArray addObject:newDic];
                }
                
                
                for (NSDictionary * dic1 in AD_MANAGER.selectZHArray) {
                    for (NSInteger i = 0; i < copyArray.count; i++) {
                        if ([dic1[@"zhid"] integerValue] == [copyArray[i][@"zhid"] integerValue]) {
                            [copyArray[i] setValue:@([dic1[@"zhlx"] integerValue]) forKey:@"zhlx"];
                        }
                    }
                }
                [AD_MANAGER.affrimDic setValue:copyArray forKey:@"dingjinArray"];
                
             
            }
          
            [weakself.underTableView reloadData];
        }];
    }];

}
#pragma mark ========== 创建tablevidew ==========
-(UITableView *)underTableView {
    if (!_underTableView) {
        _underTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.underView.frame.size.width, self.underView.frame.size.height - 40) style:UITableViewStyleGrouped];
        _underTableView.delegate = self;
        _underTableView.dataSource = self;
        _underTableView.backgroundColor = KWhiteColor;
        [_underTableView registerNib:[UINib nibWithNibName:@"JDCMFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDCMFirstTableViewCell"];
 
        [_underTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.underView addSubview:_underTableView];

    }
    return _underTableView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 40)];
        //titile
        UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, KScreenWidth, 40)];
        HeaderLabel.font = [UIFont systemFontOfSize:15];
        HeaderLabel.text = @"支付方式";
        HeaderLabel.textColor = JDRGBAColor(153, 153, 153);
        HeaderLabel.backgroundColor = KClearColor;
        view.backgroundColor = JDRGBAColor(245, 247, 250);
        [view addSubview:HeaderLabel];
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
        return 33;
    }else if (section == 2) {
        return 10;
    }else{
        return 0;
    }
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 112;

    }else{
        return 0;
    }
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
#pragma mark ========== 添加优惠 ==========
-(void)addsalesBtnclicked:(UIButton *)btn{

    NSMutableArray * zkArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.affrimDic[@"zhekouArray"]];
    NSMutableDictionary * zkDic = [[NSMutableDictionary alloc]init];
    [zkDic setValue:AD_MANAGER.selectZHlxArray[0][@"zklxmc"] forKey:@"zklxmc"];
    [zkArray addObject:zkDic];
    [AD_MANAGER.affrimDic setValue:zkArray forKey:@"zhekouArray"];
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:2];
    [self.underTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        JDCMFirstTableViewCell * fcell = [tableView dequeueReusableCellWithIdentifier:@"JDCMFirstTableViewCell" forIndexPath:indexPath];
        fcell.allPrice.text = AD_MANAGER.affrimDic[@"allPrice"];

        fcell.lbl1.text =  CCHANGE_DOUBLE(self.clientModel.yszk);
        fcell.lbl2.text =  [CCHANGE_DOUBLE(self.clientModel.yszk) replaceAll:@"¥" target:@"¥-"];

        return fcell;
    }else if (indexPath.section == 1){
        UITableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell1.selectionStyle = 0;
        [cell1.contentView removeAllSubviews];

                NSArray * imgArr =  @[@"icon_xianjin",@"icon_wangyin",@"icon_zhifubao",@"icon_weixinzhifu",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita"];
        NSMutableArray * dingjinArr = [NSMutableArray arrayWithArray:AD_MANAGER.affrimDic[@"dingjinArray"]];
        for (NSInteger i = 0 ; i < [dingjinArr count]; i++) {
            JDPayWayView * view = (JDPayWayView *)[self payWayView];
            view.tag = 100+i;
            view.pagWayTf.tag = 1000+i;
            view.pagWayTf.delegate = self;
            view.frame = CGRectMake(0, 50 * i, kScreenWidth, 50);
            NSInteger index = 0;
            if ([dingjinArr[i][@"zhlx"] integerValue] > imgArr.count) {
                index = 5;
            }else{
                index = [dingjinArr[i][@"zhlx"] integerValue];
            }
            view.payWayImg.image =[UIImage imageNamed:imgArr[index]];
            view.pagWayName.text =dingjinArr[i][@"zhmc"];
            view.pagWayTf.text = CaiGouBOOL ? doubleToNSString([dingjinArr[i][@"fkje"] doubleValue]) : doubleToNSString([dingjinArr[i][@"skje"] doubleValue]);
            
            
            if ([view.pagWayTf.text doubleValue] == 0) {
                view.pagWayTf.text  = @"";
            }
            [cell1.contentView addSubview:view];
        }
        return cell1;
    }else{
        UITableViewCell * cell2 = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell2.selectionStyle = 0;
        [cell2.contentView removeAllSubviews];
        
        
        
        NSMutableArray * zkArr = [NSMutableArray arrayWithArray:AD_MANAGER.affrimDic[@"zhekouArray"]];

        for (NSInteger i = 0 ; i < zkArr.count; i++) {
            JDSalesView * view = (JDSalesView *)[self salesView];
            view.priceTf.tag = 3000 + i;
            view.sid = 1;
            view.priceTf.delegate = self;
            view.frame = CGRectMake(0, 105 * i, kScreenWidth, 105);
            view.priceTf.text = doubleToNSString([zkArr[i][@"je"] doubleValue]);
            [view.saleswayBtn setTitle:zkArr[i][@"zklxmc"] forState:0];
            view.wayTitltLbl.text = [zkArr[i][@"zklxmc"]append:@"金额"];
            
            
            [cell2.contentView addSubview:view];

            if ([view.priceTf.text doubleValue] == 0) {
                view.priceTf.text  = @"";
            }
            //回调
            kWeakSelf(self);
            view.block = ^(JDSalesView * salesView) {
                NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
                //优惠方式
                [AD_MANAGER requestSelectZklx:mDic success:^(id object) {
                    [weakself salesWayAction:salesView];
                }];
            };
        }
        return cell2;

    }
    
}

//优惠方式
- (void)salesWayAction:(JDSalesView *)saleView{
    
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    NSMutableArray * mArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0 ; i <  AD_MANAGER.selectZHlxArray.count; i++) {
        [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:AD_MANAGER.selectZHlxArray[i][@"zklxmc"]]];
    }
    view.array = [NSMutableArray arrayWithArray:mArray];
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            saleView.wayTitltLbl.text = [model.title append:@"金额"];
            saleView.sid = model.sid;
        
            [saleView.saleswayBtn setTitle:model.title forState:UIControlStateNormal];
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
-(UIView *)payWayView{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"JDPayWayView" owner:self options:nil];
    JDPayWayView * view = [nib objectAtIndex:0];
    return view;
}
-(UIView *)salesView{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"JDSalesView" owner:self options:nil];
    JDSalesView * view = [nib objectAtIndex:0];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 117 : indexPath.section == 1 ? [AD_MANAGER.affrimDic[@"dingjinArray"] count] * 50 : ([AD_MANAGER.affrimDic[@"zhekouArray"] count] * 105);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
//存为草稿
- (IBAction)saveDraftAction:(id)sender {
    if (ORDER_ISEQUAl(XiaoShouDan)) {
        [self setXiaoShouDanAction:0];
    }else if (ORDER_ISEQUAl(YangPinDan)){
        [self setYangPinDanAction:0];
    }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
        [self setCaiGouRuKuDanCommonAction:0];
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

//下一步
- (IBAction)selectOKAction:(id)sender {
    /*
     xsje = (xssl+ spkc) xsdj
     （销售金额）=（销售数量 + 空差） 销售单价
     空差一般为负数
     */
    if (ORDER_ISEQUAl(XiaoShouDan)) {
        [self setXiaoShouDanAction:1];
    }else if (ORDER_ISEQUAl(YangPinDan)){
        [self setYangPinDanAction:1];
    }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
        [self setCaiGouRuKuDanCommonAction:1];
    }
    
}
#pragma mark ========== 样品请求 ==========
-(void)setYangPinDanAction:(NSInteger)autoCheck{
    [AD_MANAGER.caoGaoDic setValue:[self getPayWayArray] forKey:@"tbnote_ypxscb_sks"];//收款列表
    [AD_MANAGER.caoGaoDic setValue:[self getSalesWayArray] forKey:@"tbnote_ypxscb_zks"];//折扣列表
    [AD_MANAGER.caoGaoDic setValue:self.allOrderYangPinYuDingListCommonParamtersArray forKey:@"tbnote_ypxscbs"];//商品列表
    kWeakSelf(self);//autocheck 自动审核 1:是(默认) 0:仅存草稿
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestYangPinOrderSaveNote:mDic success:^(id object) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        if (autoCheck == 1) {
            [self showToast:[@"样品单保存成功" append:object[@"data"]]];
            JDSuccessVCViewController * VC = [[JDSuccessVCViewController alloc]init];
            VC.noteno = object[@"data"];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else{
            [weakself showToast:@"样品单存为草稿成功"];
            JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
            VC.selectTag1 = 3;
            [weakself.navigationController pushViewController:VC animated:YES];
        }
    }];
}


#pragma mark ========== 销售单请求 ==========
-(void)setXiaoShouDanAction:(NSInteger)autoCheck{

    [AD_MANAGER.caoGaoDic setValue:[self getPayWayArray] forKey:@"tbnote_spxscb_sks"];//收款列表
    [AD_MANAGER.caoGaoDic setValue:[self getSalesWayArray] forKey:@"tbnote_spxscb_zks"];//折扣列表
    [AD_MANAGER.caoGaoDic setValue:self.allOrderXiaoShouTuiHuoListCommonParamtersArray forKey:@"tbnote_spxscbs"];//商品列表
    kWeakSelf(self);//autocheck 自动审核 1:是(默认) 0:仅存草稿
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestNoteSpxsSaveNote:mDic success:^(id object) {
        
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        if (autoCheck == 1) {
            
            [weakself showToast:@"销售单保存成功"];
            UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
            JDAllOrderViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
            VC.selectTag1 = 2;
            VC.hidesBottomBarWhenPushed = YES;
            VC.isHidenNaviBar = YES;
            [weakself.navigationController pushViewController:VC animated:YES];
            
        }else{
            [weakself showToast:@"存为草稿成功"];
            JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
            VC.selectTag1 = 2;
            [weakself.navigationController pushViewController:VC animated:YES];
        }

    }];
}


#pragma mark ========== 采购入库单存下单和草稿不通用方法 ==========
-(void)setCaiGouRuKuDanCommonAction:(NSInteger)autoCheck{
    [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.affrimDic[@"dingjinArray"] ? AD_MANAGER.affrimDic[@"dingjinArray"] : @[] forKey:@"tbnote_sprkcb_fks"];//收款列表
    [AD_MANAGER.caoGaoDic setValue:AD_MANAGER.affrimDic[@"zhekouArray"] ? AD_MANAGER.affrimDic[@"zhekouArray"] :@[] forKey:@"tbnote_sprkcb_zks"];//折扣列表
    [AD_MANAGER.caoGaoDic setValue:[self allOrderCaiGouRuKuListCommonParamtersArray] forKey:@"tbnote_sprkcbs"];//商品列表
    kWeakSelf(self);//autocheck 自动审核 1:是(默认) 0:仅存草稿
    NSString * string = [ADTool dicConvertToNSString:AD_MANAGER.caoGaoDic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(autoCheck)}];
    [AD_MANAGER requestCaiGouRuKuSaveAction:mDic success:^(id object) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        [weakself showToast:[@"入库单存为草稿成功" append:object[@"data"]]];
        JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
        VC.selectTag1 = 6;
        [weakself.navigationController pushViewController:VC animated:YES];
    }];
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

    /*
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
    
    */
    
    if (textField.tag-1000 >= 0  && textField.tag-1000 <= 100) {
        NSMutableArray * dingjinArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.affrimDic[@"dingjinArray"]];
        NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:dingjinArray[textField.tag-1000]];
        [muDic setValue:@([textField.text doubleValue]) forKey:CaiGouBOOL ? @"fkje" : @"skje"];
        [dingjinArray replaceObjectAtIndex:textField.tag-1000 withObject:muDic];
        [AD_MANAGER.affrimDic setValue:dingjinArray forKey:@"dingjinArray"];
    }else{
        NSMutableArray * zkArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.affrimDic[@"zhekouArray"]];
        NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:zkArray[textField.tag-3000]];
        [muDic setValue:@([textField.text doubleValue]) forKey:@"je"];
        [zkArray replaceObjectAtIndex:textField.tag-3000 withObject:muDic];
        [AD_MANAGER.affrimDic setValue:zkArray forKey:@"zhekouArray"];
    }

    self.allPriceLbl.text = doubleToNSString([self getNowPrice]);
    [self.view endEditing:YES];
    
    return YES;
   
    
}

@end
