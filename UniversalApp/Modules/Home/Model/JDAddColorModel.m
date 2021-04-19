
//
//  JDAddColorModel.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddColorModel.h"

@implementation JDAddColorModel
#pragma mark --------------------初始化数据--------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        _psArray = [NSMutableArray array];
        _isShowMore = NO;
        _saveZhuFuTag = 0;
    }
    return self;
}

- (void)setSavePrice:(NSString *)savePrice
{
    _savePrice = savePrice;
}
@end
