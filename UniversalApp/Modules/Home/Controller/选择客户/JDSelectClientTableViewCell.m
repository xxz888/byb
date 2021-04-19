//
//  JDSelectClientTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSelectClientTableViewCell.h"

@implementation JDSelectClientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setValueModel:(JDSelectClientModel *)model{
    self.clientNameLbl.text = CaiGouBOOL ? model.gysmc : model.khmc;
    self.addressLbl.text = CaiGouBOOL ? model.lxdh : model.ckmc;
    if (CaiGouBOOL) {
        self.creditLbl.text = kGet2fDouble(model.zdyfk - model.yfzk);

    }else{
        self.creditLbl.text = kGet2fDouble(model.zdysk - model.yszk);

    }
}

@end
