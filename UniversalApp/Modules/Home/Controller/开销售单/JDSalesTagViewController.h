//
//  JDSalesTagViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/16.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDSalesTagViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextAction:(id)sender;
@property (nonatomic,strong) JDSelectClientModel * clientModel;
@property (nonatomic,strong) NSString * OpenType;

@end
