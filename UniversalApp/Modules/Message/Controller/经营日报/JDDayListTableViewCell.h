//
//  JDDayListTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JDDayListModel.h"
@interface JDDayListTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *Albl1;
@property (weak, nonatomic) IBOutlet UILabel *Albl2;
@property (weak, nonatomic) IBOutlet UILabel *Albl3;
@property (weak, nonatomic) IBOutlet UILabel *Albl4;
@property (weak, nonatomic) IBOutlet UILabel *Albl5;
@property (weak, nonatomic) IBOutlet UILabel *Albl0;
@property (weak, nonatomic) IBOutlet UIImageView *Aimg0;


@property (weak, nonatomic) IBOutlet UILabel *Blbl1;
@property (weak, nonatomic) IBOutlet UILabel *Blbl2;
@property (weak, nonatomic) IBOutlet UILabel *Blbl3;
@property (weak, nonatomic) IBOutlet UILabel *Blbl4;
@property (weak, nonatomic) IBOutlet UIImageView *Bimg0;
@property (weak, nonatomic) IBOutlet UILabel *Blbl0;

@property (weak, nonatomic) IBOutlet UILabel *Clbl1;
@property (weak, nonatomic) IBOutlet UILabel *Clbl2;
@property (weak, nonatomic) IBOutlet UILabel *Clbl3;
@property (weak, nonatomic) IBOutlet UILabel *Clbl4;

@property (weak, nonatomic) IBOutlet UILabel *Dlbl1;
@property (weak, nonatomic) IBOutlet UILabel *Dlbl2;
@property (weak, nonatomic) IBOutlet UILabel *Dlbl3;


@property (weak, nonatomic) IBOutlet UILabel *Elbl1;
@property (weak, nonatomic) IBOutlet UILabel *Elbl2;
@property (weak, nonatomic) IBOutlet UILabel *Elbl3;

@property (weak, nonatomic) IBOutlet UILabel *Flbl1;
@property (weak, nonatomic) IBOutlet UILabel *Flbl2;
@property (weak, nonatomic) IBOutlet UILabel *Flbl3;

@property (weak, nonatomic) IBOutlet UIImageView *yujingImv;

-(void)setCellData:(JDDayListModel *)model;
@end
