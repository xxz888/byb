//
//  JDOrderDetailTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"
#import "JDButtom.h"
@interface JDOrderDetailTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet JDButtom *btn5;
@property (weak, nonatomic) IBOutlet JDButtom *btn4;
@property (weak, nonatomic) IBOutlet UILabel *lbl6;
@property (weak, nonatomic) IBOutlet JDButtom *btn7;
@property (weak, nonatomic) IBOutlet JDButtom *btn8;
@property (weak, nonatomic) IBOutlet JDButtom *btn9;
@property (weak, nonatomic) IBOutlet UITextView *bzTV;

@property (weak, nonatomic) IBOutlet UILabel *connectLbl;

@property (nonatomic,strong) NSString * noteno;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (nonatomic,strong) NSString * ckData;

@end
