//
//  JDSelectClientViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectClientModel.h"
typedef void(^sendClientModelBlock)(JDSelectClientModel *);
@interface JDSelectClientViewController : RootViewController
@property (nonatomic,strong) NSString * whereCome;
@property (nonatomic,copy) sendClientModelBlock sendClientBlock;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (nonatomic,assign) NSInteger whereInteger;
@end
