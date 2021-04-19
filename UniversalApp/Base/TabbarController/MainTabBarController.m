//
//  MainTabBarController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "MainTabBarController.h"

#import "RootNavigationController.h"
#import "HomeViewController.h"
#import "WaterFallListViewController.h"
#import "PersonListViewController.h"
#import "MakeFriendsViewController.h"
#import "MsgViewController.h"
#import "MineViewController.h"
#import "ToolDemoViewController.h"
#import "DraggingCardViewController.h"
#import "UITabBar+CustomBadge.h"
#import "XYTabBar.h"
#import "JDHomeViewController.h"
#import "JDThirdTableViewController.h"
#import "KBTabbar.h"
#import "JDThirdTableViewController.h"
#import "JDMiddleBtnViewController.h"
#import "JDSecondViewController.h"
#import "JDMineTableViewController.h"
@interface MainTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC

@end

@implementation MainTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //初始化tabbar
    //[self setUpTabBar];
    //添加子控制器
    //[self setUpAllChildViewController];
    
    _VCS = @[].mutableCopy;

    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDHomeViewController * VC1 = [stroryBoard1 instantiateViewControllerWithIdentifier:@"JDHomeViewController"];
    [self setupChildViewController:VC1 title:@"首页" imageName:@"icon_shouye2" seleceImageName:@"icon_shouye1"];
    
    
    UIStoryboard * stroryBoard2 = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDSecondViewController * VC2 = [stroryBoard2 instantiateViewControllerWithIdentifier:@"JDSecondViewController"];
    [self setupChildViewController:VC2 title:@"商品" imageName:@"icon_shangpin2" seleceImageName:@"icon_shangpin1"];
    
    
    UIStoryboard * stroryBoard3 = [UIStoryboard storyboardWithName:@"ThirdVC" bundle:nil];
    JDThirdTableViewController* VC3 = [stroryBoard3 instantiateViewControllerWithIdentifier:@"JDThirdTableViewController"];
    [self setupChildViewController:VC3 title:@"统计" imageName:@"icon_tongji2" seleceImageName:@"icon_tongji1"];
    
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDMineTableViewController* VC4 = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDMineTableViewController"];
    [self setupChildViewController:VC4 title:@"我的" imageName:@"icon_wode2" seleceImageName:@"icon_wode1"];
    
    
    
        self.viewControllers = _VCS;
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:JDRGBAColor(255, 255, 255)]];
    //  设置tabbar
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];

//    [self.tabBarController.tabBar setShadowImage:[self imageWithColor:JDRGBAColor(255, 255, 255) size:CGSizeMake(KScreenWidth, 0.5)]];
    
    UIImageView * imgV = [[UIImageView alloc]init];
    imgV.backgroundColor = KBlackColor;
    imgV.frame = CGRectMake(0, 1, KScreenWidth, 0.5);
    [self.tabBarController.tabBar addSubview:imgV];
    // 设置自定义的tabbar
    [self setCustomtabbar];
    
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    //设置背景色 去掉分割线
    [self setValue:[XYTabBar new] forKey:@"tabBar"];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    //通过这两个参数来调整badge位置
    //    [self.tabBar setTabIconWidth:29];
    //    [self.tabBar setBadgeTop:9];
}

#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
//    HomeViewController *homeVC = [[HomeViewController alloc]init];
//    WaterFallListViewController *homeVC = [WaterFallListViewController new];
    
    
    
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDHomeViewController * VC1 = [stroryBoard1 instantiateViewControllerWithIdentifier:@"JDHomeViewController"];
    [self setupChildViewController:VC1 title:@"首页" imageName:@"icon_tabbar_homepage" seleceImageName:@"icon_tabbar_homepage_selected"];

    
    
//    MakeFriendsViewController *makeFriendVC = [[MakeFriendsViewController alloc]init];
    ToolDemoViewController *makeFriendVC = [[ToolDemoViewController alloc]init];
    [self setupChildViewController:makeFriendVC title:@"Demo" imageName:@"icon_tabbar_onsite" seleceImageName:@"icon_tabbar_onsite_selected"];
    
//    MsgViewController *msgVC = [[MsgViewController alloc]init];
    
    UIStoryboard * stroryBoard3 = [UIStoryboard storyboardWithName:@"ThirdVC" bundle:nil];
    JDThirdTableViewController * VC3 = [stroryBoard3 instantiateViewControllerWithIdentifier:@"JDThirdTableViewController"];
    [self setupChildViewController:VC3 title:@"消息" imageName:@"icon_tabbar_merchant_normal" seleceImageName:@"icon_tabbar_merchant_selected"];
    
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"icon_tabbar_mine" seleceImageName:@"icon_tabbar_mine_selected"];
    
    self.viewControllers = _VCS;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JDRGBAColor(153, 153, 153),NSFontAttributeName:SYSTEMFONT(11.0f)} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JDRGBAColor(0, 163, 255),NSFontAttributeName:SYSTEMFONT(11.0f)} forState:UIControlStateSelected];
    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    
//    [self addChildViewController:nav];
    [_VCS addObject:nav];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.viewControllers[1] ) {
        if (!Quan_Xian(@"商品档案")) {
            [UIView showToast:QUANXIAN_ALERT_STRING(@"商品档案",@"0")];
            return NO;
        }else{
            return YES;
        }
    }else{
          return YES;
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //    NSLog(@"选中 %ld",tabBarController.selectedIndex);

    [tabBarController.tabBar setHidden:NO];
}

-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow{
    if (isShow) {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:0 atIndex:index];
    }else{
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:index];
    }
    
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ========== 订制tabbar ==========
- (void)setCustomtabbar{
    
    KBTabbar *tabbar = [[KBTabbar alloc]init];
    
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    [tabbar.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)centerBtnClick:(UIButton *)btn{
    kWeakSelf(self);
     [UIView animateWithDuration:0.5 animations:^{
         JDMiddleBtnViewController * VC = [JDMiddleBtnViewController new];
         weakself.definesPresentationContext = YES;
         VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
         VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
         [weakself presentViewController:VC animated:NO completion:nil];
     }];
    
    
    
    
}

- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc
{
    
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }forState:UIControlStateSelected];
    
    UINavigationController* nav = [[navVc alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}


- (UIImage *)imageWithColor:(UIColor *)color{
    // 一个像素
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
