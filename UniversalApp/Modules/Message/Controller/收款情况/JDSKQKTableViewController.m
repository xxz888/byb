//
//  JDSKQKTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSKQKTableViewController.h"
#import "JDKLineModel.h"
#import "DVLineChartView.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"
#import "JDSKQKTableViewCell.h"
#import "NSDate+Helper.h"
#import "SelectAlert.h"

@interface JDSKQKTableViewController ()<DVLineChartViewDelegate>{
    NSMutableArray * titles;
}

@property(nonatomic,strong)NSDictionary * dateTimeDic;
@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation JDSKQKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.clickBtn setBackgroundColor:RGB_COLOR(242, 245, 245)];
    ViewBorderRadius(self.clickBtn, 5, 1, RGB_COLOR(51, 51, 51));
    self.navigationController.navigationBar.tintColor = JDRGBAColor(0, 163, 255);
    self.title = self.whereCome ? @"付款情况统计" : @"收款情况统计";
    self.imv1.layer.cornerRadius = self.imv1.frame.size.width/2.0;
    self.imv1.layer.masksToBounds = YES;
    self.imv2.layer.cornerRadius = self.imv2.frame.size.width/2.0;
    self.imv2.layer.masksToBounds = YES;
    _dateTimeDic = @{@"year":@"2018"};
    _dataSource = [[NSMutableArray alloc]init];
    titles = [[NSMutableArray alloc]init];
    for (NSInteger j = 1901; j < 2101; j++) {
        [titles addObject:[NSString stringWithFormat:@"%2ld",(long)j]];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"JDSKQKTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSKQKTableViewCell"];
      self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:_dateTimeDic];
    if (self.whereCome) {
        [AD_MANAGER requestQuerycwfkqs_list:mDic success:^(id object) {
            [self.kLineView removeAllSubviews];
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:object[@"data"][@"fkqs_months"]];
            [weakself.tableView reloadData];
            weakself.allyszkLbl.text = CCHANGE(object[@"data"][@"yfzk"]);
            NSMutableArray * xarr = [[NSMutableArray alloc]init];
            NSMutableArray * y1arr = [[NSMutableArray alloc]init];
            NSMutableArray * y2arr = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in _dataSource) {
                [xarr addObject:[dic[@"month"] append:@"月"]];
                [y1arr addObject:doubleToNSString([dic[@"zjys"] doubleValue])];
                [y2arr addObject:doubleToNSString([dic[@"jsys"] doubleValue])];
                
            }
            if (xarr.count == 0 && y1arr.count == 0 && y2arr.count == 0) {
                
            }else{
                [weakself drawKLine:xarr y1:y1arr y2:y2arr];
                
            }
        }];
    }else{
        [AD_MANAGER requestQuerycwskqs_list:mDic success:^(id object) {
            [self.kLineView removeAllSubviews];
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:object[@"data"][@"skqs_months"]];
            [weakself.tableView reloadData];
            weakself.allyszkLbl.text = CCHANGE(object[@"data"][@"yszk"]);
            NSMutableArray * xarr = [[NSMutableArray alloc]init];
            NSMutableArray * y1arr = [[NSMutableArray alloc]init];
            NSMutableArray * y2arr = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in _dataSource) {
                [xarr addObject:[dic[@"month"] append:@"月"]];
                [y1arr addObject:doubleToNSString([dic[@"zjys"] doubleValue])];
                [y2arr addObject:doubleToNSString([dic[@"jsys"] doubleValue])];
                
            }
            if (xarr.count == 0 && y1arr.count == 0 && y2arr.count == 0) {
                
            }else{
                [weakself drawKLine:xarr y1:y1arr y2:y2arr];
                
            }
        }];
    }

 
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _dataSource.count + 1;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 44;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){//
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        JDSKQKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDSKQKTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.lbl1.text = @"";
            cell.lbl2.text = self.whereCome ? @"新增应付账款" : @"新增应收账款";
            cell.lbl3.text = self.whereCome ? @"付款": @"收款";
            cell.lbl2.textColor =  cell.lbl3.textColor = JDRGBAColor(25, 25, 25);
        }else{
            NSDictionary * dic = _dataSource[indexPath.row-1];
            cell.lbl1.text = [dic[@"month"] append:@"月"];
            
            cell.lbl2.text =  CCHANGE(dic[@"zjys"]);
            cell.lbl3.text =  CCHANGE(dic[@"jsys"]);
        }

        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}
- (IBAction)selectYearAction:(id)sender {
    kWeakSelf(self);
    [SelectAlert showWithTitle:@"选择年份" titles:titles selectIndex:^(NSInteger selectIndex) {
    } selectValue:^(NSString *selectValue) {
        [weakself.clickBtn setTitle:selectValue forState:UIControlStateNormal];
        weakself.dateTimeDic = @{@"year":selectValue};
        [weakself requestData];
    } showCloseButton:NO];
}
-(void)drawKLine:(NSMutableArray *)xArr y1:(NSMutableArray *)y1Arr y2:(NSMutableArray *)y2Arr{
    DVLineChartView *ccc = [[DVLineChartView alloc] init];
    [self setDVLineView:ccc];
    DVPlot *plot = [[DVPlot alloc] init];
    [self setDVPlot:plot];
    DVPlot *plot1 = [[DVPlot alloc] init];
    [self setDVPlot1:plot1];
    //x轴的数据
    ccc.xAxisTitleArray = [NSArray arrayWithArray:xArr];
    
    
    
    //y1轴的数据
    plot.pointArray = [NSArray arrayWithArray:y1Arr];
    NSNumber *max1 = [y1Arr valueForKeyPath:@"@max.floatValue"];
    //y2轴的数据
    plot1.pointArray = [NSArray arrayWithArray:y2Arr];

    ccc.yAxisMaxValue = [max1 floatValue];
    //高度
    ccc.height = 300;
    
    [ccc addPlot:plot];
    [ccc addPlot:plot1];
    [ccc draw];
}
-(void)setDVPlot1:(DVPlot *)plot{
    plot.lineColor = RGB_COLOR(246, 62, 32);
    plot.pointColor = RGB_COLOR(246, 62, 32);
    plot.chartViewFill = NO;
    plot.withPoint = YES;
    
}
-(void)setDVPlot:(DVPlot *)plot{
    plot.lineColor = RGB_COLOR(11, 158, 245);
    plot.pointColor = RGB_COLOR(11, 158, 245);
    plot.chartViewFill = NO;
    plot.withPoint = YES;
    
}
-(void)setDVLineView:(DVLineChartView *)ccc{
    ccc.bounds = self.kLineView.bounds;
    [self.kLineView addSubview:ccc];
    ccc.x = 0;
    ccc.y = 0;
    ccc.width = self.kLineView.width;
    ccc.yAxisViewWidth = 52;
    ccc.numberOfYAxisElements = 5;
    ccc.delegate = self;
    ccc.pointUserInteractionEnabled = YES;
    ccc.pointGap = 50;
    ccc.showSeparate = YES;
    ccc.separateColor = RGB_COLOR(235, 235, 235);
    ccc.textColor = RGB_COLOR(51, 51, 51);
    ccc.backColor = KWhiteColor;
    ccc.axisColor = RGB_COLOR(235, 235, 235);
    ccc.width = self.view.width;
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
