//
//  JDYsqvKLineViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/26.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDYsqvKLineViewController.h"
#import "JDKLineModel.h"
#import "DVLineChartView.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"
@interface JDYsqvKLineViewController ()<DVLineChartViewDelegate>

@property(nonatomic,strong)NSDictionary * dateTimeDic;

@end

@implementation JDYsqvKLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营收趋势";
    [self.clickBtn setBackgroundColor:JDRGBAColor(242, 245, 245)];
    ViewBorderRadius(self.clickBtn, 10, 0.5, JDRGBAColor(51, 51, 51));
    
    self.segmentControl.tintColor = JDRGBAColor(0, 163, 255);
    
    self.beginLbl.text =[NSString getThisWeekFirstDay];
    self.endLbl.text = [NSString currentDateStringyyyyMMdd];
    
    _dateTimeDic = @{@"begindate":self.beginLbl.text,
                     @"enddate": self.endLbl.text };
    

    
    
    [self requestData:@"/query/Cw_ysqs/list_xsje"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)requestData:(NSString *)paramters{
    
    kWeakSelf(self);

    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:_dateTimeDic];
    [AD_MANAGER requestQueryCw_ysqslist_xsje:mDic success:^(id object) {
        NSMutableArray * xsjeArr = [[NSMutableArray alloc]init];
         NSMutableArray * rzrqArr = [[NSMutableArray alloc]init];
        for (JDKLineModel * model in AD_MANAGER.kLineArray) {
            if ([paramters isEqualToString:@"/query/Cw_ysqs/list_skje"]) {
                [xsjeArr addObject:@(model.skje)];
            }else if ([paramters isEqualToString:@"/query/Cw_ysqs/list_dhsl"]){
                [xsjeArr addObject:@(model.xssl)];
            }else if ([paramters isEqualToString:@"/query/Cw_ysqs/list_kdj"]){
                [xsjeArr addObject:@(model.kdj)];
            }
            else{
                [xsjeArr addObject:@(model.xsje)];

            }
            [rzrqArr addObject:model.rzrq];
        }
        [weakself drawKLine:rzrqArr YData:xsjeArr];

    } paramters:paramters];
                     
    
}


-(void)drawKLine:(NSMutableArray *)xArr YData:(NSMutableArray *)yArr{
    DVLineChartView *ccc = [[DVLineChartView alloc] init];
    [self setDVLineView:ccc];
    DVPlot *plot = [[DVPlot alloc] init];
    [self setDVPlot:plot];
    //x轴的数据
    ccc.xAxisTitleArray = [NSArray arrayWithArray:xArr];
    //y轴的数据
    plot.pointArray = [NSArray arrayWithArray:yArr];
    //最大值
    NSNumber *max = [yArr valueForKeyPath:@"@max.floatValue"];

    ccc.yAxisMaxValue = [max floatValue];
    //高度
    ccc.height = 300;
    
    [ccc addPlot:plot];
    [ccc draw];
}
-(void)setDVPlot:(DVPlot *)plot{
    plot.lineColor = RGB_COLOR(21, 146, 255);
    plot.pointColor = RGB_COLOR(0, 163, 255);
    plot.chartViewFill = YES;
    plot.withPoint = YES;

}
-(void)setDVLineView:(DVLineChartView *)ccc{
    ccc.frame = CGRectMake(0, 0, KScreenWidth, self.kLineView.frame.size.height);
    [self.kLineView addSubview:ccc];
    ccc.x = 0;
    ccc.y = 0;
    ccc.width = KScreenWidth;
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
    ccc.width = KScreenWidth;
}

- (IBAction)selectSegmentAction:(UISegmentedControl *)segment {
    
    switch (segment.selectedSegmentIndex) {
        case 0:{
            
            
            [self requestData:@"/query/Cw_ysqs/list_xsje"];
        }
            break;
        case 1:{
            
            [self requestData:@"/query/Cw_ysqs/list_skje"];
        }
            break;
        case 2:{
            
            [self requestData:@"/query/Cw_ysqs/list_dhsl"];
        }
            break;
        case 3:{
            
            [self requestData:@"/query/Cw_ysqs/list_kdj"];
            
        }
            break;
        default:
            break;
    }
}
-(void)setControlValue:(NSString *)start end:(NSString *)end{
    _dateTimeDic = @{@"begindate":start,
                     @"enddate":end};
    [self requestSegmentIndex:self.segmentControl.selectedSegmentIndex];
}
- (IBAction)clickBtnAction:(id)sender {
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

        weakself.beginLbl.text = [NSString getUpWeek][0];
        weakself.endLbl.text = [NSString getUpWeek][1];
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
-(void)requestSegmentIndex:(NSInteger)segmentSelect{
    if (segmentSelect == 0) {
        [self requestData:@"/query/Cw_ysqs/list_xsje"];
    }else if (segmentSelect == 1){
        [self requestData:@"/query/Cw_ysqs/list_skje"];
    }else if (segmentSelect == 2){
        [self requestData:@"/query/Cw_ysqs/list_dhsl"];
    }else{
    [self requestData:@"/query/Cw_ysqs/list_kdj"];
    }
}
@end
