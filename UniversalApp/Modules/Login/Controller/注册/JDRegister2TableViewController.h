//
//  JDRegister2TableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/29.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDRegister2TableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UITextField *tf3;
@property (weak, nonatomic) IBOutlet UITextField *tf4;
@property (weak, nonatomic) IBOutlet UITextField *tf5;
@property (weak, nonatomic) IBOutlet UITextField *tf6;
- (IBAction)finishAction:(id)sender;

@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * phoneCode;
@property (nonatomic,strong) NSString * secretcode;


@end
