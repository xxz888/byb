
//
//  ADTool.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "ADTool.h"

@implementation ADTool
//单例
+ (instancetype)sharedInstance{
    static ADTool *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[ADTool alloc]init];
    });
    return s_instance;
}

+(NSString*)encoingWithDic:(NSMutableDictionary*)dataDic{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
    for (NSString * str in [dataDic allKeys]) {
        if ([[NSString stringWithFormat:@"%@",dataDic[str]] isEqualToString:@""]) {
            [dic removeObjectForKey:str];
        }
    }
    //1、请求参数key-value对按key升序排列
    NSArray *keys = [dic allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *returnStr = @"";
    //拼接字符串
    for (int i=0;i<sortedArray.count;i++){
        NSString *category = sortedArray[i];
    if (i==0) {
            returnStr =[NSString stringWithFormat:@"%@=%@",category,dic[category]];}else{
            returnStr = [NSString stringWithFormat:@"%@&%@=%@",returnStr,category,dic[category]];}
    }
    /*拼接上key得到stringSignTemp*/
    returnStr = [NSString stringWithFormat:@"%@%@",returnStr,urlKey];
    returnStr = [self md5:returnStr];
    return  returnStr;
}

+(NSString *)md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return  output;
}
+(NSString *)dicConvertToNSString:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    if (dict[@"secretcode"]) {
        
    }else{
//        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    }
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;

}
+ (NSString *)arrayConvertToNSString:(NSArray *)array

{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
+(NSString *)countNumAndChangeformat:(NSString *)number
{
    // 前缀
    NSString *prefix = @"￥";
    // 后缀
    NSString *suffix = @"";
    // 分隔符
    NSString *divide = @",";
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([number containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [number componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = number;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
    if (![prefix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",prefix,newNumber];
    }
    if (![suffix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",newNumber,suffix];
    }
    if ([newNumber containsString:@"-,"]) {
        newNumber = [newNumber replaceAll:@"-," target:@"-"];
    }
    return newNumber;
}
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
@end
