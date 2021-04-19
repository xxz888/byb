//
//  JDAddNewGYSTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/6.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

@interface JDAddNewGYSTableViewController : RootTableViewController
@property (nonatomic,assign) BOOL whereCome;
@property (nonatomic,assign) NSInteger gysid;
@property (weak, nonatomic) IBOutlet UITextField *gysmcTf;
@property (weak, nonatomic) IBOutlet UITextField *gysdhTf;
@property (weak, nonatomic) IBOutlet UITextField *lxrMcTf;
@property (weak, nonatomic) IBOutlet UITextField *szdqTf;
@property (weak, nonatomic) IBOutlet UITextView *detailTV;
@property (weak, nonatomic) IBOutlet UITextField *bzTf;
@property (weak, nonatomic) IBOutlet UITextField *zdyfkTf;

@property (weak, nonatomic) IBOutlet UITextField *yszkTf;
@property (weak, nonatomic) IBOutlet UITextField *sszkTf;
@property (weak, nonatomic) IBOutlet UIButton *sfdjBtn;
- (IBAction)sfdjAction:(id)sender;
- (IBAction)addLxrAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *yfzkBtnTag;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
