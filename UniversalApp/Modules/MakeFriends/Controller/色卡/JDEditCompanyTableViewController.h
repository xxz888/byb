//
//  JDEditCompanyTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/24.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

@interface JDEditCompanyTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UIImageView *commanyImg;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *wxTf;
- (IBAction)imgAction:(id)sender;

@end
