//
//  JDSelectCkPageModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseModel.h"

@interface JDSelectCkPageModel : BaseModel
@property (nonatomic,assign) int ckid;//仓库ID

@property (nonatomic,strong) NSString *ckbm;//仓库编码

@property (nonatomic,strong) NSString *ckmc;//仓库名称

@property (nonatomic,assign) int cklx;//仓库类型

@property (nonatomic,strong) NSString *lxdh;//联系电话

@property (nonatomic,assign) int sfdj;//是否冻结 0:未 1:已




@end
