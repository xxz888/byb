//
//  JDSpSalesPiexTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSpSalesPiexTableViewController.h"
#import "DVPieChart.h"
#import "DVFoodPieModel.h"
#import "JDPiexModel.h"
#import "JDSpSalesPiexTableViewCell.h"
#import "JDSpHotTableViewCell.h"
#import "JDSalesTabListTableViewController.h"
@interface JDSpSalesPiexTableViewController ()
@property(nonatomic,strong)NSDictionary * dateTimeDic;

@end

@implementation JDSpSalesPiexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.clickBtn setBackgroundColor:JDRGBAColor(242, 245, 245)];
    ViewBorderRadius(self.clickBtn, 10, 0.5, JDRGBAColor(51, 51, 51));
    self.navigationController.navigationBar.tintColor = JDRGBAColor(0, 163, 255);
    self.title = @"商品销售情况";
    self.beginLbl.text =[NSString getThisWeekFirstDay];
    self.endLbl.text = [NSString currentDateStringyyyyMMdd];
    [self.clickBtn setTitle:@"本周" forState:0];
    
    self.tableView.separatorStyle =  0;
    _dateTimeDic = @{@"begindate":[NSString getThisWeekFirstDay],
                     @"enddate":[NSString currentDateStringyyyyMMdd]};
    [self.tableView registerNib:[UINib nibWithNibName:@"JDSpSalesPiexTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSpSalesPiexTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JDSpHotTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSpHotTableViewCell"];

//    [self addPiexView];
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:_dateTimeDic];
    [AD_MANAGER requestQueryxs_tjList_rxsp:mDic success:^(id object) {
        [weakself addPiexView];
        [weakself.tableView reloadData];
//        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];

    } paramters:@"/query/xs_tj/List_rxsp"];
}
-(void)addPiexView{
    DVPieChart *chart = [[DVPieChart alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.JDPieView.frame.size.height)];
    [self.JDPieView addSubview:chart];
    //求出所有销售额之和
    NSMutableArray * rateArray = [[NSMutableArray alloc]init];
    for (JDPiexModel * model in [self paixuAction]) {
        [rateArray addObject:@(model.xsje)];
    }
    NSNumber *sum = [rateArray valueForKeyPath:@"@sum.floatValue"];
    self.allSalesMoneyLbl.text = CCHANGE_DOUBLE([sum doubleValue]);
    //给饼状图model赋值
    NSMutableArray * modelArray = [[NSMutableArray alloc]init];
    for (JDPiexModel * model in  [self paixuAction]) {
        DVFoodPieModel * pieModel = [[DVFoodPieModel alloc] init];
        pieModel.rate = model.xsje/[sum doubleValue];

        if ([sum doubleValue] == 0) {
            pieModel.rate = 0;
        }
        pieModel.name = model.spmc;
        pieModel.value = model.xsje;
        [modelArray addObject:pieModel];
    }
    NSArray *dataArray = [NSArray arrayWithArray:modelArray];
    chart.dataArray = dataArray;
    chart.title = [NSString stringWithFormat:@"%@%@",@"销售",@"情况"];
    [chart draw];
}


#pragma mark ========== 点击月份的按钮  ==========
- (IBAction)clickBtnAction:(id)sender{
    kWeakSelf(self);
    [LEEAlert actionsheet].config
    .LeeTitle(nil)
    .LeeAction(@"本周", ^{
        
        
        weakself.beginLbl.text =[NSString getThisWeekFirstDay];
        weakself.endLbl.text = [NSString currentDateStringyyyyMMdd];
        [weakself.clickBtn setTitle:@"本周" forState:0];
        [weakself setControlValue:weakself.beginLbl.text end:weakself.endLbl.text];

    })
    .LeeAction(@"上周", ^{
        
        weakself.beginLbl.text = [[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:14 source:@"yyyy-MM-dd"];
        weakself.endLbl.text = [[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:7 source:@"yyyy-MM-dd"];
        [weakself.clickBtn setTitle:@"上周" forState:0];
        [weakself setControlValue:weakself.beginLbl.text end:weakself.endLbl.text];


        
    })
    .LeeAction(@"本月", ^{
        
        
        
        weakself.beginLbl.text =  [NSString getMonthFirstAndLastDayWith:[NSString currentDateStringyyyyMMdd]][0];
        weakself.endLbl.text   =  [NSString currentDateStringyyyyMMdd];
        [weakself.clickBtn setTitle:@"本月" forState:0];
        [weakself setControlValue:weakself.beginLbl.text end:weakself.endLbl.text];

        
    })
    .LeeAction(@"上月", ^{
        
        weakself.beginLbl.text = [NSString getMonthFirstAndLastDayWith:[NSString getUpMouth]][0];
        weakself.endLbl.text = [NSString getMonthFirstAndLastDayWith:[NSString getUpMouth]][1];
        [weakself.clickBtn setTitle:@"上月" forState:0];
        [weakself setControlValue:weakself.beginLbl.text end:weakself.endLbl.text];


        
    })
    .LeeCancelAction(@"取消", ^{
        
        // 点击事件Block
    })
    .LeeShow();
}
//公共的方法
-(void)setControlValue:(NSString *)start end:(NSString *)end{
    _dateTimeDic = @{@"begindate":start,
                     @"enddate":end};
    [self requestData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return AD_MANAGER.piexArray.count;
    }else if (section == 2){
        return AD_MANAGER.piexArray.count;

    }
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        //titile
        UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        HeaderLabel.backgroundColor = JDRGBAColor(247, 249, 251);
        [view addSubview:HeaderLabel];
        return view;
    }else if (section == 2){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 42)];
        view.backgroundColor = JDRGBAColor(247, 249, 251);
        UIImageView * imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_changxiao"]];
        imgV.frame = CGRectMake(0, 0, 130, 17);
        imgV.center = view.center;
        [view addSubview:imgV];
        
#pragma mark--button create
        kWeakSelf(self);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:btn];

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 16));
            make.centerY.mas_equalTo(view.mas_centerY);
            make.right.equalTo(view).with.offset(-20);
        }];
        [btn setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
        btn.font = [UIFont systemFontOfSize:11];
        [btn setTitle:@"更多>>" forState:0];
        [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }else{
        return  [super tableView:tableView viewForHeaderInSection:section];
    }

}
-(void)clicked:(UIButton *)btn{
    if (!Quan_Xian(@"查看销售额权限")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"查看销售额权限",@"0")];
        return;
    }
    
    UIStoryboard * stroryBoard3 = [UIStoryboard storyboardWithName:@"ThirdVC" bundle:nil];
    
               JDSalesTabListTableViewController * VC = [stroryBoard3 instantiateViewControllerWithIdentifier:@"JDSalesTabListTableViewController"];
    [self.navigationController pushViewController:VC animated:YES];

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else if (section == 2){
        return 42;
    }else{
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){
        return  44;
    }else if(2 == indexPath.section){
        return  160;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }else if (2 == indexPath.section){
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:2]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        JDSpSalesPiexTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDSpSalesPiexTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = 0;
        JDPiexModel * model = [self paixuAction][indexPath.row];
        cell.colorImg.backgroundColor = COLOR_ARRAY[indexPath.row];
        [cell setCellData:model];
        return cell;
    }else if(indexPath.section == 2){
        JDSpHotTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDSpHotTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = 0;
        JDPiexModel * model = [self paixuAction][indexPath.row];
        [cell setCellData:model];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(NSArray *)paixuAction{
    NSArray *resultArray = [AD_MANAGER.piexArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        JDPiexModel * per1 = obj1;
        JDPiexModel * per2 = obj2;
        if (per1.xsje < per2.xsje) {
            return NSOrderedDescending;//降序
        }else if (per1.xsje > per2.xsje){
            return NSOrderedAscending;//升序
        }else{
            return NSOrderedSame;//相等
        }
    }];
    return resultArray;
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
