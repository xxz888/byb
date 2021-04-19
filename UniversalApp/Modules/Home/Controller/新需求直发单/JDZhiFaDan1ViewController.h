//
//  JDZhiFaDan1ViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/26.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectClientModel.h"
typedef void(^selectFinshClientBlock)(JDSelectClientModel * model);
typedef void(^changeClient)(JDSelectClientModel * model);
@interface JDZhiFaDan1ViewController : RootViewController

@property (nonatomic,copy) selectFinshClientBlock selectFinshClientBlock;
@property (nonatomic,copy) changeClient changeClientBlock;
@property (nonatomic,strong) NSString * OpenType;
@property (nonatomic,strong) RootNavigationController * upnavigationController;

@end
