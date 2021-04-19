//
//  JDNewAddSpTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/10.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

@interface JDNewAddSpTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;

@property (weak, nonatomic) IBOutlet UITextField *tf3;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
- (IBAction)btn3Action:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *tf4;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
- (IBAction)btn4Action:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *tf5;
@property (weak, nonatomic) IBOutlet UITextField *tf6;
@property (weak, nonatomic) IBOutlet UITextField *tf7;
@property (weak, nonatomic) IBOutlet UITextField *tf8;
@property (weak, nonatomic) IBOutlet UITextField *tf10;

@property (weak, nonatomic) IBOutlet UIButton *btn11;
@property (weak, nonatomic) IBOutlet UITextField *tf11;
- (IBAction)btn11Action:(id)sender;



@property (weak, nonatomic) IBOutlet UITextView *chengfenTV;


@property (nonatomic,strong) NSDictionary * resultDic;
@property (weak, nonatomic) IBOutlet UITextView *beizhuTV;

@end
