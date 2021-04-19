//
//  JDChangeNameTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/26.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"


typedef void(^saveBtnTitleBlock)(NSString *);
@interface JDChangeNameTableViewController : RootTableViewController
@property (nonatomic,copy) saveBtnTitleBlock block;
@end
