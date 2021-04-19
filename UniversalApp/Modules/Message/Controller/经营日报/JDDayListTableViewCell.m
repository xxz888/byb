//
//  JDDayListTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDDayListTableViewCell.h"

@implementation JDDayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellData:(JDDayListModel *)model{
    self.Albl1.text = NSIntegerToNSString(model.xs_djsl);
    self.Albl2.text = NSIntegerToNSString(model.xs_xsps);
    self.Albl3.text = doubleToNSString(model.xs_xsml);
    self.Albl4.text = CCHANGE_DOUBLE(model.xs_xsje);
    self.Albl5.text = doubleToNSString(model.xs_xssl);
    //百分比
    double Apercent = (model.xs_xsje - model.xs_xsje_beforeday )  / model.xs_xsje_beforeday;
    self.Albl0.text =  [doubleToNSString(Apercent * 100) append:@"%"];
    if (model.xs_xsje_beforeday == 0) {
        self.Albl0.text = @"";
        self.Aimg0.hidden = YES;
    }else{
        if (Apercent > 0) {
            self.Aimg0.image = [UIImage imageNamed:@"icon_zuori"];
            self.Albl0.textColor = JDRGBAColor(246, 62, 32);
        }else if (Apercent < 0){
            self.Aimg0.image = [UIImage imageNamed:@"icon_zuori2"];
            self.Albl0.textColor = JDRGBAColor(38, 207, 126);
        }
        self.Aimg0.hidden = NO;

    }

    
    self.Blbl1.text = NSIntegerToNSString(model.xsdd_djsl);
    self.Blbl2.text = NSIntegerToNSString(model.xsdd_xsps);
    self.Blbl3.text = [doubleToNSString(model.xsdd_xsje)concate:@"¥"];
    self.Blbl4.text = doubleToNSString(model.xsdd_xssl);
    //百分比
    double Bpercent = (model.xsdd_xsje - model.xsdd_xsje_beforeday)/ model.xsdd_xsje_beforeday;
    self.Blbl0.text =  [doubleToNSString(Bpercent  * 100) append:@"%"];
    if (model.xsdd_xsje_beforeday == 0) {
        self.Blbl0.text = @"";
        self.Bimg0.hidden = YES;
    }else{
        if (Bpercent > 0) {
            self.Bimg0.image = [UIImage imageNamed:@"icon_zuori"];
            self.Blbl0.textColor = JDRGBAColor(246, 62, 32);
        }else if (Bpercent < 0){
            self.Bimg0.image = [UIImage imageNamed:@"icon_zuori2"];
            self.Blbl0.textColor = JDRGBAColor(38, 207, 126);
            
        }
        self.Bimg0.hidden = NO;

    }

    
    self.Clbl1.text = NSIntegerToNSString(model.xsth_djsl);
    self.Clbl2.text = NSIntegerToNSString(model.xsth_xsps);
    self.Clbl3.text = [doubleToNSString(model.xsth_xsje)concate:@"¥"];
    self.Clbl4.text = doubleToNSString(model.xsth_xssl);
    
    self.Dlbl1.text = NSIntegerToNSString(model.spck_djsl);
    self.Dlbl2.text = NSIntegerToNSString(model.spck_xsps);
    self.Dlbl3.text = NSIntegerToNSString(model.spck_xssl);
    
    self.Elbl1.text = NSIntegerToNSString(model.kc_spps);
    self.Elbl3.text = NSIntegerToNSString(model.bjcount);
    self.Elbl2.text = doubleToNSString(model.kc_spsl);
    
    if (model.bjcount > 0) {
        self.yujingImv.hidden = YES;
    }else{
        self.yujingImv.hidden = NO;
    }
    
    self.Flbl1.text = [doubleToNSString(model.ys_zjje)concate:@"¥"];
    self.Flbl2.text = [doubleToNSString(model.ys_jsje)concate:@"¥"];
    self.Flbl3.text = [doubleToNSString(model.ys_ysje)concate:@"¥"];
}


@end
