//
//  UIColor+Extend.m
//  codeView
//
//  Created by Thinkive on 2017/11/19.
//  Copyright © 2017年 Thinkive. All rights reserved.
//

#import "UIColor+Extend.h"

@implementation UIColor (Extend)

+ (UIColor *)colorWithHex:(NSString *)colorStr {
    
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *)appBaseColor {
    return JDRGBAColor(153, 153, 153);//[UIColor colorWithHex:@"057ADC"];
}

+ (UIColor *)themeRedColor {
    return JDRGBAColor(153, 153, 153);//[UIColor colorWithHex:@"f53d3d"];
}

+ (UIColor *)disabledColor {
    return JDRGBAColor(153, 153, 153);
}

@end
