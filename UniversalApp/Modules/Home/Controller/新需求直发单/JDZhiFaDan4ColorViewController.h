//
//  JDZhiFaDan4ColorViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/22.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

#import "JDAddColorModel.h"
#import "JDSelectSpModel.h"
@protocol DissmissVCDelegateNew <NSObject>

-(void)dissmissValue:(NSInteger)index;
@end
@interface JDZhiFaDan4ColorViewController : RootViewController
@property (nonatomic) NSInteger index;//记录点击的是第几组
@property (nonatomic,weak) id<DissmissVCDelegateNew> delegate;
@end

