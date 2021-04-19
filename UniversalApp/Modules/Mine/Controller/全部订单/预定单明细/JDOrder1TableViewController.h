//
//  JDOrder1TableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"
#import "JDButtom.h"
@interface JDOrder1TableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
- (IBAction)btn3Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
- (IBAction)btn6Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
@property (weak, nonatomic) IBOutlet UIButton *btn10;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (nonatomic,strong) NSString * noteno;

@end
