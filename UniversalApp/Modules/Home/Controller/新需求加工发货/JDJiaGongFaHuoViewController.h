//
//  JDJiaGongFaHuoViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectClientModel.h"
typedef void(^selectFinshClientBlock)(JDSelectClientModel * model);
typedef void(^changeClient)(JDSelectClientModel * model);
NS_ASSUME_NONNULL_BEGIN

@interface JDJiaGongFaHuoViewController : RootViewController
@property (nonatomic,copy) selectFinshClientBlock selectFinshClientBlock;
@property (nonatomic,copy) changeClient changeClientBlock;
@property (nonatomic,strong) NSString * OpenType;
@property (nonatomic,strong) RootNavigationController * upnavigationController;
@end

NS_ASSUME_NONNULL_END
