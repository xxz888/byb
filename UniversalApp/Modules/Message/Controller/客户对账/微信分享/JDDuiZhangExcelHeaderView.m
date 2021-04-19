//
//  JDDuiZhangExcelHeaderView.m
//  excelDemo
//
//  Created by 小小醉 on 2020/3/12.
//  Copyright © 2020 xxz. All rights reserved.
//

#import "JDDuiZhangExcelHeaderView.h"
#import "UIView+WZB.h"
@implementation JDDuiZhangExcelHeaderView


- (void)drawRect:(CGRect)rect {
    ViewBorderRadius(self.headView, 0, 1, KBlackColor);
    
    [self.bianhao addBorder:3];
    [self.danjuleixing addBorder:3];
    [self.danjuhaoma addBorder:3];
    [self.ruzhangriqi addBorder:3];
    
    [self.kehumingcheng addBorder:3];
    [self.shangpinhuohaoLbl addBorder:3];

    
    [self.shangpinmingcheng addBorder:3];
    [self.yanse addBorder:3];
    [self.zhaiyao addBorder:3];
    
    [self.kaipiao addBorder:3];
    [self.kaipiaokaipiao addBorder:2];
    [self.kaipiaodanjia addBorder:3];
    [self.shuliang addBorder:3];
    [self.danwei addBorder:3];
    [self.danjia addBorder:3];

    
    [self.xiaoshouView addBorder:3];
    [self.xiaoshouLbl addBorder:2];
    [self.pishu addBorder:3];
    [self.pishushuliang addBorder:3];
    [self.pishudanjia addBorder:3];

    [self.jinejine1 addBorder:2];
    
    [self.jinezengjia addBorder:3];
    [self.jinejianshao addBorder:3];
    [self.jinehuilv addBorder:3];
    [self.jinebenbi addBorder:3];
    [self.jinezhekou addBorder:3];

}


@end
