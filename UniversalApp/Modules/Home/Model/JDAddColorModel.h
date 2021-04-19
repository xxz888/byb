//
//  JDAddColorModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseModel.h"

@interface JDAddColorModel : BaseModel
@property (nonatomic,assign) int  spid;//商品ID

@property (nonatomic,strong) NSString *sh;//色号（序号）

@property (nonatomic,strong) NSString *ys;//颜色

@property (nonatomic,assign) double kczsl;//库存总匹数

@property (nonatomic,assign) int  kczps;//库存总数量

@property (nonatomic,assign) double xsdj;//销售单价
@property (nonatomic,assign) double cbdj;//成本单价


@property (nonatomic,assign) double zdkc;
@property (nonatomic,assign) double zdsj;
@property (nonatomic,strong) NSString *cw;
@property (nonatomic,strong) NSString *cdys;


@property (nonatomic,strong) NSString *imgurl;//图片地址 ，有可能为空字符串
@property (nonatomic,strong) NSString * saveJinJiaPrice;//进价，需要临时写入
@property (nonatomic,strong) NSString * saveXiaoJiaPrice;//销价，需要临时写入



@property (nonatomic,strong) NSString * savePrice;//单价，需要临时写入
@property (nonatomic,strong) NSString * saveKhkh;//款号
@property (nonatomic,strong) NSString * savePishu;//匹数
@property (nonatomic,strong) NSString * saveBz;//备注
@property (nonatomic,strong) NSString * savekongcha;//空差

//这三个是一体的
@property (nonatomic,strong) NSString * saveDanWei;//单位
@property (nonatomic,strong) NSString * saveFuDanWei;//副单位
@property (nonatomic,strong) NSString * saveCount;//长度 就是米数
@property (nonatomic,strong) NSString * saveFuCount;//长度 就是米数
@property (nonatomic,assign) NSInteger  saveZhuFuTag;//用主还是用副

/**
 是否处于展开状态，默认NO
 */
@property(nonatomic, assign) BOOL isShowMore;

//现货单和退款单需要这是哪个
@property (nonatomic,strong) NSMutableArray * psArray;//匹数和数量的model;



@end
