//
//  JDAllOrderViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/1.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAllOrderViewController.h"
#import "JDAllOrderTableViewCell.h"
#import "JDOrder1TableViewController.h"
#import "JDSalesActionViewController.h"
#import "JDYangPinDetailTableViewController.h"
#import "JDSalesAffirmViewController.h"
#import "JDOrderSearchViewController.h"
#import "JDNewAddShouKuanTableViewController.h"
#import "JDSalesTagViewController.h"
#import "JDOrder1FaHuoTableViewController.h"
#import "JDZhiFaDan5TableViewController.h"
@interface JDAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource>{


    NSArray * _paramters1Array;//参数数组
    NSArray * _paramters2Array;//type数组
    NSDictionary * _dic1;
    NSMutableArray * _resultArray;
    NSArray * _titleArray;//title数组
}
@property (nonatomic,strong) NSDictionary *resultDic;
@property (nonatomic,strong) UIImageView* noDataView;

@end

@implementation JDAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _paramters1Array = @[@"/note/xsdd/GetXsddList",
                         @"/note/spck/getspcklist",
                         @"/note/spxs/GetSpxsList",
                         @"/note/ypxs/GetYpxsList",
                         @"/note/xsth/GetXsthList",
                         @"/note/sk/getSkList",
                         @"/note/sprk/getsprklist",
                         @"/note/rkth/getrkthlist",
                         @"/note/fk/GetFkList",
                         @"/note/spzf/list",
                         ];
    _paramters2Array = @[@(-2),@(1),@(2),@(-1)];
    _titleArray = @[@"预定单历史",@"出库单历史",@"销售单历史",@"样品单历史",@"退货单历史",@"收款单历史",@"采购入库单历史",@"采购退货单历史",@"付款单历史",@"直发单历史"];
    _selectTag2 = 0;
    [self setValueTitle];
    _dic1 = @{@"-2":@"全部",
              @"-1":@"已删除",
              @"1":@"草稿",
              @"2":@"已审",
              @"3":@"已财审",
              @"4":@"待发货",
              @"5":@"已完成",
              @"6":@"已审核"};
    _resultArray = [[NSMutableArray alloc]init];
    self.resultDic = [[NSDictionary alloc]init];

}
-(void)setValueTitle{
    [self.titleBtn setTitle:_titleArray[_selectTag1] forState:0];
}
-(void)requestAllOrderList:(NSString *)paramters type:(NSString *)type keywords:(NSString *)keywords{
    NSDictionary * dic;
    NSMutableDictionary * mDic;
    if ([keywords isEqualToString:@""]) {
        dic  = @{@"pno":@"1",@"pagesize":@"500",@"djzt":type};
        mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dic];
        //如果是直发单历史_selectTag2
        if ([paramters isEqualToString:@"/note/spzf/list"]) {
            NSInteger zt = _selectTag2  == 0 ? -2 :
                           _selectTag2  == 1 ? 2 :
                           _selectTag2  == 2 ? 3 :
                           _selectTag2  == 3 ? 1 : 0;
            NSString * string = [ADTool dicConvertToNSString:@{
                @"zt":@(zt),
                                                               @"begindate":@"2018-01-01T00:00:00",
                                                               @"enddate":[NSString currentDateString],
                                                               @"djhm":@"",
                                                               @"mdmc":@"",
                                                               @"khmc":@"",
                                                               @"gysmc":@"",
                                                               @"spvalue":@"",
                                                               @"ys":@"",
                                                               @"djbz":@""
                                                               }];
            dic  = @{@"pageno":@"1",
                     @"pagesize":@"500",
                     @"condition":string
                     };
            
            mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dic];
        }

        
        
    }else{
        dic  = @{@"pno":@"1",@"pagesize":@"500",@"djzt":type,@"keywords":keywords};
        mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dic];
    }
    
    
    kWeakSelf(self);
    [AD_MANAGER requestAllOrderList:mDic success:^(id object) {
        [_resultArray removeAllObjects];
        [_resultArray addObjectsFromArray:object[@"data"][@"list"]];
        [weakself.bottomTableView reloadData];
        
        if (_resultArray.count == 0) {
            [weakself showNoDataImage];
        }else{
            [weakself removeNoDataImage];
        }
        
        [_bottomTableView.mj_header endRefreshing];
        [_bottomTableView.mj_footer endRefreshing];
    } paramters:paramters];
    
}


-(void)showNoDataImage
{
    [_noDataView removeFromSuperview];
    _noDataView = nil;
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"Group 3"]];
    [self.bottomView.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            [_noDataView setFrame:CGRectMake(0, 0,203, 268)];
            [_noDataView setCenterX:obj.centerX];
            [_noDataView setCenterY:obj.centerY - 60];
            [obj addSubview:_noDataView];
        }
    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationController.navigationBar.hidden = YES;
    [self.bottomView removeAllSubviews];
    [self.bottomView addSubview:_bottomTableView];
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    [AD_MANAGER requestSelectKhPage:mDic1 success:^(id str) {
        
    }];
    NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    
    [AD_MANAGER requestSelectSpPage:mDic2 success:^(id str) {}];
    _selectTag2 = 0;
    
//    if (Quan_Xian_order(@"销售订单",@"1")) {
//        _selectTag2 = _selectTag2 > 10 ? 0 : _selectTag2;
//    }else  if (Quan_Xian_order(@"商品出库",@"1")) {
//        _selectTag2 = _selectTag2 > 10 ? 1 : _selectTag2;
//    }else  if (Quan_Xian_order(@"商品销售",@"1")) {
//        _selectTag2 = 2;
//    }else  if (Quan_Xian_order(@"样品销售单",@"1")) {
//        _selectTag2 = 3;
//    }else  if (Quan_Xian_order(@"销售退货",@"1")) {
//        _selectTag2 = 4;
//    }else  if (Quan_Xian_order(@"收款单",@"1")) {
//        _selectTag2 = 5;
//    }else  if (Quan_Xian_order(@"商品入库",@"1")) {
//        _selectTag2 = 6;
//    }else  if (Quan_Xian_order(@"入库退货",@"1")) {
//        _selectTag2 = 7;
//    }else  if (Quan_Xian_order(@"付款单",@"1")) {
//        _selectTag2 = 8;
//    }
    
    
    
    [self.btn1 setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
    [self.btn2 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
    [self.btn3 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
    [self.btn4 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
    
    self.btn1Img.hidden = NO;
    self.btn2Img.hidden = self.btn3Img.hidden = self.btn4Img.hidden = YES;
    [self requestAllOrderList:_paramters1Array[_selectTag1] type:_paramters2Array[0] keywords:@""];

}


#pragma mark ————— 下拉刷新 —————
-(void)headerRereshing{
    [self commonRequest:@""];

}

#pragma mark ————— 上拉刷新 —————
-(void)footerRereshing{

}

#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.bottomView.frame.size.height) style:0];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        _bottomTableView.separatorStyle = 0;
        _bottomTableView.backgroundColor = KClearColor;
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _bottomTableView.mj_header = header;
        
        //底部刷新
//        _bottomTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//        _bottomTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
//        _bottomTableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
//        
//        _bottomTableView.backgroundColor=CViewBgColor;
//        _bottomTableView.scrollsToTop = YES;
//        _bottomTableView.tableFooterView = [[UIView alloc] init];
        
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDAllOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDAllOrderTableViewCell"];
        if ([self.whereCome isEqualToString:@"detail"]) {
            
        }else{
            [self.bottomView addSubview:_bottomTableView];

        }
    }
    return _bottomTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
#define  caigouBool  ([self.titleBtn.titleLabel.text isEqualToString:@"采购入库单历史"] || [self.titleBtn.titleLabel.text isEqualToString:@"采购退货单历史"] || [self.titleBtn.titleLabel.text isEqualToString:@"付款单历史"] )
#define  caigouBool1  ([self.titleBtn.titleLabel.text isEqualToString:@"采购入库单历史"] || [self.titleBtn.titleLabel.text isEqualToString:@"采购退货单历史"] )

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDAllOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDAllOrderTableViewCell" forIndexPath:indexPath];
        NSDictionary * dic = _resultArray[indexPath.row];
    cell.titleLbl.text = caigouBool ? dic[@"gysmc"] :dic[@"khmc"];
    NSString * status = _dic1[NSIntegerToNSString([dic[@"djzt"] integerValue])];
    cell.rightLbl.text = [[[dic[@"djhm"] concate:@"单据:"] append:@"  "] append:status];
    cell.titleImgV.image = [UIImage imageNamed:[dic[@"djzt"] integerValue] == 1 ? @"icon_caogao" : ([dic[@"djzt"] integerValue] == 2 || [dic[@"djzt"] integerValue] == 3)? @"" : @"icon_yishandan"];

    if ([self.titleBtn.titleLabel.text isEqualToString:@"预定单历史"] || [self.titleBtn.titleLabel.text isEqualToString:@"样品单历史"] ) {
        [cell setYangPinAndYuDing:dic titleBtn:self.titleBtn.titleLabel.text];
    }else if([self.titleBtn.titleLabel.text isEqualToString:@"销售单历史"] ||
             [self.titleBtn.titleLabel.text isEqualToString:@"退货单历史"] || caigouBool1 ||[self.titleBtn.titleLabel.text isEqualToString:@"直发单历史"]){
        [cell setXiaoShouDan:dic titleBtn:self.titleBtn.titleLabel.text];
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"收款单历史"] || [self.titleBtn.titleLabel.text isEqualToString:@"付款单历史"]){
        [cell setShouKuanDan:dic titleBtn:self.titleBtn.titleLabel.text];
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"出库单历史"]){
        [cell setChuKuDan:dic titleBtn:@"出库单历史"];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = _resultArray[indexPath.row];
    
    if ([dic[@"djzt"] integerValue] == -1){
        [self showToast:@"订单已删除"];
        return;
    }
    
    if ([self.titleBtn.titleLabel.text isEqualToString:@"预定单历史"]) {
        AD_MANAGER.orderType = YuDingDan;
        if ([dic[@"djzt"] integerValue] == 1) {//草稿
            [AD_SHARE_MANAGER commonYuDingDanTiaozhuan:dic nav:self.navigationController];
        }else if ([dic[@"djzt"] integerValue] == 2){//已审核
            [self cellAShenHeAxtion:dic];
        }
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"样品单历史"]){
        AD_MANAGER.orderType = YangPinDan;
        if ([dic[@"djzt"] integerValue] == 1) {//草稿
            [AD_SHARE_MANAGER commonYangPinDanTiaozhuan:dic nav:self.navigationController];
        }else if ([dic[@"djzt"] integerValue] == 2){//已审核
            [self cellBShenHeAction:dic];
        }
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"销售单历史"]){
       
        AD_MANAGER.orderType = XiaoShouDan;
        if ([dic[@"djzt"] integerValue] == 1) {//草稿
            [AD_SHARE_MANAGER commonXiaoShouDanTiaozhuan:dic nav:self.navigationController];
        }else if ([dic[@"djzt"] integerValue] == 2){//已审核
            [self cellBShenHeAction:dic];
        }
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"退货单历史"]){
        AD_MANAGER.orderType = TuiHuoDan;
        if ([dic[@"djzt"] integerValue] == 1) {//草稿
            [AD_SHARE_MANAGER commonTuiHuoDanTiaozhuan:dic nav:self.navigationController];
        }else if ([dic[@"djzt"] integerValue] == 2){//已审核
            [self cellBShenHeAction:dic];
        }
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"采购入库单历史"]){
        AD_MANAGER.orderType = CaiGouRuKuDan;
        if ([dic[@"djzt"] integerValue] == 1) {//草稿
            [AD_SHARE_MANAGER commonCaiGouRuKuDanTiaozhuan:dic nav:self.navigationController];
        }else if ([dic[@"djzt"] integerValue] == 2){//已审核
            [self cellBShenHeAction:dic];
        }
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"采购退货单历史"]){
        AD_MANAGER.orderType = CaiGouTuiHuoDan;
        if ([dic[@"djzt"] integerValue] == 1) {//草稿
            [AD_SHARE_MANAGER commonCaiGouTuiHuoDanTiaozhuan:dic nav:self.navigationController];
        }else if ([dic[@"djzt"] integerValue] == 2){//已审核
            [self cellBShenHeAction:dic];
        }
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"直发单历史"]){
    
        AD_MANAGER.orderType = ZhiFaDan;
        if ([dic[@"djzt"] integerValue] == 1) {//草稿
            [AD_SHARE_MANAGER commonZhiFaDanTiaozhuan:dic nav:self.navigationController];
//            [self showToast:@"直发单暂未开通草稿功能"];
        }else if ([dic[@"djzt"] integerValue] == 2){//已审核
            [self cellBShenHeAction:dic];
        }
    }
    else if ([self.titleBtn.titleLabel.text isEqualToString:@"收款单历史"]){
        AD_MANAGER.orderType = ShouKuanDan;
        REMOVE_ALL_CACHE;
        [AD_MANAGER.affrimDic setValue:dic[@"khmc"] forKey:@"khmc"];
        [AD_MANAGER.affrimDic setValue:dic[@"jsrmc"] forKey:@"jsrmc"];
        [self cellECommon:dic[@"djhm"] djzt:[dic[@"djzt"] integerValue]];
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"付款单历史"]){
        AD_MANAGER.orderType = FuKuanDan;
        REMOVE_ALL_CACHE;
        [AD_MANAGER.affrimDic setValue:dic[@"gysmc"] forKey:@"gysmc"];
        [self cellECommon:dic[@"djhm"] djzt:[dic[@"djzt"] integerValue]];
    }
    else if ([self.titleBtn.titleLabel.text isEqualToString:@"出库单历史"]){
        AD_MANAGER.orderType = ChuKuDan;
        if ([dic[@"djzt"] integerValue] == 1) {//草稿
            kWeakSelf(self);
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":dic[@"ddhm"]}];
            [AD_MANAGER requestxsddShowNote:mDic success:^(id object) {
                NSDictionary * resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];

                UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
                JDOrder1FaHuoTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDOrder1FaHuoTableViewController"];
                VC.hidesBottomBarWhenPushed = YES;
                VC.objectDic = [[NSMutableDictionary alloc]initWithDictionary:resultDic];
                VC.noteno = dic[@"djhm"];
                [weakself.navigationController pushViewController:VC animated:YES];
            }];
        }else if ([dic[@"djzt"] integerValue] == 2){//已审核
            [self cellBShenHeAction:dic];
        }
    }
    else if ([self.titleBtn.titleLabel.text isEqualToString:@"直发单历史"]){
        AD_MANAGER.orderType = ZhiFaDan;
        if ([dic[@"djzt"] integerValue] == 1) {//草稿

        }else if ([dic[@"djzt"] integerValue] == 2){//已审核
            [self cellBShenHeAction:dic];
        }
    }
    
    
    
    
    
    
}
-(void)cellECommon:(NSString *)noteno djzt:(NSInteger)djzt{
    NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDNewAddShouKuanTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDNewAddShouKuanTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = noteno;
    VC.djzt = djzt;
    if (ORDER_ISEQUAl(ShouKuanDan)) {
        [AD_MANAGER requestSelectKhPage:mDic2 success:^(id str) {//客户信息请求
            [self.navigationController pushViewController:VC animated:YES];
        }];
    }else if (ORDER_ISEQUAl(FuKuanDan)){
        [AD_MANAGER requestGongYingShangListAction:mDic2 success:^(id str) {//供应商信息请求
            [self.navigationController pushViewController:VC animated:YES];
        }];
    }

 

}


//点击预定单已审核
-(void)cellAShenHeAxtion:(NSDictionary *)dic{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDOrder1TableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDOrder1TableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = dic[@"djhm"];
    [self.navigationController pushViewController:VC animated:YES];
}
//点击样品单已审核
-(void)cellBShenHeAction:(NSDictionary *)dic{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDYangPinDetailTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDYangPinDetailTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.noteno = dic[@"djhm"];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ========== 四个按钮 ==========
- (IBAction)allBtnAction:(UIButton *)btn{
    switch (btn.tag) {
        case 30001:{//全部
            
            _selectTag2 = 0;
            [self commonRequest:@""];
            [self.btn1 setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
            [self.btn2 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn3 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn4 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            
            self.btn1Img.hidden = NO;
            self.btn2Img.hidden = self.btn3Img.hidden = self.btn4Img.hidden = YES;
        }
            break;
        case 30002:{//草稿
         
            _selectTag2 = 1;
             [self commonRequest:@""];
            [self.btn2 setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
            [self.btn1 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn3 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn4 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            self.btn2Img.hidden = NO;
            self.btn1Img.hidden = self.btn3Img.hidden = self.btn4Img.hidden = YES;
        }
            
            break;
        case 30003:{//已审核
          
            
            
            _selectTag2 = 2;
             [self commonRequest:@""];
            [self.btn3 setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
            [self.btn1 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn2 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn4 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            self.btn3Img.hidden = NO;
            self.btn2Img.hidden = self.btn1Img.hidden = self.btn4Img.hidden = YES;
        }
            
            break;
        case 30004:{//已删除
            _selectTag2 = 3;
             [self commonRequest:@""];
            [self.btn4 setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
            [self.btn1 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn3 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn2 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];            self.btn4Img.hidden = NO;
            self.btn2Img.hidden = self.btn3Img.hidden = self.btn1Img.hidden = YES;
        }
            
            break;
        default:
            break;
    }
}

#pragma mark ========== 头部 ==========
- (IBAction)titleBtnAction:(id)sender {
    
//    if (indexPath.row == 0 && !Quan_Xian_order(@"销售订单",@"1")) {
//        return 0;
//    }else  if (indexPath.row == 1 && !Quan_Xian_order(@"商品出库",@"1")) {
//        return 0;
//    }else  if (indexPath.row == 2 && !Quan_Xian_order(@"商品销售",@"1")) {
//        return 0;
//    }else  if (indexPath.row == 3 && !Quan_Xian_order(@"样品销售单",@"1")) {
//        return 0;
//    }else  if (indexPath.row == 4 && !Quan_Xian_order(@"销售退货",@"1")) {
//        return 0;
//    }else  if (indexPath.row == 5 && !Quan_Xian_order(@"收款单",@"1")) {
//        return 0;
//    }else  if (indexPath.row == 6 && !Quan_Xian_order(@"商品入库",@"1")) {
//        return 0;
//    }else  if (indexPath.row == 7 && !Quan_Xian_order(@"入库退货",@"1")) {
//        return 0;
//    }else  if (indexPath.row == 8 && !Quan_Xian_order(@"付款单",@"1")) {
//        return 0;
//    }
    
    kWeakSelf(self);
    [LEEAlert actionsheet].config
    .LeeTitle(nil)
    .LeeAction(@"预订单历史", ^{
        if (!Quan_Xian_order(@"销售订单",@"1")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"销售订单",@"1")];
        }else{
            _selectTag1 = 0;
            [weakself commonRequest:@""];
        }
        
        
     })
    .LeeAction(@"出库单历史", ^{
        if (!Quan_Xian_order(@"商品出库",@"1")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"商品出库",@"1")];
        }else{
            _selectTag1 = 1;
            [weakself commonRequest:@""];
        }
     
    })
    .LeeAction(@"销售单历史", ^{
        if (!Quan_Xian_order(@"商品销售",@"1")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"商品出库",@"1")];
        }else{
            _selectTag1 = 2;
            [weakself commonRequest:@""];
        }
 
    })
    .LeeAction(@"样品单历史", ^{
        if (!Quan_Xian_order(@"样品销售单",@"1")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"样品销售单",@"1")];
        }else{
            _selectTag1 = 3;
            [weakself commonRequest:@""];
        }
    
    })
    .LeeAction(@"退货单历史", ^{
        if (!Quan_Xian_order(@"销售退货",@"1")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"销售退货",@"1")];
        }else{
            _selectTag1 = 4;
            [weakself commonRequest:@""];
        }

    })
    .LeeAction(@"收款单历史", ^{
        if (!Quan_Xian_order(@"收款单",@"1")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"收款单",@"1")];
        }else{
            _selectTag1 = 5;
            [weakself commonRequest:@""];
        }

    })
    .LeeAction(@"采购入库单历史", ^{
        if (!Quan_Xian_order(@"商品入库",@"1")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"商品入库",@"1")];
        }else{
            _selectTag1 = 6;
            [weakself commonRequest:@""];
        }
    
    })
    .LeeAction(@"采购退货单历史", ^{
        if (!Quan_Xian_order(@"入库退货",@"1")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"入库退货",@"1")];
        }else{
            _selectTag1 = 7;
            [weakself commonRequest:@""];
        }

    })
    .LeeAction(@"付款单历史", ^{
        if (!Quan_Xian_order(@"付款单",@"1")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"付款单",@"1")];
        }else{
            _selectTag1 = 8;
            [weakself commonRequest:@""];
        }
    })
    .LeeAction(@"直发单历史", ^{
  
        _selectTag1 = 9;
        [weakself commonRequest:@""];
    })
    .LeeCancelAction(@"取消", ^{

    })

    .LeeCancelAction(@"取消", ^{
        
    })
    .LeeShow();
}

#pragma mark ========== 新建 ==========
- (IBAction)buildBtnAction:(id)sender {
    if ([self.titleBtn.titleLabel.text isEqualToString:@"预定单历史"]) {
        pushYuDingDan(self.navigationController);
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"样品单历史"]){
        pushYangPinDan(self.navigationController);
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"退货单历史"]){
        pushTuiHuoDan(self.navigationController);
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"销售单历史"]){
        pushXiaoShouDan(self.navigationController);
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"采购入库单历史"]){
        pushCaiGouRuKuDan(self.navigationController);
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"采购退货单历史"]){
        pushCaiGouTuiHuoDan(self.navigationController);
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"收款单历史"]){
        pushShouKuanDan((MainTabBarController *)self.presentingViewController);
    }else if ([self.titleBtn.titleLabel.text isEqualToString:@"付款单历史"]){
       pushFuKuanDan((MainTabBarController *)self.presentingViewController);
    }

}
#pragma mark ========== 返回 ==========
- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========== 查询 ==========
- (IBAction)searchBtnAction:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDOrderSearchViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDOrderSearchViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)commonRequest:(NSString *)keywords{
    [self requestAllOrderList:_paramters1Array[_selectTag1] type:_paramters2Array[_selectTag2] keywords:keywords];
    [self setValueTitle];
}
@end
