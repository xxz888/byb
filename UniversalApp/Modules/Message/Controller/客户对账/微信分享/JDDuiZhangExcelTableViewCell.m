//
//  JDDuiZhangExcelTableViewCell.m
//  excelDemo
//
//  Created by 小小醉 on 2020/3/12.
//  Copyright © 2020 xxz. All rights reserved.
//

#import "JDDuiZhangExcelTableViewCell.h"
#import "UIView+WZB.h"
@implementation JDDuiZhangExcelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBorderWithView:self.outSideView top:YES left:YES bottom:YES right:YES];

    
    [self setBorderWithView:self.bianhao top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.danjuleixing top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.danjuhaoma top:NO left:NO bottom:YES right:YES];
    
    [self setBorderWithView:self.ruzhangriqi top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.kehumingcheng top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.shangpinhuohao top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.shangpinmingcheng top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.shangpinyanse top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.shangpinzhaiyao top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.kaipiaoshuliang top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.kaipiaodanwei top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.kaipiaodanjia top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.kaipiaojine top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.xiaoshoupishu top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.xiaoshoushuliang top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.xiaoshoudanjia top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.jinezengjia top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.jinejianshao top:NO left:NO bottom:YES right:YES];
//    [self setBorderWithView:self.jinedanjia top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.jinehuilv top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.jinbenbi top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.jinezhekou top:NO left:NO bottom:YES right:YES];
    [self setBorderWithView:self.jinejine top:NO left:NO bottom:NO right:NO];

    

}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right{
    UIColor * color = KBlackColor;
    CGFloat width = 1.0f;
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

@end
