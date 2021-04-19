//
//  JDSpSalesPiexTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JDPiexModel.h"
@interface JDSpSalesPiexTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *colorImg;
@property (weak, nonatomic) IBOutlet UILabel *spNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;

-(void)setCellData:(JDPiexModel *)model;
@end
