//
//  JDSalesTabListTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/26.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSalesTabListTableViewCell.h"
#import "UIColor+YYAdd.h"

@implementation JDSalesTabListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setCellData:(JDSalesBtnModel *)model{
    self.clientLbl.text = model.khmc;
    self.psLbl.text = [NSIntegerToNSString(model.xsps) append:@"匹"];
    self.countLbl.text =  doubleToNSString(model.xssl);
    self.jeLbl.text = CCHANGE_DOUBLE(model.xsje);
    
    self.chbLbl.text = CCHANGE_DOUBLE(model.xscb);
    self.mlLBl.text = CCHANGE_DOUBLE(model.xsml);
    self.lbl1.text = model.mdmc;
    
    self.lbl2.text = model.ckmc;
    self.rzsjLbl.text = model.rzrq;
    self.ywyLbl.text = model.ywymc;
    self.dhLbl.text = model.djhm;
    self.titleView.text = model.djlx;
    
    [self inLabelChange:self.titleView];
}
-(void)setCellData1:(JDSalesBtnModel *)model{
    self.clientLbl.text = model.khmc;
    self.psLbl.text = [NSIntegerToNSString(model.xsps) append:@"匹"];
    self.countLbl.text =  doubleToNSString(model.xssl);
    self.jeLbl.text = CCHANGE_DOUBLE(model.xsje);
    self.lbl1.text = model.mdmc;
    self.lbl2.text = model.ckmc;
    self.rzsjLbl.text = model.rzrq;
    self.ywyLbl.text = model.ywymc;
    self.dhLbl.text = model.djhm;

    ViewBorderRadius(self.titleView1, self.titleView1.size.width *0.5, 0.5,[UIColor colorWithHexString:@"fe3620"]);
    self.titleView1.text = @"销";
    self.titleView1.textColor = [UIColor colorWithHexString:@"fe3620"];
}
-(void)setCellData2:(JDSalesBtnModel *)model{
    self.clientLbl.text = model.khmc ? model.khmc : model.rzrq ? model.rzrq :model.ywymc ? model.ywymc : model.mdmc;
    self.psLbl.text = [NSIntegerToNSString(model.xsps) append:@"匹"];
    self.countLbl.text =  doubleToNSString(model.xssl);
    self.jeLbl.text = CCHANGE_DOUBLE(model.xsje);
    
    self.chbLbl.text = CCHANGE_DOUBLE(model.xscb);
    self.mlLBl.text = CCHANGE_DOUBLE(model.xsml);
    
}
-(void)setCellData3:(JDSalesBtnModel *)model{
    self.clientLbl.text = model.rzrq ? model.rzrq : model.khmc ? model.khmc : model.ywymc ? model.ywymc : model.mdmc;
    self.psLbl.text = [NSIntegerToNSString(model.xsps) append:@"匹"];
    self.countLbl.text =  doubleToNSString(model.xssl);
    self.jeLbl.text = CCHANGE_DOUBLE(model.xsje);
    self.chbLbl.text = CCHANGE_DOUBLE(model.xscb);
    self.mlLBl.text = CCHANGE_DOUBLE(model.xsml);
    
}
-(void)setCellData4:(JDSalesBtnModel *)model{
    self.clientLbl.text = [NSString stringWithFormat:@"%@(%@)",model.sphh,model.spmc];
    self.psLbl.text = [NSIntegerToNSString(model.yscount) append:@"种"];
    self.countLbl.text = [NSIntegerToNSString(model.xsps) append:@"匹"];
    
    self.chbLbl.text = doubleToNSString(model.xssl);
    self.mlLBl.text = CCHANGE_DOUBLE(model.xsje);
    
    self.lbl1.text = CCHANGE_DOUBLE(model.xscb);
    self.lbl2.text = CCHANGE_DOUBLE(model.xsml);
}
-(void)inLabelChange:(UILabel *)label{
    if ([label.text isEqualToString:@"商品销售单"]) {
        ViewBorderRadius(label, label.size.width *0.5, 0.5,[UIColor colorWithHexString:@"fe3620"]);
        label.text = @"商";
        label.textColor = [UIColor colorWithHexString:@"fe3620"];
    }else if ([label.text isEqualToString:@"销售退货单"]) {
        ViewBorderRadius(label, label.size.width *0.5, 0.5,[UIColor colorWithHexString:@"26CF7E"]);
        label.text = @"退";
        label.textColor = [UIColor colorWithHexString:@"26CF7E"];

    }else if ([label.text isEqualToString:@"商品出库单"]) {
        ViewBorderRadius(label, label.size.width *0.5, 0.5,[UIColor colorWithHexString:@"26CF7E"]);
        label.text = @"出";
        label.textColor = [UIColor colorWithHexString:@"26CF7E"];

    }else if ([label.text isEqualToString:@"商品直发单"]) {
        ViewBorderRadius(label, label.size.width *0.5, 0.5,[UIColor colorWithHexString:@"F5A623"]);
        label.text = @"发";
        label.textColor = [UIColor colorWithHexString:@"F5A623"];

    }else if ([label.text isEqualToString:@"样品销售单"]) {
        ViewBorderRadius(label, label.size.width *0.5, 0.5,[UIColor colorWithHexString:@"00a3ff"]);
        label.text = @"样";
        label.textColor = [UIColor colorWithHexString:@"00a3ff"];

    }
}
-(void)cornerLabel:(UILabel *)label{
    label.layer.cornerRadius =label.size.width *0.5;
    label.layer.masksToBounds =YES;
}
@end
