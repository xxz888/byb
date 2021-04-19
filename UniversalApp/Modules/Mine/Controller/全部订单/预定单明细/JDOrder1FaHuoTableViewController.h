//
//  JDOrder1FaHuoTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"
#import "JDButtom.h"
@interface JDOrder1FaHuoTableViewController : RootTableViewController
@property(nonatomic,strong)NSMutableDictionary * objectDic;

@property (weak, nonatomic) IBOutlet JDButtom *btn1;
@property (weak, nonatomic) IBOutlet JDButtom *btn2;
@property (weak, nonatomic) IBOutlet JDButtom *btn3;
@property (weak, nonatomic) IBOutlet JDButtom *btn4;
@property (weak, nonatomic) IBOutlet JDButtom *btn5;
- (IBAction)btn4Action:(id)sender;

- (IBAction)btn5Action:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *tf4;

@property (weak, nonatomic) IBOutlet UITextView *bzTV;


@property (nonatomic,strong) NSString *noteno;















@end
