//
//  JDClientCheckingTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDClientCheckingTableViewCell.h"

@implementation JDClientCheckingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)weixinAction:(UIButton *)btn {
    self.weixinblock(btn.tag);
}
@end
