//
//  NSString+Datetime.h
//  GTS
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Datetime)

+(NSString *)getThisWeekFirstDay;

+ (NSString *)currentDateString;

- (NSDate *)dateWithFormat:(NSString *)source;

- (NSString *)dateWithFormat:(NSString *)source target:(NSString *)target;

- (NSString *)timeStampWithTarget:(NSString *)target;

- (NSString *)dateWithDaysAgo:(NSUInteger)days source:(NSString *)source;

- (NSString *)dateWithSecondsAgo:(NSTimeInterval)seconds source:(NSString *)source;

- (NSDate *)stringToDate:(NSString *)strdate;

- (NSString *)dateToString:(NSDate *)date;
//清空格式
- (NSString *)plainDate;
//20120619095532 ->20120619095532
- (NSString *) yyyyMMddHHmmss;
//20120619095532 ->201206190955
- (NSString *) yyyyMMddHHmm;
//20120619095532 ->20120619
- (NSString *) yyyyMMdd;
//20120619095532 ->0619
- (NSString *) yyMMdd;
//20120619095532 ->0619
- (NSString *) MMdd;
//20120619095532 ->095532
- (NSString *) HHmmss;
//095532 ->0955
- (NSString *) HHmm;
//20120619095532 ->20120619
- (NSString *) yyyyMMddHHmm:(NSString *)split;
//20120619095532 ->20120619
- (NSString *) yyyyMMddHHmmss:(NSString *)split;
// spilt=@"-"  20120619->2012-06-19
- (NSString *) yyyyMMdd:(NSString *)split;
//20120619095532 ->0619
- (NSString *) yyMMdd:(NSString *)split;
// spilt=@"-"  0619->06-19
- (NSString *) MMdd:(NSString *)split;

/**
 * 将字符转换成 NSDate
 */
- (NSDate *)convertDateWithFormat:(NSString *) format;

/**
 * 20120619 -> NSdate
 */
- (NSDate *)convertDateWithyyyyMMdd;

/**
 * 20120619112330 -> NSdate
 */
- (NSDate *)convertDateWithyyyyMMddHHmmss;


+ (NSString *)currentDateStringyyyyMMdd;
+ (NSString *)currentDateStringHHmmss;
+ (NSString *)getThisYearFirstDay;
+ (NSString *)getCurrentDate;
+(NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr;
+ (NSString *)getUpMouth;//上月
+(NSArray *)getUpWeek;//上周
+(NSArray *)getThisYear;//今年
@end
