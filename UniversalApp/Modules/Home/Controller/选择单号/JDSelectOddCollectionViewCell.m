//
//  JDSelectOddCollectionViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSelectOddCollectionViewCell.h"

@implementation JDSelectOddCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setValueData:(JDSelectSpModel *)model{
    self.spTitleLbl.text = model.sphh;
    self.spNameLbl.text = model.spmc;
}
-(void)setColorValueData:(JDAddColorModel *)model{
    self.spTitleLbl.text =model.ys;
    self.spNameLbl.text = @"" ;
}
@end
