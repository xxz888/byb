//
//  JDAddNewClientTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

@interface JDAddNewClientTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
- (IBAction)btn8Action:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl9;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
- (IBAction)btn9Action:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tf10;
@property (weak, nonatomic) IBOutlet UITextField *tf11;
@property (weak, nonatomic) IBOutlet UIButton *btn12;
- (IBAction)btn12Action:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tf13;
@property (nonatomic,assign) BOOL whereCome;
@property (nonatomic,assign) NSInteger khid;
@property (weak, nonatomic) IBOutlet UITextField *tf8;
- (IBAction)dingweiAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *lxrTf;
- (IBAction)addLxrAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *lxrBtn;
@property (weak, nonatomic) IBOutlet UITextField *tf2;

@end
