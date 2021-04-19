//
//  LoginModel.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface LoginModel : BaseModel
/*
 apiurl = "";
 dqzq = 201806;
 imgurl = "http://offline-test.oss-cn-hangzhou.aliyuncs.com/3_yg_13.jpg?Expires=1529543481&OSSAccessKeyId=LTAI82qfIbhKCtWq&Signature=f7PdrHksyApIF8AqW2gv0VeWgi0%3D&x-oss-process=image%2Fresize%2Cm_fixed%2Cw_1000%2Ch_1000";
 mdbm = 001;
 mdid = 1;
 mdmc = "\U95e8\U5e97";
 mobile = 13000000000;
 operatorbm = 2000;
 operatorid = 13;
 operatormc = "\U79fb\U52a8\U5f00\U53d1\U7528\U6237";
 qybm = "qy_appdev";
 qyid = 3;
 qymc = "\U79fb\U52a8\U5f00\U53d1\U4e13\U7528\U4f01\U4e1a";
 softverid = 1;
 token = fe85402d000645f497b6cacdc57362e2;
*/
@property (nonatomic,strong) NSString *apiurl;
@property (nonatomic,strong) NSString *dqzq;
@property (nonatomic,strong) NSString *imgurl;
@property (nonatomic,strong) NSString *mdbm;
@property (nonatomic,strong) NSString *mdid;
@property (nonatomic,strong) NSString *mdmc;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *operatorbm;
@property (nonatomic,strong) NSString *operatorid;
@property (nonatomic,strong) NSString *operatormc;
@property (nonatomic,strong) NSString *qybm;
@property (nonatomic,strong) NSString *qyid;
@property (nonatomic,strong) NSString *qymc;
@property (nonatomic,strong) NSString *softverid;
@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSString *entercode;


@end
