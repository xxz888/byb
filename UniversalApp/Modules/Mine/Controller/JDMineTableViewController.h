//
//  JDMineTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDMineTableViewController : UITableViewController
- (IBAction)settingAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;
- (IBAction)mdAction:(id)sender;
- (IBAction)ckAction:(id)sender;
- (IBAction)cwzhAction:(id)sender;
- (IBAction)qtSettingAction:(id)sender;
- (IBAction)comVersionAction:(id)sender;
- (IBAction)fastHandAction:(id)sender;
- (IBAction)seriveAction:(id)sender;
- (IBAction)yjfkAction:(id)sender;
- (IBAction)gysAction:(id)sender;

@end
