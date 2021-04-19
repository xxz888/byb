//
//  JDJiaGongFaHuoColor3ViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDAddColorModel.h"
#import "JDSelectSpModel.h"
@protocol DissmissVCJiaGongFaHuoDelegate <NSObject>

-(void)dissmissValue:(JDAddColorModel *)model;

@end
NS_ASSUME_NONNULL_BEGIN

@interface JDJiaGongFaHuoColor3ViewController : RootViewController
@property (nonatomic,copy) NSString * spid;
@property (nonatomic,weak) id<DissmissVCJiaGongFaHuoDelegate> delegate;
@property (nonatomic,strong)JDSelectSpModel * spModel ;
@end

NS_ASSUME_NONNULL_END
