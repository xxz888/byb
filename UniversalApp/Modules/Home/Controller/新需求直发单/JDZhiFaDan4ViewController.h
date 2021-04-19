//
//  JDZhiFaDan4ViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/21.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDZhiFaDan4ViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (weak, nonatomic) IBOutlet UILabel *jinjiaTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *xiaojiaTotalLbl;
- (IBAction)nextAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *addCount;

@end

NS_ASSUME_NONNULL_END
