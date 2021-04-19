//
//  JDDingJinViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
typedef void(^dingjinBlock)(double);
typedef void(^dicBlock)(NSArray *);
@interface JDDingJinViewController : RootViewController
@property (nonatomic,copy) dingjinBlock block;
@property (nonatomic,copy) dicBlock dicBlock;
@property (nonatomic,strong) NSMutableArray * payArray;

@end
