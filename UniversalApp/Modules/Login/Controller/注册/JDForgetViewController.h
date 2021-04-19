//
//  JDForgetViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/1.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDForgetViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * phoneCode;
@property (nonatomic,strong) NSString * secretcode;
@end
