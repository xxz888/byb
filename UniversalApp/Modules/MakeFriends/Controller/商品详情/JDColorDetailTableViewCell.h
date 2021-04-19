//
//  JDColorDetailTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JDAddColorModel.h"
typedef void(^kucunBlock)(NSInteger);

@interface JDColorDetailTableViewCell : BaseTableViewCell
@property(copy,nonatomic)kucunBlock kucunblock;

@property (weak, nonatomic) IBOutlet UIImageView *xuanzeImg;
@property (weak, nonatomic) IBOutlet UIImageView *colorImg;
@property (weak, nonatomic) IBOutlet UILabel *ysLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *chengbenLbl;
@property (weak, nonatomic) IBOutlet UILabel *kucunLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xuanzeHeight;


-(void)setValueCell:(JDAddColorModel *)model;
@property (nonatomic,assign) BOOL selectBOOL;

-(void)setValueTagCell:(JDAddColorModel *)model;


@property (weak, nonatomic) IBOutlet UIStackView *stackView1;
@property (weak, nonatomic) IBOutlet UIStackView *stackView2;



@property (weak, nonatomic) IBOutlet UILabel *ysTagLbl;

@property (weak, nonatomic) IBOutlet UILabel *xsjTagLbl;
@property (weak, nonatomic) IBOutlet UILabel *cdysTagLBl;
@property (weak, nonatomic) IBOutlet UILabel *cbTagLbl;
@property (weak, nonatomic) IBOutlet UILabel *kuCunTagLBl;
@property (weak, nonatomic) IBOutlet UILabel *zuidixiaoshoujiaTagLbl;
@property (weak, nonatomic) IBOutlet UILabel *zuidikucunTagLbl;
@property (weak, nonatomic) IBOutlet UILabel *cangweiTagLbl;

@property (weak, nonatomic) IBOutlet UIImageView *colorTagImg;


@end
