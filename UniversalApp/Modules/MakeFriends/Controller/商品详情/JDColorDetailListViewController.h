//
//  JDColorDetailListViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDColorDetailListViewController : RootViewController
- (IBAction)backVCAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
- (IBAction)addNewColorAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (nonatomic,strong) JDSelectSpModel * spModel;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *setBottomBtn;
- (IBAction)setBottomAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@end
