//
//  JDAddNewGYSLxrViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/7.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
typedef void(^lxrSend)(id object);
@interface JDAddNewGYSLxrViewController : RootViewController
@property (nonatomic,assign) NSInteger gysid;
@property (nonatomic,assign) NSInteger khid;

@property (nonatomic,copy) lxrSend lxrBlock;
@property (nonatomic,assign) BOOL whereCome;
@property (nonatomic,strong)NSMutableArray * dataSource;


@property (nonatomic,assign) BOOL khOrGysBOOL;//客户进来还是供应商
@end
