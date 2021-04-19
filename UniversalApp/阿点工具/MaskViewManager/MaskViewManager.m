//
//  MaskViewManager.m
//  GTS
//
//  Created by lengyc on 11/11/14.
//  Copyright (c) 2014 TES. All rights reserved.
//

#import "MaskViewManager.h"
//#import "AppDelegate.h"
#import "MBProgressHUD.h"

//#import "SVProgressHUD.h"

// 加载动画 gif
#define LOADING_GIF                                      @"network_loading.gif"

@interface MaskViewManager () <MBProgressHUDDelegate>

@property(assign, nonatomic) NSUInteger showCount;
@property(strong, nonatomic) MBProgressHUD *progressHUD;
@end

@implementation MaskViewManager

/******************************************************************************
 *  单例模式
 ******************************************************************************/

static MaskViewManager * _sharedInstance = nil;

+ (id)allocWithZone:(struct _NSZone *)zone
{    @synchronized(self)
    {
        if (!_sharedInstance)
        {
            _sharedInstance = [super allocWithZone:zone];
        }
    }
    return _sharedInstance;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _sharedInstance;
}

/**
 * 获取遮罩对象的实例
 */
+ (MaskViewManager *)sharedMaskViewManager
{
    @synchronized(self) {
        if(nil == _sharedInstance){
            _sharedInstance = [[super allocWithZone:NULL] init];
            _sharedInstance.showCount = 0;
        }
    }
    
    return _sharedInstance;
}

/******************************************************************************
 *  Public/Protected Method Implementation.
 ******************************************************************************/

/**
 * 显示遮罩
 */
+ (void)show
{
    
     dispatch_async(dispatch_get_main_queue(), ^{
         
         
         if(nil == _sharedInstance)
         {
             return;
         }
         
         if(_sharedInstance.showCount <= 0)
         {
             _sharedInstance.showCount = 0;
         }
         
         _sharedInstance.showCount++;
         
         UIWindow *window = [_sharedInstance getWindow];
         
         if (nil == _sharedInstance.progressHUD)
         {
             _sharedInstance.progressHUD = [[MBProgressHUD alloc] initWithView:window];
             _sharedInstance.progressHUD.delegate = _sharedInstance;
             // 设置显示自定义 View
             [_sharedInstance.progressHUD setMode:MBProgressHUDModeIndeterminate];
             // 设置背景色
             //        [_sharedInstance.progressHUD setColor:[UIColor blackColor]];
             //        // 自定义加载图
             //        UIImageView *imgLoading = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
             //        imgLoading.backgroundColor = [UIColor clearColor];
             //        imgLoading.layer.masksToBounds = YES;
             //        // 圆角
             //        imgLoading.layer.cornerRadius = 25.0f;
             //
             //        [imgLoading loadingAnimate];
             //
             //        _sharedInstance.progressHUD.customView = imgLoading;
             //        _sharedInstance.progressHUD.labelText = @"加载中...";
             [_sharedInstance.progressHUD setNeedsLayout];
             [_sharedInstance.progressHUD layoutIfNeeded];
             //        [SVProgressHUD setViewForExtension:imgLoading];
         }
         
         if (nil == _sharedInstance.progressHUD.superview)
         {
             [window addSubview:_sharedInstance.progressHUD];
         }
         [window bringSubviewToFront:_sharedInstance.progressHUD];
         
         [_sharedInstance.progressHUD showAnimated:YES];
         //    [SVProgressHUD show];
         
         //    NSLog(@"showMaskCount : %d", (int)_sharedInstance.showCount);
     });
    
}

/**
 * 隐藏遮罩
 */
+ (void)hide
{
//    [MaskViewManager forceHide];
    
    if(nil == _sharedInstance)
    {
        return;
    }
    
    if(_sharedInstance.showCount <= 0)
    {
        _sharedInstance.showCount = 0;
        return;
    }
    
    _sharedInstance.showCount--;
    
    if(_sharedInstance.showCount <= 0)
    {
        [MaskViewManager forceHide];
    }
    
//    NSLog(@"showMaskCount : %d", (int)_sharedInstance.showCount);
}

/**
 *  强制隐藏遮罩
 */
+ (void)forceHide
{
//    NSLog(@"%s", __FUNCTION__);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(nil == _sharedInstance)
        {
            return;
        }
        
        _sharedInstance.showCount = 0;
//        [SVProgressHUD dismiss];
        [_sharedInstance.progressHUD hideAnimated:YES];
    });
}

/******************************************************************************
 *  Private Method Implementation.
 ******************************************************************************/

- (UIWindow *)getWindow
{
    return [UIApplication sharedApplication].delegate.window;
}

/******************************************************************************
 *  MBProgressHUDDelegate Implementation Call Back.
 ******************************************************************************/

- (void)hudWasHidden:(MBProgressHUD *)hud
{
//    NSLog(@"%s", __FUNCTION__);
    
    // Remove HUD from screen when the HUD was hidded
    [self.progressHUD removeFromSuperview];
    self.progressHUD = nil;
}
@end
