//
//  JDDuiZhangExcelViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2020/3/13.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "JDDuiZhangExcelViewController.h"
#import "JDDuiZhangExcelHeaderView.h"
#import "JDDuiZhangExcelTableViewCell.h"
#import "UIView+WZB.h"
#import "XJCalendarSelecteViewController.h"
#define signWidth 2326
@interface JDDuiZhangExcelViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *exScrollView;
 //底部srollView
 @property (nonatomic, strong) UIScrollView                    *imgScroll;
 //显示图片
 @property (nonatomic, strong) UIImageView                     *myImageView;
@property (nonatomic,strong) UIImage * orderImage;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSString * beginrq;
@property(nonatomic,strong)NSString * endrq;

@end

@implementation JDDuiZhangExcelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc]init];
    self.beginrq = @"-";
    self.endrq = @"-";

    self.view.backgroundColor =  JDRGBAColor(247, 249, 251);
    
    [self addNavigationItemWithTitles:@[@"分享"] isLeft:NO target:self action:@selector(saveImage) tags:nil];

    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:JDRGBAColor(0, 163, 255) forState:UIControlStateNormal];
    button.frame=CGRectMake(20, 20, 300, 40);
    [button setTitle:@"请选择时间" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
       

}
-(void)selectTime:(UIButton *)btn{
       kWeakSelf(self);
       XJCalendarSelecteViewController *VC = [[XJCalendarSelecteViewController alloc] init];
       VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
       VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
       [self presentViewController:VC animated:NO completion:nil];
       VC.userSelcetResultBlock = ^(NSMutableDictionary *resultDictM) {

           if (![resultDictM[@"endTime"] isEqualToString:@"结束时间"]) {
               NSString * string = [NSString stringWithFormat:@"%@至%@",resultDictM[@"startTime"],resultDictM[@"endTime"]];
               weakself.beginrq = resultDictM[@"startTime"];
               weakself.endrq = resultDictM[@"endTime"];
               [weakself requestData];
               [btn setTitle:string forState:0];
           }
    
       };
}
-(void)requestData{
    if ([self.beginrq isEqualToString:@"-"] && [self.endrq isEqualToString:@"-"]) {
           [UIView showToast:@"请选择开始时间和结束时间"];
            return;
       }
    if ([self.beginrq isEqualToString:@"-"]) {
        [UIView showToast:@"请选择开始时间"];
         return;
    }
    if ([self.endrq isEqualToString:@"-"]) {
        [UIView showToast:@"请选择结束时间"];
        return;
    }
    
    
    kWeakSelf(self);
    //获取打印方案
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    [AD_MANAGER requestKeHuDuiZhangDanGetWay:mDic1 success:^(id object) {
        //获取页数
        NSString * string = [ADTool dicConvertToNSString:@{
                                      @"begindate":self.beginrq,
                                      @"enddate":self.endrq,
                                      @"khid":@(self.khid),
                                      @"xsqc":@(1),
                                      @"xsbyhj":@(1),
                                      @"mobile":@(1)}];
        NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"Condition":string,@"wayname":@""}];
        [AD_MANAGER requestKeHuDuiZhangDanYeShu:mDic2 success:^(id object) {
            NSInteger count = [object[@"data"] integerValue];
            dispatch_group_t group = dispatch_group_create();
            NSMutableArray * allArray = [[NSMutableArray alloc]init];
            for (NSInteger i = 0; i < count; i++) {
                  dispatch_group_enter(group);
                  //获取最终图片，分页的
                  NSMutableDictionary * mDic3 = [AD_SHARE_MANAGER requestSameParamtersDic:@{
                                 @"Condition":string,
                                 @"aDpiX":@180,
                                 @"aDpiY":@180,
                                 @"Wayname":@"",
                                 @"curpage":@(i+1)}];
                [AD_MANAGER requestKeHuDuiZhangDanYeShu:mDic3 success:^(id object) {
                        [allArray addObject:object[@"img"]];
                         dispatch_group_leave(group);
                }];
            };
            dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //主线程执行
                    NSArray *items = [NSArray arrayWithArray:allArray];
                        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
                    [weakself presentViewController:activityVC animated:TRUE completion:nil];
               });
            });
        }];
    }];
}
@end
