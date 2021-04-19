//
//  JDOrder1FaHuoTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDOrder1FaHuoTableViewController.h"
#import "JDOrder1TableViewCell.h"
#import "JDFooterView.h"
#import "JDOrder1FaHuoTableViewCell.h"
#import "SelectedListView.h"
#import "JDSelectYgModel.h"
#import "JDAddCountCollectionViewCell.h"
#import "JDOrderDetailTableViewController.h"
#import "JDYangPinDetailTableViewController.h"
#import "YBPopupMenu.h"
#import "JDAllOrderViewController.h"
@interface JDOrder1FaHuoTableViewController ()<JDCellTfChangeDelegate,YBPopupMenuDelegate>{
    NSMutableArray * _sectionArray;
    NSMutableArray * _rowHArray;
    NSMutableArray * shrArray;
    NSMutableArray * _msArray;
    NSMutableArray * _saveSpArray;
    NSString * _danweiStr;
    NSMutableArray * _shridArray;
    long  _shrid;

}
@property(nonatomic,strong)JDFooterView * footerView;
@property(nonatomic,copy)UICollectionView * addCountCollectionView;

@end

@implementation JDOrder1FaHuoTableViewController


-(void)viewWillDisappear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    _sectionArray = [[NSMutableArray alloc]init];
    _saveSpArray = [[NSMutableArray alloc]init];
    _shridArray = [[NSMutableArray alloc]init];
    
    [_saveSpArray removeAllObjects];
    for (NSInteger i = 0 ; i<[self.objectDic[@"tbnote_xsddcbs"] count]; i++) {
        [_saveSpArray addObject:@{NSIntegerToNSString(i):@[]}];
    }

    self.automaticallyAdjustsScrollViewInsets = NO;

    
    _rowHArray = [[NSMutableArray alloc]init];
    shrArray = [[NSMutableArray alloc]init];
    _msArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i< [self.objectDic[@"tbnote_xsddcbs"] count]; i++) {
         [_rowHArray addObject:@300];
    }
    self.title = @"出库单确认";
    [self.tableView registerNib:[UINib nibWithNibName:@"JDOrder1FaHuoTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDOrder1FaHuoTableViewCell"];
    [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:nil];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self requestData];
    
    [self UIData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [_saveSpArray removeAllObjects];
    for (NSInteger i = 0 ; i<[self.objectDic[@"tbnote_xsddcbs"] count]; i++) {
        [_saveSpArray addObject:@{NSIntegerToNSString(i):@[]}];
    }
}
-(void)UIData{
    [self.btn1 setTitle:_objectDic[@"khmc"] forState:0];
    [self.btn2 setTitle:_objectDic[@"ckmc"] forState:0];
    [self.btn3 setTitle:@"未发货" forState:0];

}
-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary* mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    [AD_MANAGER requestSelectShrPage:mDic2 success:^(id object) {
        [weakself.btn5 setTitle:object[@"data"][0][@"shrmc"] forState:0];
        _shrid = [object[@"data"][0][@"shrid"] longValue];
        for (NSDictionary * dic in object[@"data"]) {
            [shrArray addObject:dic[@"shrmc"]];
            [_shridArray addObject:@([dic[@"shrid"] longValue])];
        }
        
    }];
}
#define TITLES @[@"草稿",@"提交",@"打印",@"删单"]
-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:TITLES icons:nil menuWidth:120 delegate:self];
}
#pragma mark - 右上角更多的小弹框
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (index == 0) {//草稿
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
        VC.selectTag1 = 1;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (index == 1){//提交
        [self saveChuKuDan];
    }else if (index == 2){
            AD_MANAGER.noteno = self.noteno;
        [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
    }else{
        kWeakSelf(self);
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":self.noteno}];
        [AD_MANAGER requestDelChuKuDan:mDic success:^(id object) {
            [weakself showToast:@"删除订单成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [self.objectDic[@"tbnote_xsddcbs"] count];//_sectionArray.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_dizhi"]];
        imageView.frame = CGRectMake(0, 0, kScreenWidth, 3);
        [view addSubview:imageView];
        //titile
        UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 30)];
        HeaderLabel.backgroundColor = JDRGBAColor(247, 249, 251);
        HeaderLabel.font = [UIFont boldSystemFontOfSize:13];
        HeaderLabel.textColor = JDRGBAColor(153, 153, 153);
        HeaderLabel.text = @"     本次发货信息";
        [view addSubview:HeaderLabel];
        
        
        
        
        return view;
    }
    return  [super tableView:tableView viewForHeaderInSection:section];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }
    return 0;
}
#pragma mark ========== 尾视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        view.backgroundColor = KClearColor;
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"JDFooterView" owner:self options:nil];
        self.footerView = [nib objectAtIndex:0];
        self.footerView.frame = CGRectMake(0, 0, KScreenWidth, 50);
        [view addSubview:self.footerView];
        
        [self footerViewValue];

        UIButton * btn1 = [self.footerView viewWithTag:30002];
        btn1.hidden = YES;
        kWeakSelf(self);
        self.footerView.bt2Block = ^{
            [weakself saveChuKuDan];
        };
        return view;
    }
    return [super tableView:tableView viewForFooterInSection:section];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 2 ? 50 : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.section == 1) {
            NSInteger i = ([_saveSpArray[indexPath.row][NSIntegerToNSString(indexPath.row)] count] + 3 - 1) / 3 ;
            return 40 * i + 300;
        }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSDictionary * dic = _objectDic[@"tbnote_xsddcbs"][indexPath.row];

        JDOrder1FaHuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDOrder1FaHuoTableViewCell" forIndexPath:indexPath];
        cell.addMsBtn.tag = 500+indexPath.row;
        cell.msTf.tag = 1000+indexPath.row;
        cell.titleLbl.text = [NSString stringWithFormat:@"%@(%@)",dic[@"spmc"],dic[@"sphh"]];
        cell.lbl1.text = NSIntegerToNSString([dic[@"sh"] integerValue]);
        
        NSString * danwei = [dic[@"jjfs"] integerValue] == 0 ? dic[@"jldw"] : dic[@"fjldw"];
        cell.lbl2.text =  [NSString stringWithFormat:@"%ld匹  %@%@",[dic[@"xsps"] integerValue],CCHANGE_OTHER(dic[@"xssl"]),danwei];
        cell.lbl3.text = [NSString stringWithFormat:@"%ld匹  %@%@",[dic[@"xsps"] integerValue] - [dic[@"ddps"] integerValue] ,CCHANGE_OTHER_DOUBLE([dic[@"xssl"] doubleValue] - [dic[@"ddsl"] doubleValue]),danwei];
        cell.lbl4.text = [CCHANGE_OTHER(dic[@"xssl"]) append:danwei];
        cell.lbl5.text = CCHANGE_OTHER(dic[@"cksl"]);
        cell.countDelegate = self;
        cell.danweiStr = danwei;
        cell.price = [dic[@"xsdj"] doubleValue];
        cell.danweiLbl.text = danwei;
        [cell setCellDic:dic];
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
//点击增加按钮，把cell上的值传过来
-(void)countChangeAction:(UITextField *)tf array:(NSMutableArray *)array{
    [self commonAction:tf array:array];
}

//删除的红叉
-(void)delChangeAction:(UITextField *)tf array:(NSMutableArray *)array{
    [self commonAction:tf array:array];
}
-(void)commonAction:(UITextField *)tf array:(NSMutableArray *)array{
    // 获取'textfield'所在的cell
    JDOrder1FaHuoTableViewCell * cell = (JDOrder1FaHuoTableViewCell *)[[tf superview] superview] ;
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //找到对应的字典，重新赋值
    [_saveSpArray replaceObjectAtIndex:indexPath.row withObject:@{NSIntegerToNSString(indexPath.row):array}];
    self.footerView.lbl1.text = @"总计";
    [self footerViewValue];
    
    
    kWeakSelf(self);
    [UIView performWithoutAnimation:^{
        [weakself.tableView beginUpdates];
        [weakself.tableView endUpdates];
    }];

}
-(void)footerViewValue{
    
    
    
    UILabel * lbl1 = [self.footerView viewWithTag:30003];
    UILabel * lbl2 = [self.footerView viewWithTag:30004];
    lbl1.text = @"总计";
    double allallPrice = 0;

    for (NSInteger i = 0; i<[self.objectDic[@"tbnote_xsddcbs"] count]; i++) {
        double allPrice = 0;
        NSArray * arr1 = _saveSpArray[i][NSIntegerToNSString(i)];
        for (NSInteger k = 0; k < arr1.count ; k++) {
            NSString * key = @"";
            if ([self.objectDic[@"jjfs"] integerValue] == 0) {
                key = @"xssl";
            }else{
                key = @"xsfsl";
            }
            double count = [arr1[k][key] doubleValue];
            allPrice += count * [self.objectDic[@"tbnote_xsddcbs"][i][@"xsdj"] doubleValue];
        }
        allallPrice += allPrice;
    }
    lbl2.text = CCHANGE_DOUBLE(allallPrice);
}
-(void)addSpBtnAction:(UIButton *)btn{
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:btn.tag-500 inSection:1];
    JDOrder1FaHuoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray * copyArray = [[NSMutableArray alloc]initWithArray:_rowHArray];
    for (NSInteger i = 0; i < copyArray.count; i++) {
        if (indexPath.row == i) {
            [_rowHArray replaceObjectAtIndex:i withObject: @([copyArray[i] floatValue] + 10)];
        }
    }
    cell.addViewHConstraint.constant += 10;
}


- (IBAction)btn4Action:(id)sender {
    
    kWeakSelf(self);
    NSMutableDictionary* mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":_objectDic[@"khid"]}];
    [AD_MANAGER requestAddressList:mDic1 success:^(id object) {
        
        
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i <  [object[@"data"] count]; i++) {
            [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:object[@"data"][i][@"shdz"]]];
        }
        view.array = [NSArray arrayWithArray:mArray];
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                weakself.tf4.text = model.title;
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

- (IBAction)btn5Action:(id)sender {
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    NSMutableArray * mArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0 ; i <  shrArray.count; i++) {
        [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:shrArray[i]]];
    }
    
    view.array = [NSArray arrayWithArray:mArray];
    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            //仓库
            [weakself.btn5 setTitle:model.title forState:0];
            _shrid = [_shridArray[model.sid] longValue];
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

-(void)saveChuKuDan{
    
    
    if (!Quan_Xian(@"商品出库")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"商品出库",@"2")];
        return;
    }
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];;
    [self commonParatemersAction:dic];
    
    //商品列表取值
    NSMutableArray * spxscbsArr = [[NSMutableArray alloc]init];
    //计算多少商品
    NSInteger spxdnxh = 0;
    NSArray * cbsArr = self.objectDic[@"tbnote_xsddcbs"];
    for (NSInteger i = 0 ; i < [cbsArr count]; i++) {
        //查找颜色的model
        for (NSInteger k = 0; k < [_saveSpArray[i][NSIntegerToNSString(i)] count]; k++) {
            NSMutableDictionary * spxscbsDic = [[NSMutableDictionary alloc]init];
            spxdnxh += 1;
            [spxscbsDic setValue:NSIntegerToNSString(spxdnxh) forKey:@"dnxh"];//单内序号
            
            [spxscbsDic setValue:@([cbsArr[i][@"spid"] integerValue]) forKey:@"spid"];//商品ID
            [spxscbsDic setValue:@([cbsArr[i][@"sh"] integerValue]) forKey:@"sh"];//色号
            [spxscbsDic setValue:@"1" forKey:@"xsps"];//匹数
            [spxscbsDic setValue:@([_saveSpArray[i][NSIntegerToNSString(i)][k][@"xssl"] doubleValue]) forKey:@"xssl"];//销售主数量
            [spxscbsDic setValue:@([_saveSpArray[i][NSIntegerToNSString(i)][k][@"xsfsl"] doubleValue]) forKey:@"xsfsl"];//销售副数量
            [spxscbsDic setValue:@([cbsArr[i][@"spkc"] integerValue]) forKey:@"spkc"];
            [spxscbsDic setValue:@([cbsArr[i][@"jjfs"] integerValue]) forKey:@"jjfs"];
            [spxscbsDic setValue:@([cbsArr[i][@"xsdj"] doubleValue]) forKey:@"xsdj"];//销售单价
            
            
            double zongjine = 0;
            if ([cbsArr[i][@"jjfs"] integerValue] == 0) {
                zongjine = [_saveSpArray[i][NSIntegerToNSString(i)][k][@"xssl"] doubleValue] * [cbsArr[i][@"xsdj"] doubleValue];
            }else{
                zongjine = [_saveSpArray[i][NSIntegerToNSString(i)][k][@"xsfsl"] doubleValue] * [cbsArr[i][@"xsdj"] doubleValue];
            }
            
            
            [spxscbsDic setValue:@(zongjine) forKey:@"xsje"];//销售金额

            
            [spxscbsDic setValue:@"0" forKey:@"gh"];//缸号
            [spxscbsDic setValue:@"0" forKey:@"bh"];
            [spxscbsDic setValue:@"0" forKey:@"jh"];
            [spxscbsDic setValue:@"0" forKey:@"sfm"];//身份码
            [spxscbsDic setValue:@"0" forKey:@"fslbl"];//辅数量比率
            [spxscbsDic setValue:self.objectDic[@"djhm"] forKey:@"ddhm"];

            [spxscbsDic setValue:cbsArr[i][@"khkh"] forKey:@"khkh"];//货号
            [spxscbsDic setValue:cbsArr[i][@"bz"] forKey:@"bz"];//备注

            
            //商品列表
            [spxscbsArr addObject:spxscbsDic];
            spxdnxh += 1;
        }
    }
    
    [dic setValue:spxscbsArr forKey:@"tbnote_spckcbs"];
    [dic setValue:@[] forKey:@"tbnote_spckcb_fys"];
    kWeakSelf(self);//autocheck 自动审核 1:是(默认) 0:仅存草稿
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string,@"autocheck":@1}];
    [AD_MANAGER requestChuKuDanSave:mDic success:^(id object) {
         [weakself showToast:@"出库单保存成功"];
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        JDYangPinDetailTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDYangPinDetailTableViewController"];
        VC.noteno = object[@"data"];
        AD_MANAGER.orderType = ChuKuDan;
        REMOVE_ALL_CACHE;

        [weakself.navigationController pushViewController:VC animated:YES];
       
    }];
}
-(void)commonParatemersAction:(NSMutableDictionary *)dic{
    LoginModel * model = AD_USERDATAARRAY;
    [dic setValue:self.noteno forKey:@"djhm"];//单据号码 否
    [dic setValue:[NSString currentDateString] forKey:@"zdrq"];//制单日期 否
    [dic setValue:[NSString currentDateStringyyyyMMdd] forKey:@"rzrq"];//入账日期
    [dic setValue:[NSString currentDateStringHHmmss] forKey:@"rzsj"];//入账时间
    [dic setValue:_objectDic[@"ckid"] forKey:@"ckid"];//仓库id ?
    [dic setValue:_objectDic[@"khid"] forKey:@"khid"];//客户id
    [dic setValue:_objectDic[@"khmc"] forKey:@"khmc"];//客户名称 （如khid=0，表示已该名称新增客户）
    [dic setValue:_objectDic[@"ywyid"] forKey:@"ywyid"];//业务员ID
    [dic setValue:model.mdid forKey:@"mdid"];//门店Id
    [dic setValue:self.tf4.text forKey:@"shdz"];//收货地址
    [dic setValue:self.bzTV.text forKey:@"djbz"];//单据备注
    [dic setValue:@"0" forKey:@"djzt"];//单据状态  djzt=0时，为新增 djzt=1时：为修改
    [dic setValue:NSIntegerToNSString(_shrid) forKey:@"shr"];//送货人
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView { CGFloat sectionFooterHeight = 50; CGFloat ButtomHeight = scrollView.contentSize.height - self.tableView.frame.size.height; if (ButtomHeight-sectionFooterHeight <= scrollView.contentOffset.y && scrollView.contentSize.height > 0) { scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); } else { scrollView.contentInset = UIEdgeInsetsMake(0, 0, -(sectionFooterHeight), 0); } }

@end
