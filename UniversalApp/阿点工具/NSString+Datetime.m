//
//  NSString+Datetime.m
//  GTS
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "NSString+Datetime.h"
#import "NSDate+Convert.h"

static NSDateFormatter *SourceDateFormatter;
static NSDateFormatter *TargetDateFormatter;

@implementation NSString (Datetime)

+ (void)sharedDateFormatter {
    if(!SourceDateFormatter || !TargetDateFormatter){
        SourceDateFormatter = [[NSDateFormatter alloc] init];
        TargetDateFormatter = [[NSDateFormatter alloc] init];
    }
}

+ (NSString *)currentDateString
{
    //实例化一个NSDateFormatter对象
    [NSString sharedDateFormatter];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [SourceDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [SourceDateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}
+ (NSString *)currentDateStringyyyyMMdd
{
    //实例化一个NSDateFormatter对象
    [NSString sharedDateFormatter];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [SourceDateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [SourceDateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}
+ (NSString *)currentDateStringyyyy
{
    //实例化一个NSDateFormatter对象
    [NSString sharedDateFormatter];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [SourceDateFormatter setDateFormat:@"yyyy"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [SourceDateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}
+ (NSString *)currentDateStringHHmmss
{
    //实例化一个NSDateFormatter对象
    [NSString sharedDateFormatter];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [SourceDateFormatter setDateFormat:@"HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [SourceDateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}


- (NSDate *)dateWithFormat:(NSString *)source{
    //实例化一个NSDateFormatter对象
    [NSString sharedDateFormatter];
    
    [SourceDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    SourceDateFormatter.dateFormat = source;
    
    return [SourceDateFormatter dateFromString:self];
}

- (NSString *) dateWithFormat:(NSString *)source target:(NSString *)target
{
    //实例化一个NSDateFormatter对象
    [NSString sharedDateFormatter];
    
    [SourceDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    SourceDateFormatter.dateFormat = source;
    
    [TargetDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    TargetDateFormatter.dateFormat = target;
    
    NSString *str = [TargetDateFormatter stringFromDate: [SourceDateFormatter dateFromString:self]];

    if (str == nil) {
        return @"";
    }else {
        return str;
    }
}

- (NSString *)timeStampWithTarget:(NSString *)target{
    NSLog(@"print time %@", self);
    //实例化一个NSDateFormatter对象
    [NSString sharedDateFormatter];
    
    [TargetDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [TargetDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [TargetDateFormatter setDateFormat:target];
    
    NSDate *date = [self dateWithFormat: target];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    
    NSString *str = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]*1000];
    
    if (str == nil) {
        return @"";
    } else {
        return str;
    }
}

- (NSString *)dateWithDaysAgo:(NSUInteger)days source:(NSString *)source{
    NSDate *baseDate = [self dateWithFormat: source];

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];

    [components setHour:-24*days];
    [components setMinute:0];
    [components setSecond:0];

    NSDate *dateAgo = [cal dateByAddingComponents:components toDate: baseDate options:0];

    return [dateAgo convertDateWithFormat:source];
}

- (NSString *)dateWithSecondsAgo:(NSTimeInterval)seconds source:(NSString *)source{
    NSDate *baseDate = [self dateWithFormat: source];

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];

    [components setHour:0];
    [components setMinute:0];
    [components setSecond:seconds*-1];

    NSDate *dateAgo = [cal dateByAddingComponents:components toDate: baseDate options:0];

    return [dateAgo convertDateWithFormat:source];
}
/**
 * 将字符转换成 NSDate
 */
- (NSDate *)convertDateWithFormat:(NSString *) format{
    //实例化一个NSDateFormatter对象
    [NSString sharedDateFormatter];
    
    // 比较时间
    [TargetDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    TargetDateFormatter.dateFormat = format;
    return [TargetDateFormatter dateFromString:self];
}

- (NSString *)plainDate
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"/" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"年" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"月" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"日" withString:@""];
    return str;
}

- (NSString *) yyyyMMddHHmmss
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"yyyyMMddHHmmss"];
}

- (NSString *) yyyyMMddHHmm
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"yyyyMMddHHmm"];
}

- (NSString *) yyyyMMdd
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"yyyyMMdd"];
}

- (NSString *) yyMMdd
{
    return [[self plainDate] dateWithFormat:@"yyyyMMdd" target:@"yyMMdd"];
}

- (NSString *) MMdd
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"MMdd"];
}

- (NSString *) HHmmss
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"HHmmss"];
}

- (NSString *) HHmm
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:@"HHmm"];
}

- (NSString *) yyyyMMddHHmm:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmm" target:[NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm",split,split]];
}

- (NSString *) yyyyMMddHHmmss:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"yyyyMMddHHmmss" target:[NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm:ss",split,split]];
}

- (NSString *) yyyyMMdd:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"yyyyMMdd" target:[NSString stringWithFormat:@"yyyy%@MM%@dd",split,split]];
}

- (NSString *) yyMMdd:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"yyyyMMdd" target:[NSString stringWithFormat:@"yy%@MM%@dd",split,split]];
}

- (NSString *) MMdd:(NSString *)split
{
    return [[self plainDate] dateWithFormat:@"MMdd" target:[NSString stringWithFormat:@"MM%@dd",split]];
}

/**
 * 将字符转换成 NSDate
 */
//- (NSDate *)convertDateWithFormat:(NSString *) format{
//    //实例化一个NSDateFormatter对象
//    [NSString sharedDateFormatter];
//    
//    // 比较时间
//    [TargetDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
//    TargetDateFormatter.dateFormat = format;
//    return [TargetDateFormatter dateFromString:self];
//}

/**
 * 20120619 -> NSdate
 */
- (NSDate *)convertDateWithyyyyMMdd{
    return [self convertDateWithFormat:@"yyyyMMdd"];
}

/**
 * 20120619112330 -> NSdate
 */
- (NSDate *)convertDateWithyyyyMMddHHmmss{
    return [self convertDateWithFormat:@"yyyyMMddHHmmss"];
}

+ (NSString *)getThisWeekFirstDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSWeekdayCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [dateComponents weekday];   //第几天(从sunday开始)
    NSInteger firstDiff,lastDiff;
    if (weekday == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else {
        firstDiff =  - weekday + 2;
        lastDiff = 8 - weekday;
    }
    NSInteger day = [dateComponents day];
    NSDateComponents *firstComponents = [calendar components:NSWeekdayCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    [firstComponents setDay:day+firstDiff];
    NSDate *firstDay = [calendar dateFromComponents:firstComponents];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *firstString = [format stringFromDate: firstDay];

    return firstString;
}

+ (NSString *)getThisYearFirstDay{
    NSString *year = [self currentDateStringyyyy];
    year = [year stringByAppendingFormat:@"-01-01"];
    return year;
}

+ (NSString *)getCurrentDate{
    // format 的初始化是一个高消耗的操作，同一个格式化器应该只初始化一次
    static NSDateFormatter *format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
    });
    return [format stringFromDate:[NSDate date]];
}

+(NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }else {
        return @[@"",@""];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstString = [myDateFormatter stringFromDate: firstDate];
    NSString *lastString = [myDateFormatter stringFromDate: lastDate];
    return @[firstString, lastString];
}
+ (NSString *)getUpMouth
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    return dateStr;
}

+(NSArray *)getUpWeek{
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit| NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:nowDate];
    
    //获取今天是周几
    NSInteger weekDay = [comp weekday];
    //获取某天是几号
    NSInteger day = [comp day];
    
    //计算当前日期和上周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        
        firstDiff = -13;
        lastDiff = 0;
    }
    else{
        
        firstDiff = [calendar firstWeekday] - weekDay +1-7;
        lastDiff = 8 - weekDay;
    }
    
    //在当前日期基础上加上时间差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    NSString *lastDay = [firstDay dateWithDaysAgo:-6 source:@"yyyy-MM-dd"];
    
    
    return @[firstDay,lastDay];
}
+(NSArray *)getThisYear
{
    //通过2月天数的改变，来确定全年天数
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    dateStr = [dateStr stringByAppendingString:@"-02-14"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *aDayOfFebruary = [formatter dateFromString:dateStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSYearCalendarUnit startDate:&firstDay interval:nil forDate:[NSDate date]];
    NSDateComponents *lastDateComponents = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit fromDate:firstDay];
    NSUInteger dayNumberOfFebruary = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDayOfFebruary].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+337+dayNumberOfFebruary];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}

@end
