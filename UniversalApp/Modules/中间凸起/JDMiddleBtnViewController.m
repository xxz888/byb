//
//  JDMiddleBtnViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/25.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDMiddleBtnViewController.h"
#import "JDSalesActionViewController.h"
#import "JDHomeViewController.h"
#import "JDMiddleHistoryTableViewController.h"
#import "JDNewAddShouKuanTableViewController.h"
#import "JDSalesTagViewController.h"
#import "JDZhiFaDan1ViewController.h"
#import "JDZhiFaDan4ViewController.h"
@interface JDMiddleBtnViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation JDMiddleBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imgUnderTextBottom:self.btn1];
    [self imgUnderTextBottom:self.btn2];
    [self imgUnderTextBottom:self.btn3];
    [self imgUnderTextBottom:self.btn4];
    [self imgUnderTextBottom:self.btn5];
    [self imgUnderTextBottom:self.btn6];
    [self imgUnderTextBottom:self.btn7];
    [self imgUnderTextBottom:self.btn8];
    [self imgUnderTextBottom:self.btn9];

}
-(void)imgUnderTextBottom:(UIButton *)focusBtn{
    
    focusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [focusBtn setTitleEdgeInsets:UIEdgeInsetsMake(focusBtn.imageView.frame.size.height ,-focusBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [focusBtn setImageEdgeInsets:UIEdgeInsetsMake(-focusBtn.imageView.frame.size.height, 0.0,0.0, -focusBtn.titleLabel.bounds.size.width)];


    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
//预定单
- (IBAction)btn1Action:(id)sender {
    pushYuDingDan([self commonAction]);
}
//销售单
- (IBAction)btn2Action:(id)sender {
    pushXiaoShouDan([self commonAction]);
}
//样品单
- (IBAction)btn3Action:(id)sender {
    pushYangPinDan([self commonAction]);
}
//退货单
- (IBAction)btn4Action:(id)sender {
    pushTuiHuoDan([self commonAction]);
}
//采购入库单
- (IBAction)btn6Action:(id)sender {
    pushCaiGouRuKuDan([self commonAction]);
}
//采购退货单
- (IBAction)btn7Action:(id)sender {
    pushCaiGouTuiHuoDan([self commonAction]);
}
//收款单
- (IBAction)btn5Action:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    pushShouKuanDan((MainTabBarController *)self.presentingViewController);
}
//开付款单
- (IBAction)btn8Action:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    pushFuKuanDan((MainTabBarController *)self.presentingViewController);
}
//直发单
- (IBAction)btn9Action:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    pushZhifaDan([self commonAction]);
}
-(void)moneyAction{
    REMOVE_ALL_CACHE;

    MainTabBarController * tabbar = (MainTabBarController *)self.presentingViewController;
    RootNavigationController * nav = tabbar.childViewControllers[tabbar.selectedIndex];
    UIViewController * homeVC =  nav.childViewControllers[0];
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDNewAddShouKuanTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDNewAddShouKuanTableViewController"];
    VC.noteno = @"";
    VC.hidesBottomBarWhenPushed = YES;
    [homeVC.navigationController pushViewController:VC animated:YES];
}






- (IBAction)historyAction:(id)sender {


    [self dismissViewControllerAnimated:NO completion:nil];
    REMOVE_ALL_CACHE;
    MainTabBarController * tabbar = (MainTabBarController *)self.presentingViewController;
    RootNavigationController * nav = tabbar.childViewControllers[tabbar.selectedIndex];
    UIViewController * homeVC =  nav.childViewControllers[0];
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDMiddleHistoryTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDMiddleHistoryTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [homeVC.navigationController pushViewController:VC animated:YES];
}

- (IBAction)cancleAction:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(UINavigationController *)commonAction{
    [self dismissViewControllerAnimated:NO completion:nil];
    REMOVE_ALL_CACHE;
    MainTabBarController * tabbar = (MainTabBarController *)self.presentingViewController;
    RootNavigationController * nav = tabbar.childViewControllers[tabbar.selectedIndex];
    UIViewController * homeVC =  nav.childViewControllers[0];
    return homeVC.navigationController;
}
@end
