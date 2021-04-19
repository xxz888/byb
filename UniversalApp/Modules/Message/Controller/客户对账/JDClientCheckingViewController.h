//
//  JDClientCheckingViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDClientCheckingViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property(nonatomic,strong) IBOutlet UITextField *beginField;
@property(nonatomic,strong) IBOutlet UITextField *endField;

@property (nonatomic,assign) BOOL whereCome;
@end
