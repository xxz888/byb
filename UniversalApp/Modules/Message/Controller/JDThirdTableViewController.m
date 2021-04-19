//
//  JDThirdTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/25.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDThirdTableViewController.h"
#import "JDSalesBtnModel.h"
#import "JDCollectionAccountViewController.h"
#import "JDClientCheckingViewController.h"
#import "JDSKQKTableViewController.h"
#import "JDGongChangKuCunViewController.h"

@interface JDThirdTableViewController ()
@property(nonatomic,strong)NSMutableArray * commonArray;
@end

@implementation JDThirdTableViewController
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];

    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    _commonArray = [[NSMutableArray alloc]init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [AD_SHARE_MANAGER MLShadow:self.view1];
    [AD_SHARE_MANAGER MLShadow:self.view2];
    [AD_SHARE_MANAGER MLShadow:self.view3];
    [AD_SHARE_MANAGER MLShadow:self.fuKuanView];


}


#pragma mark ==========  第三页 ==========

-(void)requestData1{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    [AD_MANAGER requestThreeShow:mDic success:^(id object) {
        NSDictionary * dic =  object[@"data"];
        
        weakself.Albl1.text = NSIntegerToNSString([dic[@"xs_djsl"] integerValue]) ;
        weakself.Albl2.text = NSIntegerToNSString([dic[@"xsdd_djsl"] integerValue]);
        weakself.Albl3.text = Quan_Xian(@"查看销售额权限") ? CCHANGE(dic[@"xs_xsje"]) : @"¥*" ;
        weakself.Albl4.text = Quan_Xian(@"查看销售额权限") ? CCHANGE(dic[@"xsdd_xsje"]): @"¥*" ;
        
        
        weakself.Clbl1.text = Quan_Xian(@"应收账款统计") ? CCHANGE(dic[@"ys_zjys"]) : @"¥*" ;
        weakself.Clbl2.text = Quan_Xian(@"应收账款统计") ? CCHANGE(dic[@"ys_jsys"]): @"¥*" ;
        
        weakself.Elbl1.text = CCHANGE(dic[@"kc_spsl"]);
        weakself.Elbl2.text = NSIntegerToNSString([dic[@"bj_count"] integerValue]);
        
        
        weakself.jinriyingfuLbl.text = Quan_Xian(@"应付账款统计") ? CCHANGE(dic[@"yf_zjyf"]): @"¥*" ;
        weakself.fukuanJineLbl.text = Quan_Xian(@"应付账款统计") ? CCHANGE(dic[@"yf_jsyf"]): @"¥*" ;

    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;

    [self requestData1];
    if (!Quan_Xian(@"经营利润表")) {
   
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 1) {
//        if (!Quan_Xian(@"应收账款统计")) {
//            [UIView showToast:QUANXIAN_ALERT_STRING(@"应收账款统计")];
//            return 0;
//        }
//    }else   if (indexPath.row == 2) {
//        if (!Quan_Xian(@"应付账款统计")) {
//            [UIView showToast:QUANXIAN_ALERT_STRING(@"应付账款统计")];
//            return 0;
//        }
//    }
//    return  [super tableView:tableView heightForRowAtIndexPath:indexPath];
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *title = @"  ";
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 11)];
    if (section == 3) {
        view.backgroundColor = KWhiteColor;
        nil;
    }else{
        view.backgroundColor = JDRGBAColor(247, 249, 251);
        
    }
    
    //titile
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 11)];
    HeaderLabel.backgroundColor = KClearColor;
    HeaderLabel.font = [UIFont boldSystemFontOfSize:13];
    HeaderLabel.text = title;
    [view addSubview:HeaderLabel];
    
    return view;
}

//跳转到tabbar第二个界面
- (IBAction)stockSpAction:(id)sender {
    [REQUEST_PUSH_MANAGER qxPushShangPin:self.tabBarController];

}

- (IBAction)fuKuanAction:(id)sender {
    if (!Quan_Xian(@"应付账款统计")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"应付账款统计",@"0")];
        return;
    }
    UIStoryboard * stroryBoard3 = [UIStoryboard storyboardWithName:@"ThirdVC" bundle:nil];
    JDCollectionAccountViewController * VC = [stroryBoard3 instantiateViewControllerWithIdentifier:@"JDCollectionAccountViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)gysdzAction:(id)sender {
    if (!Quan_Xian(@"应付账款统计")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"应付账款统计",@"0")];
        return;
    }
    UIStoryboard * stroryBoard3 = [UIStoryboard storyboardWithName:@"ThirdVC" bundle:nil];
    JDClientCheckingViewController * VC = [stroryBoard3 instantiateViewControllerWithIdentifier:@"JDClientCheckingViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)fkqsAction:(id)sender {
    if (!Quan_Xian(@"应付账款统计")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"应付账款统计",@"0")];
        return;
    }
    UIStoryboard * stroryBoard3 = [UIStoryboard storyboardWithName:@"ThirdVC" bundle:nil];
    JDSKQKTableViewController * VC = [stroryBoard3 instantiateViewControllerWithIdentifier:@"JDSKQKTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = YES;
    [self.navigationController pushViewController:VC animated:YES];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (([@"JDSalesTabListTableViewController" isEqualToString:identifier] ||
         [@"JDClientCheckingViewController" isEqualToString:identifier] ||
         [@"JDYsqvKLineViewController" isEqualToString:identifier] ||
         [@"JDDayListViewController" isEqualToString:identifier]
         )&& !Quan_Xian(@"查看销售额权限")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"查看销售额权限",@"0")];
        return NO;
    }else if (([@"JDCollectionAccountViewController" isEqualToString:identifier] ||
               [@"JDSKQKTableViewController" isEqualToString:identifier] ||
               [@"JDClientCheckingViewController" isEqualToString:identifier] ) && !Quan_Xian(@"应收账款统计")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"应收账款统计",@"0")];
        return NO;
    }else if (([@"JDProfitViewController" isEqualToString:identifier]) && !Quan_Xian(@"经营利润表")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"经营利润表",@"0")];
        return NO;
    }
    
    
    
    return YES;
}


- (IBAction)gckcAction:(id)sender {
    JDGongChangKuCunViewController * vc = [[JDGongChangKuCunViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:vc animated:YES];
}
@end
