//
//  HomeForthTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "HomeForthTableViewCell.h"

@implementation HomeForthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellData:(NSDictionary *)dic{
    
    
    //百分比
    double ApercentB = ([dic[@"xs_xsje"] doubleValue] - [dic[@"xs_xsje_beforeday"] doubleValue] )  / [dic[@"xs_xsje_beforeday"] doubleValue];
    self.Blbl1.text = Quan_Xian(@"查看销售额权限") ? CCHANGE(dic[@"xs_xsje"]) : @"¥*";
    self.Blbl2.text = [[NSIntegerToNSString([dic[@"xs_djsl"] integerValue]) concate:@"/  "] append:@"笔"];
    self.Blbl3.text =  [doubleToNSString(ApercentB * 100) append:@"%"] ;
    
    if ([dic[@"xs_xsje_beforeday"] doubleValue] == 0) {
        self.Blbl3.text = @"0";
    }else{
        if (ApercentB > 0) {
            self.Bimv.image = [UIImage imageNamed:@"icon_shangsheng"];
            self.Blbl3.textColor = JDRGBAColor(246, 62, 32);
        }else if (ApercentB < 0){
            self.Bimv.image = [UIImage imageNamed:@"icon_xiajiang"];
            self.Blbl3.textColor = JDRGBAColor(38, 207, 126);
        }
    }
    
    
    
    
    //百分比
    double ApercentA = ([dic[@"xsdd_xsje"] doubleValue] - [dic[@"xsdd_xsje_beforeday"] doubleValue] )  / [dic[@"xsdd_xsje_beforeday"] doubleValue];
    self.Albl1.text = Quan_Xian(@"查看销售额权限") ? CCHANGE(dic[@"xsdd_xsje"]) : @"¥*";
    self.Albl2.text = [[NSIntegerToNSString([dic[@"xsdd_djsl"] integerValue]) concate:@"/  "]append:@"笔"];
    self.Albl3.text =  [doubleToNSString(ApercentA * 100) append:@"%"];
    
    if ([dic[@"xsdd_xsje_beforeday"] doubleValue] == 0) {
        self.Albl3.text = @"0";
    }else{
        if (ApercentA > 0) {
            self.Aimg.image = [UIImage imageNamed:@"icon_shangsheng"];
            self.Albl3.textColor = JDRGBAColor(246, 62, 32);
        }else if (ApercentB < 0){
            self.Aimg.image = [UIImage imageNamed:@"icon_xiajiang"];
            self.Albl3.textColor = JDRGBAColor(38, 207, 126);
        }
    }
    
}
@end
