//
//  JDColorDetailTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDColorDetailTableViewCell.h"

@implementation JDColorDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 创建一个轻拍手势 同时绑定了一个事件
     UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
     // 设置轻拍次数
     aTapGR.numberOfTapsRequired = 1;
     // 添加手势
     [self.kucunLbl addGestureRecognizer:aTapGR];
}
-(void)tapGRAction:(id)tap{
    self.kucunblock(self.kucunLbl.tag);
}


-(void)setValueCell:(JDAddColorModel *)model{
    NSURL *url = [NSURL URLWithString:model.imgurl];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    self.colorImg.image = imagea;
    self.ysLbl.text = model.ys;
    self.priceLbl.text = CCHANGE_DOUBLE(model.xsdj);
    self.chengbenLbl.text = Quan_Xian(@"查看成本权限") ? CCHANGE_DOUBLE(model.cbdj) : @"***";
    self.kucunLbl.text = doubleToNSString(model.kczsl);
    if (!imagea) {
        self.colorImg.image = [UIImage imageNamed:@"img_moren"];

    }
    
    //圆圈选择和未选择
    if (model.isShowMore) {
        self.xuanzeImg.image = [UIImage imageNamed:@"icon_yuangouxuan"];
    }else{
        self.xuanzeImg.image = [UIImage imageNamed:@"icon_yuanweigouxuan"];
    }
    
    if (self.selectBOOL) {
        self.xuanzeHeight.constant = 16;
    }else{
        self.xuanzeHeight.constant = 0;
    }
    
}

-(void)setValueTagCell:(JDAddColorModel *)model{
    
    
    self.ysTagLbl.text = [NSString stringWithFormat:@"颜色:%@",model.ys];
    self.xsjTagLbl.text = [NSString stringWithFormat:@"销售价:%@",CCHANGE_DOUBLE(model.xsdj)];
    self.cdysTagLBl.text = [NSString stringWithFormat:@"产地颜色:%@",model.cdys];
    self.cbTagLbl.text =  [NSString stringWithFormat:@"成本:%@",Quan_Xian(@"查看成本权限") ? CCHANGE_DOUBLE(model.cbdj) : @"***"];
    
    self.kuCunTagLBl.text = [NSString stringWithFormat:@"库存:%.2f",model.kczsl];
    self.zuidixiaoshoujiaTagLbl.text = [NSString stringWithFormat:@"最低销售价:%@",CCHANGE_DOUBLE(model.zdsj)];
    self.zuidikucunTagLbl.text = [NSString stringWithFormat:@"最低库存:%.2f",model.zdkc];
    self.cangweiTagLbl.text = [NSString stringWithFormat:@"仓位:%@",model.cw];
    
    
    
    
    
    
    
    
    
    NSURL *url = [NSURL URLWithString:model.imgurl];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    self.colorTagImg.image = imagea;
    if (!imagea) {
        self.colorImg.image = [UIImage imageNamed:@"img_moren"];
        
    }
    
    //圆圈选择和未选择
    if (model.isShowMore) {
        self.xuanzeImg.image = [UIImage imageNamed:@"icon_yuangouxuan"];
    }else{
        self.xuanzeImg.image = [UIImage imageNamed:@"icon_yuanweigouxuan"];
    }
    
    if (self.selectBOOL) {
        self.xuanzeHeight.constant = 16;
    }else{
        self.xuanzeHeight.constant = 0;
    }
}
- (IBAction)lxrTf:(id)sender {
}
@end
