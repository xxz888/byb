//
//  JDProfitViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDProfitViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
- (IBAction)clickBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *beginLbl;
@property (weak, nonatomic) IBOutlet UILabel *endLbl;



@property (weak, nonatomic) IBOutlet UILabel *spxsmlLbl;

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;

@property (weak, nonatomic) IBOutlet UILabel *lbl1Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl2Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl3Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl4Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl5Tag;

@end
