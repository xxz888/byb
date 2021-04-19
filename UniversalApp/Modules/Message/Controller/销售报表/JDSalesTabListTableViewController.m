//
//  JDSalesTabListTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/6/25.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSalesTabListTableViewController.h"
#import "SelectedListView.h"
#import "JDSalesTabListTableViewCell.h"
#import "XJCalendarSelecteViewController.h"
#import "JDSalesSearchTableViewController.h"
typedef enum _TTGState {
    TTGStateOK  = 0,
    TTGStateError,
    TTGStateUnknow
} TTGState;

//指明枚举类型
TTGState state = TTGStateOK;



@interface JDSalesTabListTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * _selectTag;//记录选择的tag
}
@property(nonatomic,strong)NSDictionary * commonDic;
@property(nonatomic,strong)NSDictionary * dateTimeDic;
@property(nonatomic,strong)NSDictionary * paramtersDic;
@property(nonatomic,strong)NSArray * keysArray;
@property (nonatomic,strong) UIImageView* noDataView;

@end

@implementation JDSalesTabListTableViewController

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"销售报表";



    [AD_SHARE_MANAGER MLShadow:self.cell1View];
    ViewRadius(self.cell1View, 5);
    
    

    //进入页面初始化的值
    [self.salesBtn setTitle:@"销售" forState:0];
    [self.clientBtn setTitle:@"查看明细" forState:0];
    _selectTag = @"销售查看明细";
    _dateTimeDic = @{@"begindate":[NSString currentDateStringyyyyMMdd],@"enddate":[NSString currentDateStringyyyyMMdd]};

    _keysArray = @[@"销售查看明细",@"销售日报表",@"销售按商品汇总",@"销售按客户汇总",@"销售按业务员汇总",@"销售按门店业绩",
                   @"预定查看明细",@"预定日报表",@"预定按商品汇总",@"预定按客户汇总", @"预定按业务员汇总",@"预定按门店业绩"];
    
    //接口字典
    _paramtersDic = @{
                      _keysArray[0]:@"/query/xs_tj/List_djhm",
                      _keysArray[1]:@"/query/xs_tj/List_r",
                      _keysArray[2]:@"/query/xs_tj/List_sp",
                      _keysArray[3]:@"/query/xs_tj/List_kh",
                      _keysArray[4]:@"/query/xs_tj/List_ywy",
                      _keysArray[5]:@"/query/xs_tj/List_md",
                      
                      
                      
                      
                      _keysArray[6]:@"/query/xsdd_tj/List_djhm",
                      _keysArray[7]:@"/query/xsdd_tj/List_r",
                     _keysArray[8]:@"/query/xsdd_tj/List_sp",
                      _keysArray[9]:@"/query/xsdd_tj/List_kh",
                      _keysArray[10]:@"/query/xsdd_tj/List_ywy",
                      _keysArray[11]:@"/query/xsdd_tj/List_md",
                      };
    

    [self.tableView registerNib:[UINib nibWithNibName:@"JDSalesTabListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSalesTabListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JDSalesTabListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSalesTabListTableViewCell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JDSalesTabListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSalesTabListTableViewCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JDSalesTabListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSalesTabListTableViewCell3"];

    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    //12个lbl请求
    [self requestData:_dateTimeDic];
    //下边列表的请求
    [self requestDataSaleList:_dateTimeDic paramters:_paramtersDic[_selectTag]];
    
    
   [self addNavigationItemWithTitles:@[@"查询"] isLeft:NO target:self action:@selector(searchData:) tags:@[@"90001"]];
    UIButton * btn = [self.view viewWithTag:90001];
    [btn setTitleColor:KWhiteColor forState:0];

}

-(void)searchData:(UIButton *)btn{
    kWeakSelf(self);
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ThirdVC" bundle:nil];
    JDSalesSearchTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDSalesSearchTableViewController"];
    VC.sendBlock = ^(NSMutableDictionary * resultDic) {
        //下边列表的请求
        [weakself requestDataSaleList:resultDic paramters:_paramtersDic[_selectTag]];
    };
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

    self.navigationController.navigationBar.tintColor = KWhiteColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:JDRGBAColor(86, 151, 242)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉阴影线
    self.navigationController.navigationBar.translucent=NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

//

//    self.navigationController.navigationBar.tintColor = KBlackColor;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:KWhiteColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}
#pragma mark ========== 请求今日 昨日 7天 30天数据 ==========
-(void)requestData:(NSDictionary *)dateDic{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dateDic];
    [AD_MANAGER requestqQueryxs_tjList:mDic success:^(id object) {
        _commonDic = object[@"data"];
        [weakself setValueHeaderData];
    }];
}
#pragma mark ========== 请求下边列表 ==========
//dateDic 传的参数 paramters 传的接口
-(void)requestDataSaleList:(NSDictionary *)dateDic paramters:(NSString *)paramters{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dateDic];
    [AD_MANAGER requestqQueryxs_tjList_djhm:mDic success:^(id object) {
        if (AD_MANAGER.salesBtnArray.count == 0) {
            [weakself showNoDataImage];
        }else{
            [weakself removeNoDataImage];
        }
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    } paramters:paramters];

}
#pragma mark ========== tableview 代理方法 ==========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 999) {
        return 1;
    }
    return [super numberOfSectionsInTableView:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return AD_MANAGER.salesBtnArray.count ;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){//爱好 （动态cell）
        return   [ _selectTag isEqualToString:_keysArray[0]] ? 240 :
            [ _selectTag isEqualToString:_keysArray[1]] ? 210 :
            [ _selectTag isEqualToString:_keysArray[2]] ? 170 :
            [ _selectTag isEqualToString:_keysArray[3]] ? 130 :
            [ _selectTag isEqualToString:_keysArray[4]] ? 130 :
            [ _selectTag isEqualToString:_keysArray[5]] ? 130 :
            [ _selectTag isEqualToString:_keysArray[6]] ? 200 :
            [ _selectTag isEqualToString:_keysArray[7]] ? 110 :
            [ _selectTag isEqualToString:_keysArray[8]] ? 130 :
            [ _selectTag isEqualToString:_keysArray[9]] ? 130 :
            [ _selectTag isEqualToString:_keysArray[10]] ? 110 :
            [ _selectTag isEqualToString:_keysArray[11]] ? 110 : 1;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(2 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:2]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDSalesTabListTableViewCell * cell ;
    if (indexPath.section == 2) {
        JDSalesBtnModel * model = AD_MANAGER.salesBtnArray[indexPath.row];

        if ([_selectTag isEqualToString:_keysArray[0]])  {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JDSalesTabListTableViewCell" owner:self options:nil] firstObject];
            [cell setCellData:model];

        }else if ([_selectTag isEqualToString:_keysArray[1]] ||
                  [_selectTag isEqualToString:_keysArray[3]] ||
                  [_selectTag isEqualToString:_keysArray[4]] ||
                  [_selectTag isEqualToString:_keysArray[5]] ||
                  [_selectTag isEqualToString:_keysArray[8]] ||
                  [_selectTag isEqualToString:_keysArray[9]]){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JDSalesTabListTableViewCell" owner:self options:nil] objectAtIndex:3];
            [cell setCellData3:model];
        }else if ([_selectTag isEqualToString:_keysArray[7]] ||
                  [_selectTag isEqualToString:_keysArray[10]] ||
                  [_selectTag isEqualToString:_keysArray[11]]){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JDSalesTabListTableViewCell" owner:self options:nil] objectAtIndex:2];
            [cell setCellData2:model];

        }else if([_selectTag isEqualToString:_keysArray[2]]){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JDSalesTabListTableViewCell" owner:self options:nil] objectAtIndex:4];
            [cell setCellData4:model];

        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JDSalesTabListTableViewCell" owner:self options:nil] objectAtIndex:1];
            [cell setCellData1:model];
        }
    
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//请求完12个lbl赋值
-(void)setValueHeaderData{
    NSDictionary * dic = _commonDic;
    
    self.jrxsLbl.text = NSIntegerToNSString([dic[@"xs_djsl"] integerValue]) ;
    self.xsjeLbl.text = CCHANGE(dic[@"xs_xsje"]);//
    self.xspiLbl.text = NSIntegerToNSString([dic[@"xs_xsps"] integerValue]);
    self.xsslLbl.text = NSIntegerToNSString([dic[@"xs_xssl"] integerValue]);
    
    self.yddsLbl.text = NSIntegerToNSString([dic[@"xsdd_djsl"] integerValue]);
    self.ydjeLbl.text = CCHANGE(dic[@"xsdd_xsje"]);
    self.ydpsLbl.text = NSIntegerToNSString([dic[@"xsdd_xsps"] integerValue]);
    self.ydslLbl.text = NSIntegerToNSString([dic[@"xsdd_xssl"] integerValue]);
    
    self.mllLbl.text = [doubleToNSString([dic[@"xs_xsmll"] doubleValue]) append:@"%"];
    self.mlLbl.text = CCHANGE_DOUBLE([dic[@"xs_xsml"] doubleValue]);//
    self.zdpsLbl.text =  NSIntegerToNSString([dic[@"spcount"] integerValue]);
    self.zkhsLbl.text =  NSIntegerToNSString([dic[@"khcount"] integerValue]);



}
#pragma mark ========== 个button的公用方法 今日 昨日 近7天 近30天 ==========
- (IBAction)allBtnAction:(UIButton *)btn {
    switch (btn.tag) {
        case 30001:{//今日
            
            
            _dateTimeDic = @{@"begindate":[NSString currentDateStringyyyyMMdd],@"enddate":[NSString currentDateStringyyyyMMdd]};
            [self requestData:_dateTimeDic];
            [self requestDataSaleList:_dateTimeDic paramters:_paramtersDic[_selectTag]];


            [self.btn5 setTitle:@"自定义" forState:0];

            self.btn1Img.hidden = NO;
            self.btn2Img.hidden = self.btn3Img.hidden = self.btn4Img.hidden =  self.btn5Img.hidden = YES;
        }
            break;
        case 30002:{//昨日
            _dateTimeDic = @{@"begindate":[[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:1 source:@"yyyy-MM-dd"],
                             @"enddate":[[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:1 source:@"yyyy-MM-dd"]};
            [self requestData:_dateTimeDic];
            [self requestDataSaleList:_dateTimeDic paramters:_paramtersDic[_selectTag]];
            
   
            [self.btn5 setTitle:@"自定义" forState:0];

            self.btn2Img.hidden = NO;
            self.btn1Img.hidden = self.btn3Img.hidden = self.btn4Img.hidden = self.btn5Img.hidden = YES;
        }
            
            break;
        case 30003:{//近7天
            _dateTimeDic = @{@"begindate":[[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:7 source:@"yyyy-MM-dd"],@"enddate":[NSString currentDateStringyyyyMMdd]};
            [self requestData:_dateTimeDic];
            [self requestDataSaleList:_dateTimeDic paramters:_paramtersDic[_selectTag]];
            
            

            [self.btn5 setTitle:@"自定义" forState:0];

            self.btn3Img.hidden = NO;
            self.btn2Img.hidden = self.btn1Img.hidden = self.btn4Img.hidden = self.btn5Img.hidden = YES;
        }
            
            break;
        case 30004:{//近30天
            
            _dateTimeDic = @{@"begindate":[[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:30 source:@"yyyy-MM-dd"],@"enddate":[NSString currentDateStringyyyyMMdd]};
            [self requestData:_dateTimeDic];
            
            [self requestDataSaleList:_dateTimeDic paramters:_paramtersDic[_selectTag]];

            [self.btn5 setTitle:@"自定义" forState:0];

            self.btn4Img.hidden = NO;
            self.btn2Img.hidden = self.btn3Img.hidden = self.btn1Img.hidden = self.btn5Img.hidden = YES;
        }
            
            break;
        case 30005:{//近30天
            
            kWeakSelf(self);
            XJCalendarSelecteViewController *VC = [[XJCalendarSelecteViewController alloc] init];
            VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
            VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:VC animated:NO completion:nil];
            VC.userSelcetResultBlock = ^(NSMutableDictionary *resultDictM) {

                if (![resultDictM[@"endTime"] isEqualToString:@"结束时间"]) {
                    NSString * string = [NSString stringWithFormat:@"%@\n%@",resultDictM[@"startTime"],resultDictM[@"endTime"]];
                    _dateTimeDic = @{@"begindate":resultDictM[@"startTime"],@"enddate":resultDictM[@"endTime"]};
                    [weakself requestData:_dateTimeDic];
                    [weakself requestDataSaleList:_dateTimeDic paramters:_paramtersDic[_selectTag]];
                    [weakself.btn5 setTitle:string forState:0];

                }
         
            };
            


            [self.btn5 setTitle:@"自定义" forState:0];
            self.btn5Img.hidden = NO;
            self.btn2Img.hidden = self.btn3Img.hidden = self.btn1Img.hidden = self.btn4Img.hidden = YES;
        }
            
            break;
        default:
            break;
    }
}
#pragma mark ========== 点击销售预定按钮方法 ==========
-(void)pushAlert:(NSArray *)arr{
    
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    NSMutableArray * mArray = [[NSMutableArray alloc]init];

    for (NSInteger i = 0; i < arr.count; i++) {
        [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:arr[i]]];
    }
    
    view.array = [NSArray arrayWithArray:mArray];
    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            
         
            
            if (arr.count == 2) {
                [weakself.salesBtn setTitle:model.title forState:0];
            }else{
                [weakself.clientBtn setTitle:model.title forState:0];
            }
            //点击完btn，来改变_selectTag的值
            _selectTag = [weakself.salesBtn.titleLabel.text append:weakself.clientBtn.titleLabel.text];
            [weakself requestDataSaleList:_dateTimeDic paramters:_paramtersDic[_selectTag]];

        }];
        
    };
    
    [LEEAlert alert].config
    .LeeTitle(nil)
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeCustomView(view)
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}


- (IBAction)salesBtnAction:(id)sender {
    [self pushAlert:@[@"销售",@"预定"]];
}

- (IBAction)clientAllBtnAction:(id)sender {
    [self pushAlert:@[@"查看明细",@"日报表",@"按商品汇总",@"按客户汇总",@"按业务员汇总",@"按门店业绩"]];

}


-(void)showNoDataImage
{
    [_noDataView removeFromSuperview];
    _noDataView = nil;
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"Group 3"]];
    
    [_noDataView setFrame:CGRectMake(0, 600,203, 268)];
    [_noDataView setCenterX:self.tableView.centerX];
    [_noDataView setCenterY:600];
    [self.tableView addSubview:_noDataView];
    
    
//    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:[UITableView class]]) {
//            [_noDataView setFrame:CGRectMake(0, 0,203, 268)];
//            [_noDataView setCenterX:obj.centerX];
//            [_noDataView setCenterY:obj.centerY - 60];
//            [obj addSubview:_noDataView];
//        }
//    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
