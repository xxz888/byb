//
//  JDJiaGongShouHuo3ViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectClientModel.h"
typedef void(^selectFinshSpBlock)(JDSelectSpModel * spmodel);


NS_ASSUME_NONNULL_BEGIN

@interface JDJiaGongShouHuo3ViewController : RootViewController
@property (nonatomic,strong) NSString * OpenType;
@property (nonatomic,copy) selectFinshSpBlock selectFinshSpBlock;

@end

NS_ASSUME_NONNULL_END
