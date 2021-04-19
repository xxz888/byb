//
//  JDThirdTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/25.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTableViewController.h"
@interface JDThirdTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UILabel *Albl1;
@property (weak, nonatomic) IBOutlet UILabel *Albl2;
@property (weak, nonatomic) IBOutlet UILabel *Albl4;
@property (weak, nonatomic) IBOutlet UILabel *Albl3;
@property (weak, nonatomic) IBOutlet UILabel *Clbl1;
@property (weak, nonatomic) IBOutlet UILabel *Clbl2;
@property (weak, nonatomic) IBOutlet UILabel *Elbl1;
@property (weak, nonatomic) IBOutlet UILabel *Elbl2;
- (IBAction)stockSpAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *fuKuanView;
@property (weak, nonatomic) IBOutlet UILabel *jinriyingfuLbl;
@property (weak, nonatomic) IBOutlet UILabel *fukuanJineLbl;
- (IBAction)fuKuanAction:(id)sender;
- (IBAction)gysdzAction:(id)sender;
- (IBAction)fkqsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *jingyinglirunView;
@property (weak, nonatomic) IBOutlet UILabel *gongchangkucunLbl;
- (IBAction)gckcAction:(id)sender;

@end
