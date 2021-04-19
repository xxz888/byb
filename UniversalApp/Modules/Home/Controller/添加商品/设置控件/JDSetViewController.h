//
//  JDSetViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/6/30.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDSetViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;


- (IBAction)btnAction:(id)sender;

@end
