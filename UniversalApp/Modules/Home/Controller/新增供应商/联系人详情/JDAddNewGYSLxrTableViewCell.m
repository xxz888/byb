//
//  JDAddNewGYSLxrTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/7.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddNewGYSLxrTableViewCell.h"

@implementation JDAddNewGYSLxrTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.delBtn, 11, 0.5, KRedColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)delAction:(id)sender {
    self.delcellBlock(self);
}
@end
