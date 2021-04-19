//
//  JDSalesTabListTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/6/25.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDSalesTabListTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet UIImageView *btn1Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn2Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn3Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn4Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn5Img;

//4个button的公用方法
- (IBAction)allBtnAction:(id)sender;


@property (weak, nonatomic) IBOutlet UITableViewCell *runCell;

@property (weak, nonatomic) IBOutlet UILabel *jrxsLbl;
@property (weak, nonatomic) IBOutlet UILabel *xsjeLbl;
@property (weak, nonatomic) IBOutlet UILabel *xspiLbl;
@property (weak, nonatomic) IBOutlet UILabel *xsslLbl;
@property (weak, nonatomic) IBOutlet UILabel *yddsLbl;
@property (weak, nonatomic) IBOutlet UILabel *ydjeLbl;
@property (weak, nonatomic) IBOutlet UILabel *ydpsLbl;
@property (weak, nonatomic) IBOutlet UILabel *ydslLbl;
@property (weak, nonatomic) IBOutlet UILabel *mllLbl;
@property (weak, nonatomic) IBOutlet UILabel *mlLbl;
@property (weak, nonatomic) IBOutlet UILabel *zdpsLbl;
@property (weak, nonatomic) IBOutlet UILabel *zkhsLbl;

@property (weak, nonatomic) IBOutlet UIButton *clientBtn;

@property (weak, nonatomic) IBOutlet UIButton *salesBtn;
//销售按钮
- (IBAction)salesBtnAction:(id)sender;
//按客户汇总
- (IBAction)clientAllBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *cell1View;

@end
