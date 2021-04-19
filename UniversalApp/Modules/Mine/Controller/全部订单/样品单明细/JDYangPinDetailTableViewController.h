//
//  JDYangPinDetailTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/5.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

@interface JDYangPinDetailTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;
@property (weak, nonatomic) IBOutlet UILabel *lbl6;
@property (weak, nonatomic) IBOutlet UILabel *lbl7;
@property (weak, nonatomic) IBOutlet UILabel *lbl8;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
- (IBAction)btn8Action:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl9;
@property (weak, nonatomic) IBOutlet UILabel *lbl10;
@property (weak, nonatomic) IBOutlet UILabel *lbl11;
@property (weak, nonatomic) IBOutlet UILabel *lbl12;

@property (weak, nonatomic) IBOutlet UITextView *bzTV;

@property (nonatomic,strong) NSString * noteno;
@property (weak, nonatomic) IBOutlet UILabel *lbl8Tag;
@property (weak, nonatomic) IBOutlet UILabel *yifajineLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl1Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl4Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl6Tag;
@property (weak, nonatomic) IBOutlet UILabel *gysLbl;

@property (weak, nonatomic) IBOutlet UILabel *connectLbl;


@property (weak, nonatomic) IBOutlet UILabel *allQainKuanLblTag;
@property (weak, nonatomic) IBOutlet UILabel *allQianKuanLbl;

@end
