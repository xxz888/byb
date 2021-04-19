//
//  FontAndColorMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//字体大小和颜色配置

#ifndef FontAndColorMacros_h
#define FontAndColorMacros_h
#define JDRGBAColor(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define JDRGBAColor_alpha(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:0.1]


#pragma mark -  间距区

//默认间距
#define KNormalSpace 12.0f

#pragma mark -  颜色区
//主题色 导航栏颜色
#define CNavBgColor  [UIColor colorWithHexString:@"00AE68"]
//#define CNavBgColor  [Ulor colorWithHexString:@"ffffff"]
#define CNavBgFontColor  [UIColor colorWithHexString:@"ffffff"]

//默认页面背景色
#define CViewBgColor [UIColor colorWithHexString:@"f2f2f2"]

//分割线颜色
#define CLineColor [UIColor colorWithHexString:@"ededed"]

//次级字色
#define CFontColor1 [UIColor colorWithHexString:@"1f1f1f"]

//再次级字色
#define CFontColor2 [UIColor colorWithHexString:@"5c5c5c"]

#define COLOR_ARRAY @[\
[UIColor colorWithRed:90/255.0 green:154/255.0 blue:212/255.0 alpha:1],\
[UIColor colorWithRed:236/255.0 green:124/255.0 blue:48/255.0 alpha:1],\
[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1],\
[UIColor colorWithRed:253/255.0 green:192/255.0 blue:1/255.0 alpha:1],\
[UIColor colorWithRed:68/255.0 green:114/255.0 blue:196/255.0 alpha:1],\
[UIColor colorWithRed:162/255.0 green:211/255.0 blue:33/255.0 alpha:1],\
[UIColor colorWithRed:65/255.0 green:117/255.0 blue:5/255.0 alpha:1],\
[UIColor colorWithRed:253/255.0 green:0/255.0 blue:183/255.0 alpha:1],\
[UIColor colorWithRed:1/255.0 green:253/255.0 blue:236/255.0 alpha:1],\
[UIColor colorWithRed:41/255.0 green:118/255.0 blue:139/255.0 alpha:1]\
]

#pragma mark -  字体区


#define FFont1 [UIFont systemFontOfSize:12.0f]

#endif /* FontAndColorMacros_h */
