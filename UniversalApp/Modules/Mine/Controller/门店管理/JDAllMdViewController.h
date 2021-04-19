//
//  JDAllMdViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDAllMdViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (weak, nonatomic) IBOutlet UIButton *addNewBtn;
- (IBAction)addNewBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) NSString * whereCome;

@end
