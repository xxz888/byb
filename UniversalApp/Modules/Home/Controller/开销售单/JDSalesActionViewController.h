//
//  JDSalesActionViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectClientModel.h"
typedef void(^selectFinshClientBlock)(JDSelectClientModel * model);
typedef void(^changeClient)(JDSelectClientModel * model);

typedef void(^ShoukuankehuBlock)(void);
@interface JDSalesActionViewController : RootViewController
@property (nonatomic,copy) ShoukuankehuBlock shoukuankehuBlock;

@property (nonatomic,copy) selectFinshClientBlock selectFinshClientBlock;
@property (nonatomic,copy) changeClient changeClientBlock;
@property (nonatomic,strong) NSString * OpenType;
@property (nonatomic,strong) RootNavigationController * upnavigationController;

@end
