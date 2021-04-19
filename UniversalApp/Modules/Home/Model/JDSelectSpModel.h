//
//  JDSelectSpModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseModel.h"

@interface JDSelectSpModel : BaseModel
/*
 "spid": 1,
 "spbm": "1",
 "spmc": "老年人小花布1",
 "zjf": null,
 "sfdj": 0,
 "spflid": null,
 "spflmc": null,
 "sphh": "SY-ZZML-1",
 "spjc": "针织面料",
 "jldw": "米",
 "fslbl":1.0,
 "fjldw": null,
 "gysid": 1,
 "gysbm": "1",
 "gysmc": "上衣面料供应商",
 "gyshh": null,
 "gysbz": null,
 "fk": null,
 "kz": null,
 "cf": null,
 "mgjm": null,
 "bzsj": null,
 "zdsj": null,
 "skwz": null,
 "bz": null,
 "jdrq": null,
 "jdrid": null,
 "jdrbm": null,
 "jdrmc": null,
 "bgrq": null,
 "bgrid": null,
 "bgrbm": null,
 "bgrmc": null
 */
@property (nonatomic,assign) int spid;//商品ID

@property (nonatomic,strong) NSString *spbm;//商品编码

@property (nonatomic,strong) NSString *spmc;//商品名称

@property (nonatomic,strong) NSString *sphh;//货号

@property (nonatomic,strong) NSString *jldw;//单位

@property (nonatomic,strong) NSString *spjc;//简称

@property (nonatomic,assign) int gysid;//供应商ID

@property (nonatomic,strong) NSString *gysbm;//供应商编码

@property (nonatomic,strong) NSString *gysmc;//供应商名称

@property (nonatomic,assign) int sfdj;//是否冻结 0:未 1:已

@property (nonatomic,assign) double fslbl;//辅数量比率


@property (nonatomic,assign) double spsl;//库存数

@property (nonatomic,strong) NSString *fjldw;//单位

//自己定义的
@property (nonatomic,assign) BOOL have;
@end
