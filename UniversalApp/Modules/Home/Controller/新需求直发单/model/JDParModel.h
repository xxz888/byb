//
//  JDParModel.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/1.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JDModel1.h"
#import "JDModel2.h"
#import "JDModel3.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDParModel : NSObject
@property (nonatomic,strong) NSString *ywyid;
@property (nonatomic,strong) NSString *shr;
@property (nonatomic,strong) NSString *djzt;
@property (nonatomic,strong) NSString *rzrq;
@property (nonatomic,strong) NSString *rzsj;
@property (nonatomic,strong) NSString *bjmc;
@property (nonatomic,strong) NSString *gysid;
@property (nonatomic,strong) NSString *shdz;
@property (nonatomic,strong) NSString *dycs;
@property (nonatomic,strong) NSString *ckid;
@property (nonatomic,strong) NSString *xsddh;
@property (nonatomic,strong) NSString *djhm;
@property (nonatomic,strong) NSString *cwshrid;
@property (nonatomic,strong) NSString *khid;
@property (nonatomic,strong) NSString *zdrq;
@property (nonatomic,strong) NSString *djbz;

@property (nonatomic,strong) NSMutableArray * tbnote_spzfcbs;
@property (nonatomic,strong) NSMutableArray <JDModel3 *> * tbnote_spzfcb_sks;
@property (nonatomic,strong) NSMutableArray <JDModel2 *> * tbnote_spzfcb_khzks;

@property (nonatomic,strong) NSMutableArray * tbnote_spzfcb_khfys;
@property (nonatomic,strong) NSMutableArray * tbnote_spzfcb_fks;
@property (nonatomic,strong) NSMutableArray * tbnote_spzfcb_gyszks;



@end

NS_ASSUME_NONNULL_END
