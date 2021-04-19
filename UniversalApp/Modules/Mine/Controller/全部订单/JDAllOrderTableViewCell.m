//
//  JDAllOrderTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/1.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAllOrderTableViewCell.h"
@implementation JDAllOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [UIFont adjustFont:self.titleLbl.font.systemFontSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setYangPinAndYuDing:(NSDictionary *)dic titleBtn:(NSString *)title{
    self.lbl1.hidden = self.lbl2.hidden = self.lbl3.hidden = self.lbl3tag.hidden = self.lbl4.hidden = self.lbl5.hidden = NO;
    self.shoukuanView.hidden = YES;

    self.lbl1.text = CCHANGE_OTHER(dic[@"xszsl"]);
    self.lbl2.hidden = YES;
    self.lbl2tag.hidden = YES;
    self.lbl3.text = CCHANGE(dic[@"xszje"]);
    self.lbl4.text = dic[@"mdmc"];
    self.lbl5.text = dic[@"ckmc"];
    NSString * str1 = [title isEqualToString:@"预定单历史"] ? @"订金":@"收款";
    NSString * str2 =  [title isEqualToString:@"预定单历史"] ?CCHANGE(dic[@"skzje"]) : CCHANGE(dic[@"skje"]);
    self.lbl6.text = [NSString stringWithFormat:@"(%@%@)",str1,str2];
    self.lbl7.text = [title isEqualToString:@"预定单历史"] ? dic[@"yjfhrq"] :  dic[@"rzrq"];
    self.lbl8.text = dic[@"zdrmc"];
}
-(void)setXiaoShouDan:(NSDictionary *)dic titleBtn:(NSString *)title{
    self.lbl1.hidden = self.lbl2.hidden = self.lbl3.hidden = self.lbl3tag.hidden = self.lbl4.hidden = self.lbl5.hidden = NO;
    self.shoukuanView.hidden = YES;

    NSString * str1 ;
    if ([title isEqualToString:@"采购入库单历史"]) {
        self.lbl1.text = CCHANGE_OTHER(dic[@"spsl"]) ;
        self.lbl3.text = doubleToNSString([dic[@"spje"] doubleValue]);
         str1 = [@"付款" append:CCHANGE_DOUBLE([dic[@"fkje"] doubleValue])];

    }else if([title isEqualToString:@"直发单历史"]){
        self.lbl1.text = CCHANGE_OTHER(dic[@"spsl"]) ;
        self.lbl3.text = doubleToNSString([dic[@"xsje"] doubleValue]);
        str1 = [@"收款" append:CCHANGE_DOUBLE([dic[@"skje"] doubleValue])];
    }else{
        self.lbl1.text = CCHANGE_OTHER(dic[@"xssl"]) ;
        self.lbl3.text = doubleToNSString([dic[@"xsje"] doubleValue]);
         str1 = [@"收款" append:CCHANGE_DOUBLE([dic[@"skje"] doubleValue])];

    }
    self.lbl2.hidden = YES;
    self.lbl2tag.hidden = YES;
    self.lbl4.text = dic[@"mdmc"];
    self.lbl5.text = dic[@"ckmc"];
    NSString * str2 = [@"折扣" append:CCHANGE_DOUBLE([dic[@"zkje"] doubleValue])];
    self.lbl6.text = [NSString stringWithFormat:@"(%@\n%@)",str1,str2];
    self.lbl7.text = dic[@"rzrq"];
    self.lbl8.text = dic[@"zdrmc"];
    
    
    if ([title isEqualToString:@"退货单历史"] ) {
        self.lbl1.text = CCHANGE_OTHER(dic[@"thzsl"]);
        self.lbl3.text = CCHANGE(dic[@"thzje"]);

        self.lbl6.hidden = YES;
        self.lbl7Tag.text = @"操作时间";
    }else if ([title isEqualToString:@"采购退货单历史"]) {
        self.lbl1.text = CCHANGE_OTHER(dic[@"thsl"]) ;
        self.lbl3.text = doubleToNSString([dic[@"thje"] doubleValue]);
        self.lbl6.hidden = YES;
        self.lbl7Tag.text = @"操作时间";
    }
}
-(void)setShouKuanDan:(NSDictionary *)dic titleBtn:(NSString *)title{
    self.lbl1.hidden = self.lbl2.hidden = self.lbl3.hidden = self.lbl3tag.hidden = self.lbl4.hidden = self.lbl5.hidden = YES;
    self.shoukuanView.hidden = NO;
    if ([title isEqualToString:@"付款单历史"]) {
        self.shouKuanLbl.text = CCHANGE(dic[@"fkzje"]);
        self.firstLbl.text = @"付款金额";
        self.lbl8.text = dic[@"zdrmc"];

    }else{
        self.shouKuanLbl.text = CCHANGE(dic[@"sfzje"]);
        self.firstLbl.text = @"收款金额";
        self.lbl8.text = dic[@"jsrmc"];


    }
    self.lbl7.text = dic[@"rzrq"];
}
-(void)setChuKuDan:(NSDictionary *)dic titleBtn:(NSString *)title{
    self.lbl1.hidden = self.lbl2.hidden = self.lbl3.hidden = self.lbl3tag.hidden = self.lbl4.hidden = self.lbl5.hidden = YES;
    self.shoukuanView.hidden = NO;
    self.shouKuanLbl.hidden = YES;
    self.lbl7.text = dic[@"rzrq"];
    self.lbl8.text = dic[@"zdrmc"];
    
    
    self.middleLbl.hidden = self.lastLbl.hidden = NO;
    self.firstLbl.textColor = JDRGBAColor(153, 153, 153);
    self.firstLbl.text = dic[@"mdmc"];
    self.middleLbl.text = dic[@"ckmc"];
    self.lastLbl.text = CCHANGE(dic[@"cksl"]);
    
}
@end
