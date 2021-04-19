//
//  JDCKModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDCKModel : NSObject
@property (nonatomic,assign) BOOL select; //选择状态
@property (nonatomic,assign) NSInteger ckid;
@property (nonatomic,strong) NSString * ckmc;
@property (nonatomic,assign) NSInteger ygid;

@end
