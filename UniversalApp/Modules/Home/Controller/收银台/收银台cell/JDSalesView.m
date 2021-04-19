//
//  JDSalesView.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/6/24.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSalesView.h"

@implementation JDSalesView


- (void)drawRect:(CGRect)rect {
    [AD_SHARE_MANAGER setBtnImgRWithTitleL:self.saleswayBtn];
}

- (IBAction)tfChange:(UITextField *)tf {
//    self.tfblock(tf);
}

- (IBAction)saleswayAction:(UIButton *)btn {
    self.block(self);
//    self.btnblock(btn);
}
@end
