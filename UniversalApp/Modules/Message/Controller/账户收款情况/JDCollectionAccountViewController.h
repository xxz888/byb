//
//  JDCollectionAccountViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDCollectionAccountViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIImageView *btn1Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn2Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn3Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn4Img;
@property (weak, nonatomic) IBOutlet UIView *bottomView;



@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;

@property (nonatomic,assign) BOOL whereCome;//yes是付款

@end
