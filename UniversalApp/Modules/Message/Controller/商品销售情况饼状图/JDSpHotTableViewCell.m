//
//  JDSpHotTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSpHotTableViewCell.h"

@implementation JDSpHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellData:(JDPiexModel *)model{
    self.nameLbl.text = [[[model.spmc append:@"("] append:model.sphh] append:@")"];
    self.lbl1.text = [NSIntegerToNSString(model.yscount) append:@"种"];
    self.lbl2.text = [NSIntegerToNSString(model.xsps) append:@"匹"];
    self.lbl3.text = doubleToNSString(model.xssl);
    self.lbl4.text = CCHANGE_DOUBLE(model.xsje);
    self.lbl5.text = CCHANGE_DOUBLE(model.xscb);
    self.lbl6.text = CCHANGE_DOUBLE(model.xsml);
}
@end
