//
//  MainTabBarController.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 底部 TabBar 控制器
 */
@interface MainTabBarController : UITabBarController

/**
 设置小红点
 
 @param index tabbar下标
 @param isShow 是显示还是隐藏
 */
-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow;
/** 遮罩 */
@property(strong, nonatomic) UIView *fullMaskView;
/** scrollView */
@property(strong, nonatomic) UIScrollView                   *scrGuide;
/** controller */
@property(strong, nonatomic) UIPageControl                  *pgGuide;
/** 毛玻璃遮罩 */
@property(strong, nonatomic) UIImageView                    *ivBackground;
@end
