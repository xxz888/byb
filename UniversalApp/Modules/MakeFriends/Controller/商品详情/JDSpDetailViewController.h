//
//  JDSpDetailViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectSpModel.h"
@interface JDSpDetailViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIView *underView;




@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;


@property (weak, nonatomic) IBOutlet UILabel *Albl1;
@property (weak, nonatomic) IBOutlet UILabel *Albl2;
@property (weak, nonatomic) IBOutlet UILabel *Albl3;
@property (weak, nonatomic) IBOutlet UILabel *Albl4;


@property (weak, nonatomic) IBOutlet UILabel *Blbl1;
@property (weak, nonatomic) IBOutlet UILabel *Blbl2;
@property (weak, nonatomic) IBOutlet UILabel *Clbl1;
@property (weak, nonatomic) IBOutlet UILabel *Clbl2;
@property (weak, nonatomic) IBOutlet UIButton *colorDetail;
- (IBAction)colorDetailAction:(id)sender;


@property (nonatomic,strong) JDSelectSpModel * spModel;



@property (weak, nonatomic) IBOutlet UIButton *printBQBtn;
- (IBAction)printBQAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)editAction:(id)sender;
@end
