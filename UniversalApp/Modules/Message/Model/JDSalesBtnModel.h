//
//  JDSalesBtnModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/26.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseModel.h"

@interface JDSalesBtnModel : BaseModel

@property (nonatomic,strong) NSString *djlx;
@property (nonatomic,strong) NSString *djhm;
@property (nonatomic,strong) NSString *zdrq;
@property (nonatomic,strong) NSString *rzrq;
@property (nonatomic,strong) NSString *mdbm;
@property (nonatomic,strong) NSString *mdmc;
@property (nonatomic,strong) NSString *ckbm;
@property (nonatomic,strong) NSString *ckmc;
@property (nonatomic,strong) NSString *khbm;
@property (nonatomic,strong) NSString *khmc;
@property (nonatomic,strong) NSString *ywybm;
@property (nonatomic,strong) NSString *ywymc;

@property (nonatomic,strong) NSString *sphh;
@property (nonatomic,strong) NSString *spmc;


@property (nonatomic,assign) NSInteger mdid;
@property (nonatomic,assign) NSInteger ckid;
@property (nonatomic,assign) NSInteger khid;
@property (nonatomic,assign) NSInteger ywyid;
@property (nonatomic,assign) NSInteger xsps;
@property (nonatomic,assign) NSInteger cbqx;


@property (nonatomic,assign)  double  xssl;
@property (nonatomic,assign)  double xsje;
@property (nonatomic,assign)  double xscb;
@property (nonatomic,assign)  double xsml;

@property (nonatomic,assign)  double sxcb;

@property (nonatomic,assign) NSInteger yscount;



@end
