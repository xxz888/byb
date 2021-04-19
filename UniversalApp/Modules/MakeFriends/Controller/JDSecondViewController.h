//
//  JDSecondViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDSecondViewController : RootViewController
- (IBAction)addSpAction:(id)sender;

- (IBAction)changeTFValue:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIImageView *scanImv;

- (IBAction)btn1Action:(id)sender;
- (IBAction)btn2Actioin:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *addCancleBtn;

@end
