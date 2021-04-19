//
//  JDAddColorViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDAddColorModel.h"
#import "JDSelectSpModel.h"
@protocol DissmissVCDelegate <NSObject>

-(void)dissmissValue:(JDAddColorModel *)model;

@end
@interface JDAddColorViewController : RootViewController
@property (nonatomic,copy) NSString * spid;
@property (nonatomic,weak) id<DissmissVCDelegate> delegate;
@property (nonatomic,strong)JDSelectSpModel * spModel ;

@end
