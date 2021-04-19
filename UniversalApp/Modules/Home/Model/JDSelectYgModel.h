//
//  JDSelectYgModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseModel.h"

@interface JDSelectYgModel : BaseModel
@property (nonatomic,assign) int ygid   ;//员工ID

@property (nonatomic,strong) NSString *ygbm;//员工编码

@property (nonatomic,strong) NSString *ygmc;//员工名称

@property (nonatomic,strong) NSString *sjhm;//手机号码

@property (nonatomic,assign) int sfdj;//是否冻结 0:未 1:已


@property (nonatomic,strong) NSString *ssmdmc;//布行


@end
