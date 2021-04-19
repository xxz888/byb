//
//  JDDayListModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseModel.h"

@interface JDDayListModel : BaseModel


@property (nonatomic,assign) NSInteger xs_djsl;//销售
@property (nonatomic,assign) NSInteger xs_xsps;
@property (nonatomic,assign) double xs_xssl;
@property (nonatomic,assign) double xs_xsje;
@property (nonatomic,assign) double xs_xsml;
@property (nonatomic,assign) double xs_xsje_beforeday;


@property (nonatomic,assign) NSInteger xsdd_djsl;//预定
@property (nonatomic,assign) NSInteger xsdd_xsps;
@property (nonatomic,assign) double xsdd_xssl;
@property (nonatomic,assign) double xsdd_xsje;
@property (nonatomic,assign) double xsdd_xsje_beforeday;


@property (nonatomic,assign) NSInteger xsth_djsl;//退货
@property (nonatomic,assign) NSInteger xsth_xsps;
@property (nonatomic,assign) double xsth_xssl;
@property (nonatomic,assign) double xsth_xsje;


@property (nonatomic,assign) NSInteger spck_djsl;//出库
@property (nonatomic,assign) NSInteger spck_xsps;
@property (nonatomic,assign) double spck_xssl;


@property (nonatomic,assign) NSInteger kc_spps;//库存
@property (nonatomic,assign) double kc_spsl;
@property (nonatomic,assign) NSInteger bjcount;

@property (nonatomic,assign) double ys_zjje;//新增应收
@property (nonatomic,assign) double ys_jsje;//实收
@property (nonatomic,assign) double ys_ysje;//应收金额


@end
