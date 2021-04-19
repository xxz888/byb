//
//  JDSelectOddViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectClientModel.h"

typedef void(^selectFinshSpBlock)(JDSelectSpModel * spmodel);



@interface JDSelectOddViewController : RootViewController
@property (nonatomic,strong) NSString * OpenType;
@property (nonatomic,copy) selectFinshSpBlock selectFinshSpBlock;



@end
