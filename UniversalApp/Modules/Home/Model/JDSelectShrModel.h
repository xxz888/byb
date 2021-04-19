//
//  JDSelectShrModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseModel.h"

@interface JDSelectShrModel : BaseModel
@property (nonatomic,assign) int shrid;//送货人ID

@property (nonatomic,strong) NSString *shrbm;//送货人编码

@property (nonatomic,strong) NSString *shrmc;//送货人名称

@property (nonatomic,assign) int sfdj;//是否冻结 0:未 1:已

@property (nonatomic,strong) NSString *sjhm;//手机号码

@property (nonatomic,strong) NSString *bz;//备注






@end
