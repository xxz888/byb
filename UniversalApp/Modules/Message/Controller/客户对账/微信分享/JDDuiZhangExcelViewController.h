//
//  JDDuiZhangExcelViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2020/3/13.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^viewBLock)(void);
@interface JDDuiZhangExcelViewController : RootViewController
@property (nonatomic, strong) UITableView * excelTableView;
@property (nonatomic, copy) viewBLock viewdidloadfinishblock;
@property (nonatomic, assign) NSInteger  khid;
@property (nonatomic, strong) NSString * khmc;

@end

NS_ASSUME_NONNULL_END
