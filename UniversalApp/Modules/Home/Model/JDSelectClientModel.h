//
//  JDSelectClientModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseModel.h"

@interface JDSelectClientModel : BaseModel
/*
 bgrbm = 0000;
 bgrid = 1;
 bgrmc = "\U7ba1\U7406\U5458";
 bgrq = "2018-04-10 15:48:50";
 bz = "";
 ckbm = 002;
 ckid = 2;
 ckmc = "\U676d\U5dde\U95e8\U5e97\U4ed3\U5e93";
 jdrbm = 0000;
 jdrid = 1;
 jdrmc = "\U7ba1\U7406\U5458";
 jdrq = "2018-03-13 14:23:12";
 khbm = 00001;
 khid = 1;
 khmc = "\U73cd\U8d1d\U8def256\U53f7";
 ktzh = 0;
 lxdh = "";
 lxdz = "";
 lxrdh = "";
 lxremail = "";
 lxrqq = "";
 lxrsj = "";
 lxrxm = "";
 lxrzw = "";
 sfdj = 0;
 tag = "";
 "tbda_kh_addresss" = "<null>";
 yszk = "217029.96";
 ywybm = 0013;
 ywyid = 2;
 ywymc = "\U6768\U8d22\U52a1";
 yzbm = "";
 zdysk = 50000;
 zhmc = "";
 zhmm = d41d8cd98f00b204e9800998ecf8427e;
 zjf = zbl256h;
 zjfhead = Z;

 */
@property (nonatomic,assign) int  Khid; //客户ID
@property (nonatomic,assign) int  gysid; //供应商ID

@property (nonatomic,strong) NSString * khbm;//客户编码
@property (nonatomic,strong) NSString * gysbm; //供应商编码

@property (nonatomic,strong) NSString * khmc;//客户名称
@property (nonatomic,strong) NSString * gysmc;//供应商名称

@property (nonatomic,assign) int ckid; //仓库ID

@property (nonatomic,strong) NSString * ckbm;//仓库编码

@property (nonatomic,strong) NSString * ckmc;//仓库名称

@property (nonatomic,strong) NSString * lxrxm;//联系人姓名

@property (nonatomic,strong) NSString * lxrsj;//联系人手机

@property (nonatomic,strong) NSString * lxrdh;//联系人电话

@property (nonatomic,strong) NSString * lxrzw;//联系人职务

@property (nonatomic,strong) NSString * lxrqq;//联系人qq

@property (nonatomic,strong) NSString * lxremail;//联系人email

@property (nonatomic,strong) NSString * lxdh;//联系电话

@property (nonatomic,strong) NSString *lxdz;//联系地址

@property (nonatomic,assign) int  sfdj;//是否冻结 0:未 1:已

@property (nonatomic,assign) double yszk;//收账款 即 客户当前欠款

@property (nonatomic,assign) double zdysk;//最大应收款

@property (nonatomic,strong) NSString *zjfhead;//助记字符

//自己写的model
@property (nonatomic,assign) BOOL have;

@property (nonatomic,assign) double yfzk;//收账款 即 客户当前欠款

@property (nonatomic,assign) double zdyfk;//最大应收款


@end
