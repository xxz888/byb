//
//  JDZhiFaDan6ViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/23.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDZhiFaDan6ViewController.h"
#import "JDCMFirstTableViewCell.h"
#import "JDSalesView.h"
#import "JDPayWayView.h"
#import "SelectedListView.h"
#import "JDSelectSpModel.h"
#import "JDAddColorModel.h"
#import "JDAllOrderViewController.h"
#import "JDSuccessVCViewController.h"
@interface JDZhiFaDan6ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,copy) UITableView * underTableView;


@end

@implementation JDZhiFaDan6ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收银台";
    
    
    self.view.backgroundColor = JDRGBAColor(245, 247, 250);
    self.allPriceLbl.text = self.allPrice;
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
//    self.allPriceLbl.text = doubleToNSString([self getNowPrice]);
    
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
//    self.allPriceLbl.text = doubleToNSString([self willComeIn]);
}
-(void)requestData{
    kWeakSelf(self);
    
    if (aa.tbnote_spzfcb_sks && aa.tbnote_spzfcb_sks.count != 0
        && aa.tbnote_spzfcb_khzks && aa.tbnote_spzfcb_khzks.count != 0) {
        [self.underTableView reloadData];

    }else{
        aa.tbnote_spzfcb_sks = [[NSMutableArray alloc]init];
        aa.tbnote_spzfcb_khzks = [[NSMutableArray alloc]init];
        
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
        //支付方式
        [AD_MANAGER requestSelectZH:mDic success:^(id object) {
            [aa.tbnote_spzfcb_sks removeAllObjects];
            for (NSMutableDictionary * dic in object[@"data"]) {
                JDModel3 * model3 = [[JDModel3 alloc]init];
                [model3 setValuesForKeysWithDictionary:dic];
                [aa.tbnote_spzfcb_sks addObject:model3];
            }
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
            //优惠方式
            [AD_MANAGER requestSelectZklx:mDic success:^(id object) {
                [aa.tbnote_spzfcb_khzks removeAllObjects];
                for (NSMutableDictionary * dic in object[@"data"]) {
                    JDModel2 * model2 = [[JDModel2 alloc]init];
                    [model2 setValuesForKeysWithDictionary:dic];
                    [aa.tbnote_spzfcb_khzks addObject:model2];
                }
                [weakself.underTableView reloadData];
            }];
        }];
    }

    
}
#pragma mark ========== 创建tablevidew ==========
-(UITableView *)underTableView {
    if (!_underTableView) {
        _underTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.underView.frame.size.width, KScreenHeight - 50 - kTopHeight - kTabBarHeight) style:UITableViewStyleGrouped];
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
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 2) {
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 112)];
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(100, 100, 113, 30);
//        btn.center = view.center;
//        [btn setTitle:@"+ 添加优惠" forState:UIControlStateNormal];
//        [btn setTitleColor:JDRGBAColor(0, 163, 255) forState:UIControlStateNormal];
//        ViewBorderRadius(btn, 5, 0.5, JDRGBAColor(0, 163, 255));
//        btn.font = [UIFont systemFontOfSize:13];
//        btn.tag = section+100;
//        [btn addTarget:self action:@selector(addsalesBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:btn];
//        return view;
//    }else{
//        return nil;
//    }
//}

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
//-(void)addsalesBtnclicked:(UIButton *)btn{
//
//    NSMutableArray * zkArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.affrimDic[@"zhekouArray"]];
//    NSMutableDictionary * zkDic = [[NSMutableDictionary alloc]init];
//    [zkDic setValue:AD_MANAGER.selectZHlxArray[0][@"zklxmc"] forKey:@"zklxmc"];
//    [zkArray addObject:zkDic];
//    [AD_MANAGER.affrimDic setValue:zkArray forKey:@"zhekouArray"];
//    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:2];
//    [self.underTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //商品信息
    if (indexPath.section == 0) {
        JDCMFirstTableViewCell * fcell = [tableView dequeueReusableCellWithIdentifier:@"JDCMFirstTableViewCell" forIndexPath:indexPath];
        fcell.allPrice.text = self.allPrice;
        
        fcell.lbl1.text =  CCHANGE_DOUBLE(self.clientModel.yszk);
        fcell.lbl2.text =  [CCHANGE_DOUBLE(self.clientModel.yszk) replaceAll:@"¥" target:@"¥-"];
        
        return fcell;
    //支付方式
    }else if (indexPath.section == 1){
        UITableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell1.selectionStyle = 0;
        [cell1.contentView removeAllSubviews];
        
        NSArray * imgArr =  @[@"icon_xianjin",@"icon_wangyin",@"icon_zhifubao",@"icon_weixinzhifu",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita"];
        for (NSInteger i = 0 ; i < [aa.tbnote_spzfcb_sks count]; i++) {
            JDPayWayView * view = (JDPayWayView *)[self payWayView];
            view.tag = 100+i;
            view.pagWayTf.tag = 1000+i;
            view.pagWayTf.delegate = self;
            view.frame = CGRectMake(0, 50 * i, kScreenWidth, 50);
            NSInteger index = 0;
            JDModel3 * model3 = aa.tbnote_spzfcb_sks[i];
            if (model3.zhlx > imgArr.count) {
                index = 5;
            }else{
                index = model3.zhlx;
            }
            view.payWayImg.image =[UIImage imageNamed:imgArr[index]];
            view.pagWayName.text = model3.zhmc;
            view.pagWayTf.text = model3.skje;
            
            
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
        
        
        
        for (NSInteger i = 0 ; i < aa.tbnote_spzfcb_khzks.count; i++) {
            JDSalesView * view = (JDSalesView *)[self salesView];
            view.priceTf.tag = 3000 + i;
            view.sid = 1;
            view.priceTf.delegate = self;
            view.frame = CGRectMake(0, 105 * i, kScreenWidth, 105);
            
            JDModel2 * model2 = aa.tbnote_spzfcb_khzks[i];
            view.priceTf.text = model2.je;
            [view.saleswayBtn setTitle:model2.zklxmc forState:0];
            view.wayTitltLbl.text = [model2.zklxmc append:@"金额"];
            
            
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
    return indexPath.section == 0 ? 117 : indexPath.section == 1 ? [aa.tbnote_spzfcb_sks count] * 50 : ([aa.tbnote_spzfcb_khzks count] * 105);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
//存为草稿
- (IBAction)saveDraftAction:(id)sender {
    [self setXiaoShouDanAction:0];
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
    [self setXiaoShouDanAction:1];
    
}
#pragma mark ========== 销售单请求 ==========
-(void)setXiaoShouDanAction:(NSInteger)autoCheck{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    LoginModel * loginModel = AD_USERDATAARRAY;

    //得到其他三个没用的数组和其他没用的参数
    [self setOtherData:dic];
    
    [dic setValue:[NSString currentDateStringyyyyMMdd] forKey:@"rzrq"];
    [dic setValue:@([loginModel.mdid intValue]) forKey:@"mdid"];
    [dic setValue:@([aa.ckid intValue]) forKey:@"ckid"];
    [dic setValue:@([aa.gysid intValue]) forKey:@"gysid"];
    [dic setValue:@([aa.khid intValue]) forKey:@"khid"];
    [dic setValue:@([aa.ywyid intValue]) forKey:@"ywyid"];
    [dic setValue:aa.shr forKey:@"shr"];
    [dic setValue:@"" forKey:@"djbz"];
    

    //得到tbnote_spzfcbs参数的数组
    [dic setValue:[self getTbnote_spzfcbsArr] forKey:@"tbnote_spzfcbs"];
    //得到收款tbnote_spzfcb_sks的数组
    [dic setValue:[self getTbnote_spzfcb_sks] forKey:@"tbnote_spzfcb_sks"];
    //得到收款tbnote_spzfcb_sks的数组
    [dic setValue:[self getTbnote_spzfcb_khzks] forKey:@"tbnote_spzfcb_khzks"];
    
    
 
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@(1)}];
    kWeakSelf(self);
    [AD_MANAGER requestNoteSpzfSaveNote:mDic success:^(id object) {
        [weakself showToast:@"直发单保存成功"];
        UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        JDAllOrderViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
        VC.selectTag1 = 9;
        VC.hidesBottomBarWhenPushed = YES;
        VC.isHidenNaviBar = YES;
        [weakself.navigationController pushViewController:VC animated:YES];
    }];
}
-(void)setOtherData:(NSMutableDictionary*)dic{
    [dic setValue:@"" forKey:@"djhm"];
    [dic setValue:@"" forKey:@"rdrq"];
    [dic setValue:@"" forKey:@"mdbm"];
    [dic setValue:@"" forKey:@"mdmc"];
    [dic setValue:@"" forKey:@"ckbm"];
    [dic setValue:@"" forKey:@"ckmc"];
    [dic setValue:@"" forKey:@"gysbm"];
    [dic setValue:@"" forKey:@"gysmc"];
    [dic setValue:@"" forKey:@"khbm"];
    [dic setValue:@"" forKey:@"khmc"];
    [dic setValue:@"" forKey:@"ywybm"];
    [dic setValue:@"" forKey:@"ywymc"];
    [dic setValue:@"" forKey:@"shdz"];
    [dic setValue:@(0) forKey:@"wlgsid"];
    [dic setValue:@"" forKey:@"wlgsbm"];
    [dic setValue:@"" forKey:@"wlgsmc"];
    [dic setValue:@"" forKey:@"ydhm"];
    [dic setValue:@"" forKey:@"wltp"];
    [dic setValue:@(0) forKey:@"zdrid"];
    [dic setValue:@"" forKey:@"zdrbm"];
    [dic setValue:@"" forKey:@"zdrmc"];
    [dic setValue:@(0) forKey:@"shrid"];
    [dic setValue:@"" forKey:@"shrbm"];
    [dic setValue:@"" forKey:@"shrmc"];
    [dic setValue:@(0) forKey:@"cwshrid"];
    [dic setValue:@"" forKey:@"cwshrbm"];
    [dic setValue:@"" forKey:@"cwshrmc"];
    [dic setValue:@"" forKey:@"bjmc"];
    [dic setValue:@(0) forKey:@"dycs"];
    [dic setValue:@(0) forKey:@"djzt"];
    [dic setValue:@(0) forKey:@"yszk"];
    [dic setValue:@(0) forKey:@"zdysk"];
    [dic setValue:@[@{@"dnxh":@(0),@"fyid":@(0),@"fymc":@"",@"je":@(0.00),@"bz":@""}] forKey:@"tbnote_spzfcb_khfys"];
    [dic setValue:@[@{@"dnxh":@(0),@"zhid":@(0),@"zhmc":@"",@"fkje":@(0.00),@"bz":@""}] forKey:@"tbnote_spzfcb_sks"];
    [dic setValue:@[@{@"dnxh":@(0),@"zklxid":@(0),@"zklxbm":@"",@"zklxmc":@"",@"je":@(0.00),@"bz":@""}] forKey:@"tbnote_spzfcb_khzks"];
}
-(NSMutableArray *)getTbnote_spzfcb_khzks{
    //商品的字典
    NSMutableArray * tbnote_spzfcb_khzks = [[NSMutableArray alloc]init];

    for (JDModel2 * model2 in aa.tbnote_spzfcb_khzks) {
        //1、商品单个的字典
        NSMutableDictionary * tbnote_spzfcb_khzksDic = [[NSMutableDictionary alloc]init];
        
        [tbnote_spzfcb_khzksDic setValue:@(0) forKey:@"dnxh"];
        [tbnote_spzfcb_khzksDic setValue:@"" forKey:@"zklxmc"];
        [tbnote_spzfcb_khzksDic setValue:@"" forKey:@"zklxbm"];
        [tbnote_spzfcb_khzksDic setValue:@"" forKey:@"bz"];
        [tbnote_spzfcb_khzksDic setValue:@([model2.zklxid intValue]) forKey:@"zklxid"];
        [tbnote_spzfcb_khzksDic setValue:@([model2.je intValue]) forKey:@"je"];
        [tbnote_spzfcb_khzks addObject:tbnote_spzfcb_khzksDic];
    }
    return tbnote_spzfcb_khzks;
}
-(NSMutableArray *)getTbnote_spzfcb_sks{
    //商品的字典
    NSMutableArray * tbnote_spzfcb_sks = [[NSMutableArray alloc]init];
    //1、商品单个的字典
   
    
    for (JDModel3 * model3 in aa.tbnote_spzfcb_sks) {
        NSMutableDictionary * tbnote_spzfcb_sksDic = [[NSMutableDictionary alloc]init];
        [tbnote_spzfcb_sksDic setValue:@(0) forKey:@"dnxh"];
        [tbnote_spzfcb_sksDic setValue:@"" forKey:@"zhmc"];
        [tbnote_spzfcb_sksDic setValue:@"" forKey:@"bz"];
        [tbnote_spzfcb_sksDic setValue:@([model3.zhid intValue]) forKey:@"zhid"];
        [tbnote_spzfcb_sksDic setValue:@([model3.skje intValue]) forKey:@"skje"];
        [tbnote_spzfcb_sks addObject:tbnote_spzfcb_sksDic];
    }
    return tbnote_spzfcb_sks;
}

-(NSMutableArray *)getTbnote_spzfcbsArr{
    //商品的字典
    NSMutableArray * tbnote_spzfcbs = [[NSMutableArray alloc]init];

    for (NSDictionary * dic in NEW_AffrimDic_SectionArray) {
        NSArray * arr = [dic allKeys];
        NSString * key = arr[0];
        NSDictionary * spDic = dic[key];
        //得到商品数组
 

        JDSelectSpModel * spModel = spDic[@"sp"];
        
        
        
        
        
        
        for (NSDictionary * dic1 in spDic[@"color"]) {
            //1、商品单个的字典
            NSMutableDictionary * tbnote_spzfcbsDic = [[NSMutableDictionary alloc]init];
            [tbnote_spzfcbsDic setValue:@(spModel.spid) forKey:@"spid"];
            [tbnote_spzfcbsDic setValue:@(0) forKey:@"dnxh"];
            [tbnote_spzfcbsDic setValue:@"" forKey:@"sphh"];
            [tbnote_spzfcbsDic setValue:@"" forKey:@"spmc"];
            [tbnote_spzfcbsDic setValue:@(0) forKey:@"cdid"];
            [tbnote_spzfcbsDic setValue:@"" forKey:@"cdbm"];
            [tbnote_spzfcbsDic setValue:@"" forKey:@"cdmc"];
            
            [tbnote_spzfcbsDic setValue:@"" forKey:@"sh"];
            [tbnote_spzfcbsDic setValue:@"" forKey:@"ys"];
            [tbnote_spzfcbsDic setValue:@"" forKey:@"jldw"];
            [tbnote_spzfcbsDic setValue:@"" forKey:@"fjldw"];
            [tbnote_spzfcbsDic setValue:@(1) forKey:@"spps"];
            [tbnote_spzfcbsDic setValue:@(0) forKey:@"spfsl"];
            [tbnote_spzfcbsDic setValue:@(0) forKey:@"jjfs"];
            
            [tbnote_spzfcbsDic setValue:@(0) forKey:@"jhkc"];
            [tbnote_spzfcbsDic setValue:@(0) forKey:@"jhdj"];//进货单价
            [tbnote_spzfcbsDic setValue:@(0) forKey:@"jhje"];//进货金额 这两个没有要求是吧
            [tbnote_spzfcbsDic setValue:@(0)forKey:@"xskc"];
            [tbnote_spzfcbsDic setValue:@"" forKey:@"khkh"];
            [tbnote_spzfcbsDic setValue:@"" forKey:@"bz"];
            
            
            //得到颜色数组
            JDAddColorModel * colorModel = dic1[@"model"];
            [tbnote_spzfcbsDic setValue:colorModel.sh forKey:@"sh"];
            double xsdj = colorModel.saveXiaoJiaPrice ? [colorModel.saveXiaoJiaPrice doubleValue] : colorModel.xsdj;
            [tbnote_spzfcbsDic setValue:@(xsdj) forKey:@"xsdj"];
            
            //商品匹数数组
            for (NSString * spsl in dic1[@"colArray"]) {
                [tbnote_spzfcbsDic setValue:@([spsl intValue]) forKey:@"spsl"];
                [tbnote_spzfcbsDic setValue:@(xsdj * [spsl intValue]) forKey:@"xsje"];
                //遍历完一次加一次
                [tbnote_spzfcbs addObject:tbnote_spzfcbsDic];
            }
        }
        
        
        
        
    }
    return tbnote_spzfcbs;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldShouldReturn:textField];
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //这个范围内是支付方式
    if (textField.tag >= 1000 && textField.tag < 1100) {
        JDModel3 * model = aa.tbnote_spzfcb_sks[textField.tag-1000];
        model.skje = textField.text;
        [aa.tbnote_spzfcb_sks replaceObjectAtIndex:textField.tag-1000 withObject:model];
    }else if (textField.tag >= 3000 && textField.tag < 3100) {
        JDModel2 * model = aa.tbnote_spzfcb_khzks[textField.tag-3000];
        model.je = textField.text;
        [aa.tbnote_spzfcb_khzks replaceObjectAtIndex:textField.tag-3000 withObject:model];

    }
    
//    if (textField.tag-1000 >= 0  && textField.tag-1000 <= 100) {
//        NSMutableArray * dingjinArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.affrimDic[@"dingjinArray"]];
//        NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:dingjinArray[textField.tag-1000]];
//        [muDic setValue:@([textField.text doubleValue]) forKey:CaiGouBOOL ? @"fkje" : @"skje"];
//        [dingjinArray replaceObjectAtIndex:textField.tag-1000 withObject:muDic];
//        [AD_MANAGER.affrimDic setValue:dingjinArray forKey:@"dingjinArray"];
//    }else{
//        NSMutableArray * zkArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.affrimDic[@"zhekouArray"]];
//        NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:zkArray[textField.tag-3000]];
//        [muDic setValue:@([textField.text doubleValue]) forKey:@"je"];
//        [zkArray replaceObjectAtIndex:textField.tag-3000 withObject:muDic];
//        [AD_MANAGER.affrimDic setValue:zkArray forKey:@"zhekouArray"];
//    }
    
//    self.allPriceLbl.text = doubleToNSString([self getNowPrice]);
    [self.view endEditing:YES];
    
    return YES;
    
    
}

@end
