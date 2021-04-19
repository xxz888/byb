//
//  JDYJFKViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "PlaceholderTextView.h"

@interface JDYJFKViewController : RootViewController
@property (weak, nonatomic) IBOutlet PlaceholderTextView *YJFKTv;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
- (IBAction)submitAction:(id)sender;

@end
