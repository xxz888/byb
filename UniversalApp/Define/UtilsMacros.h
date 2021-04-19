//
//  define.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

// 全局工具类宏定义

#ifndef define_h
#define define_h

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

#define Iphone6ScaleWidth KScreenWidth/375.0
#define Iphone6ScaleHeight KScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kRealValue(with) ((with)*(KScreenWidth/375.0f))

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//property 属性快速声明 别用宏定义了，使用代码块+快捷键实现吧

// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言
#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//颜色
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成

//字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


//定义UIImage对象
#define ImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define IMAGE_NAMED(name) [UIImage imageNamed:name]





//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)
//打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)


//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}







#define CCK @"cck"
#define CCWGL @"cwgl"
#define SSHR @"shr"
#define YYHFS @"yhfs"
#define MMD @"mmd"
// 在主线程中执行
#define DO_IN_MAIN_QUEUE(action) dispatch_async(dispatch_get_main_queue(), action)
// 在主线程中延迟执行
#define DO_IN_MAIN_QUEUE_AFTER(seconds, action) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), action)
/**
 * 数据类型转 NSString
 */
#define intToNSString(x) [NSString stringWithFormat:@"%d", (x)]
#define floatToNSString(x) [NSString stringWithFormat:@"%f", (x)]
#define doubleToNSString(x) [NSString stringWithFormat:@"%.2f", (x)]
#define CGFloatToNSString(x) [NSString stringWithFormat:@"%f", (x)]
#define NSUIntegerToNSString(x) [NSString stringWithFormat:@"%lu", (long)(x)]
#define NSIntegerToNSString(x) [NSString stringWithFormat:@"%ld", (long)(x)]
#define kGetString(NSNumber)  [NSString stringWithFormat:@"%@",NSNumber]
#define kGetNSInteger(NSInteger) [NSString stringWithFormat:@"%ld",NSInteger]
#define kGet2fDouble(Double) [NSString stringWithFormat:@"%.1f",Double]

#define CCHANGE(str) [ADTool countNumAndChangeformat:doubleToNSString([str doubleValue])]
#define CCHANGE_DOUBLE(double) [ADTool countNumAndChangeformat:doubleToNSString(double)]

#define CCHANGE_OTHER(str) doubleToNSString([str doubleValue])
#define CCHANGE_OTHER_DOUBLE(double) doubleToNSString(double)

/**
 * iif
 */
#if !defined(IIF)
#define IIF_IMPL(condition,true_,false_) (condition)?true_:false_
#define IIF(condition,true_,false_) IIF_IMPL(condition,true_,false_)
#endif

#define IS_UISCREEN_SIZE(width, height) ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake((width),(height)), [[UIScreen mainScreen] currentMode].size) : NO)
/**
 * 设备类型
 */
#define SCREEN_TYPE                     IIF(IS_UISCREEN_SIZE(320, 480), DeviceTypeIPhone4, IIF(IS_UISCREEN_SIZE(640, 960), DeviceTypeIPhone4s, IIF(IS_UISCREEN_SIZE(640, 1136), DeviceTypeIPhone5, IIF(IS_UISCREEN_SIZE(750, 1334), DeviceTypeIPhone6, IIF(IS_UISCREEN_SIZE(1242, 2208), DeviceTypeIPhone6plus, DeviceTypeNone)))))
#endif /* define_h */
