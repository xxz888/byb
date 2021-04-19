//
//  JDSpSalesPiexTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDSpSalesPiexTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *JDPieView;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
- (IBAction)clickBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *beginLbl;
@property (weak, nonatomic) IBOutlet UILabel *endLbl;

@property (weak, nonatomic) IBOutlet UILabel *allSalesMoneyLbl;
@property (weak, nonatomic) IBOutlet UIView *section1View;
@property (weak, nonatomic) IBOutlet UIView *section2View;

@end
