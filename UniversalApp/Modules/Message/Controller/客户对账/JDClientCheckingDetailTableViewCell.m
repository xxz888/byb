//
//  JDClientCheckingDetailTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDClientCheckingDetailTableViewCell.h"

@implementation JDClientCheckingDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.rightLbl, 3, 0.5,JDRGBAColor(245, 166, 35));
    self.rightLbl.textColor = [UIColor orangeColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
