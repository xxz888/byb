//
//  JDSKQKTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDSKQKTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UILabel *allyszkLbl;
- (IBAction)selectYearAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *kLineView;
@property (weak, nonatomic) IBOutlet UIImageView *imv1;

@property (weak, nonatomic) IBOutlet UIImageView *imv2;

@property (nonatomic,assign) BOOL whereCome;//yes为付款情况
@end
