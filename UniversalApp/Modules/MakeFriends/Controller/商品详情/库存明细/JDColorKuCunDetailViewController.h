//
//  JDColorKuCunDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2020/2/18.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDColorKuCunDetailViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (weak, nonatomic) IBOutlet UILabel *ckTitle;
@property(nonatomic,strong)NSMutableDictionary * dic;
@end

NS_ASSUME_NONNULL_END
