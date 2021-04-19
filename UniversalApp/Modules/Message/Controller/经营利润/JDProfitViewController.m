//
//  JDProfitViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDProfitViewController.h"

@interface JDProfitViewController ()
@property(nonatomic,strong)NSDictionary * dateTimeDic;

@end

@implementation JDProfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"利润简表";
    [self.clickBtn setBackgroundColor:JDRGBAColor(242, 245, 245)];
    ViewBorderRadius(self.clickBtn, 10, 0.5, JDRGBAColor(51, 51, 51));
    self.beginLbl.text =[NSString getThisWeekFirstDay];
    self.endLbl.text = [NSString currentDateStringyyyyMMdd];
    [self.clickBtn setTitle:@"本周" forState:0];
    _dateTimeDic = @{@"begindate":self.beginLbl.text,
                     @"enddate":self.endLbl.text};
    
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:_dateTimeDic];
    [AD_MANAGER requestQueryxs_cwjylr_list:mDic success:^(id object) {
        weakself.spxsmlLbl.text = [ADTool countNumAndChangeformat: doubleToNSString([object[@"data"][4][@"je"] doubleValue])];
        
        weakself.lbl1Tag.text = object[@"data"][0][@"xm"];
        weakself.lbl1.text =  [ADTool countNumAndChangeformat:doubleToNSString([object[@"data"][0][@"je"] doubleValue])] ;
        
        weakself.lbl2Tag.text = object[@"data"][1][@"xm"];
        weakself.lbl2.text =  [ADTool countNumAndChangeformat:doubleToNSString([object[@"data"][1][@"je"] doubleValue])] ;
        
        weakself.lbl3Tag.text = object[@"data"][2][@"xm"];
        weakself.lbl3.text =  [ADTool countNumAndChangeformat:doubleToNSString([object[@"data"][2][@"je"] doubleValue])] ;
        
        weakself.lbl4Tag.text = object[@"data"][3][@"xm"];
        weakself.lbl4.text =  [ADTool countNumAndChangeformat:doubleToNSString([object[@"data"][3][@"je"] doubleValue])] ;
        
        weakself.lbl5.text = object[@"data"][4][@"xm"];
        weakself.lbl5Tag.text =  [ADTool countNumAndChangeformat:doubleToNSString([object[@"data"][4][@"je"] doubleValue])] ;
    }];
}

- (IBAction)clickBtnAction:(id)sender{
    kWeakSelf(self);
    [LEEAlert actionsheet].config
    .LeeTitle(nil)
    .LeeAction(@"本周", ^{
        
        
        weakself.beginLbl.text =[NSString getThisWeekFirstDay];
        weakself.endLbl.text = [NSString currentDateStringyyyyMMdd];
        [weakself.clickBtn setTitle:@"本周" forState:0];
        _dateTimeDic = @{@"begindate":weakself.beginLbl.text,
                         @"enddate":weakself.endLbl.text};
        [weakself requestData];

    })
    .LeeAction(@"上周", ^{
        
        weakself.beginLbl.text = [[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:14 source:@"yyyy-MM-dd"];
        weakself.endLbl.text = [[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:7 source:@"yyyy-MM-dd"];
        [weakself.clickBtn setTitle:@"上周" forState:0];
        _dateTimeDic = @{@"begindate":weakself.beginLbl.text,
                         @"enddate":weakself.endLbl.text};
        [weakself requestData];

        
        
    })
    .LeeAction(@"本月", ^{
        
        
        
        weakself.beginLbl.text =  [NSString getMonthFirstAndLastDayWith:[NSString currentDateStringyyyyMMdd]][0];
        weakself.endLbl.text   =  [NSString currentDateStringyyyyMMdd];
        [weakself.clickBtn setTitle:@"本月" forState:0];
        _dateTimeDic = @{@"begindate":weakself.beginLbl.text,
                         @"enddate":weakself.endLbl.text};
        [weakself requestData];

        
    })
    .LeeAction(@"上月", ^{
        
        weakself.beginLbl.text = [NSString getMonthFirstAndLastDayWith:[NSString getUpMouth]][0];
        weakself.endLbl.text = [NSString getMonthFirstAndLastDayWith:[NSString getUpMouth]][1];
        [weakself.clickBtn setTitle:@"上月" forState:0];
        _dateTimeDic = @{@"begindate":weakself.beginLbl.text,
                         @"enddate":weakself.endLbl.text};
        [weakself requestData];
        
        
        
    })
    .LeeCancelAction(@"取消", ^{
        
        // 点击事件Block
    })
    .LeeShow();
}
@end
