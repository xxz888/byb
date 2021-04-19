//
//  ADTool.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIView+Toast.h"
@interface ADTool : NSObject
//单例
+ (ADTool *)sharedInstance;
#pragma mark ========== 签名的方法 ==========
+(NSString*)encoingWithDic:(NSMutableDictionary*)dataDic;
#pragma mark ========== 字典转字符串 ==========
+(NSString *)dicConvertToNSString:(NSDictionary *)dict;
+(NSString *)countNumAndChangeformat:(NSString *)number;
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;
+ (NSString *)arrayConvertToNSString:(NSArray *)array;
@end
