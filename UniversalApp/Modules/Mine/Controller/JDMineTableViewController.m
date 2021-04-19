//
//  JDMineTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDMineTableViewController.h"
#import "JDAllOrderViewController.h"
#import "JDKeHuListViewController.h"
#import "JDAllMdViewController.h"
#import "JDCKManagerViewController.h"
#import "JDYJFKViewController.h"
#import "JDLXKFViewController.h"
#import "JDDYManagerViewController.h"
#import "JDOtherSettingTableViewController.h"
#import "JDPersonCenterTableViewController.h"
#import "JDGYSListViewController.h"
@interface JDMineTableViewController ()

@end

@implementation JDMineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"[page] %@", NSStringFromClass(self.class));

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;

    [self requestData];
}

-(void)requestData{
    LoginModel * model = AD_USERDATAARRAY;
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":model.operatorid}];
    [AD_MANAGER requestAccTouXiangAction:mDic success:^(id object) {
        NSURL *url = [NSURL URLWithString:object[@"data"][@"tp"]];
        UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        weakself.titleImg.image = imagea;
        weakself.titleLbl.text = object[@"data"][@"ygmc"];
        weakself.mobileLbl.text = object[@"data"][@"sjhm"];
        weakself.titleImg.layer.cornerRadius = weakself.titleImg.size.width *0.5;
        weakself.titleImg.layer.masksToBounds =YES;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}
//个人中心
- (IBAction)personCenter:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDPersonCenterTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDPersonCenterTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)btnAction:(UIButton *)btn {
 
    if (btn.tag == 10) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
        VC.selectTag1 = 0;
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
#pragma mark ========== 客户管理 ==========

- (IBAction)kehuguanliAction:(id)sender {
    [REQUEST_PUSH_MANAGER qxPushKeHuVC:self.navigationController];
}
#pragma mark ========== 设置 ==========
- (IBAction)settingAction:(id)sender {
}
#pragma mark ========== 门店管理 ==========
- (IBAction)mdAction:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDAllMdViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllMdViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = MMD;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 优惠方式 ==========
- (IBAction)yhfsAction:(id)sender {
    [REQUEST_PUSH_MANAGER qxZheKouLeiXingVC:self.navigationController];

}
#pragma mark ========== 仓库管理 ==========
- (IBAction)ckAction:(id)sender {
    [REQUEST_PUSH_MANAGER qxPushCangKuDangAnVC:self.navigationController];
}
#pragma mark ========== 店员管理 ==========

- (IBAction)dyAction:(id)sender {
    [REQUEST_PUSH_MANAGER qxPushYuanGongDangAnVC:self.navigationController];
}
#pragma mark ========== 财务管理 ==========
- (IBAction)cwzhAction:(id)sender {
    [REQUEST_PUSH_MANAGER qxZhangHuGuanLiVC:self.navigationController];

}
#pragma mark ========== 其他设置 ==========

- (IBAction)qtSettingAction:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDOtherSettingTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDOtherSettingTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ========== 送货人==========

- (IBAction)shrAction:(id)sender {
    [REQUEST_PUSH_MANAGER qxSongHuoRenVC:self.navigationController];

}
#pragma mark ========== 电脑版本 ==========

- (IBAction)comVersionAction:(id)sender {
}
#pragma mark ========== 快速上手 ==========

- (IBAction)fastHandAction:(id)sender {
    
}

#pragma mark ========== 联系客服 ==========

- (IBAction)seriveAction:(id)sender {
    
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDLXKFViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDLXKFViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark ========== 反馈吐槽 ==========

- (IBAction)yjfkAction:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDYJFKViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDYJFKViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 供应商管理 ==========
- (IBAction)gysAction:(id)sender {
    [REQUEST_PUSH_MANAGER qxPushGongYingShangVC:self.navigationController];

}
#pragma mark ========== 商品管理 ==========
- (IBAction)shangpinguanliAction:(id)sender {
    [REQUEST_PUSH_MANAGER qxPushShangPin:self.tabBarController];
}

@end
