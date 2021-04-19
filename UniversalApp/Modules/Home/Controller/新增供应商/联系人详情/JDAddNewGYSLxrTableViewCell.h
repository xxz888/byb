//
//  JDAddNewGYSLxrTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/7.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
@class JDAddNewGYSLxrTableViewCell;
typedef void(^delCell)(JDAddNewGYSLxrTableViewCell *);
@interface JDAddNewGYSLxrTableViewCell : BaseTableViewCell
- (IBAction)delAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *zwtf;
@property (weak, nonatomic) IBOutlet UITextField *lxrPhoneTf;
@property (weak, nonatomic) IBOutlet UITextField *lxrSjhTf;
@property (weak, nonatomic) IBOutlet UITextField *lxrEmail;
@property (weak, nonatomic) IBOutlet UITextField *lxrQQTf;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *lxrTitleBtn;
@property (nonatomic,copy) delCell delcellBlock;
@end
