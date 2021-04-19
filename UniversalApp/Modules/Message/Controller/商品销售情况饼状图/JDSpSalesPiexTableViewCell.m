//
//  JDSpSalesPiexTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSpSalesPiexTableViewCell.h"

@implementation JDSpSalesPiexTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellData:(JDPiexModel *)model{
    self.spNameLbl.text = [[[model.spmc append:@"("] append:model.sphh] append:@")"];
    self.moneyLbl.text = CCHANGE_DOUBLE(model.xsje);
}

@end
