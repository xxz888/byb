//
//  JDSalesTabListTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/26.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JDSalesBtnModel.h"
@interface JDSalesTabListTableViewCell : BaseTableViewCell
-(void)setCellData:(JDSalesBtnModel *)model;
-(void)setCellData1:(JDSalesBtnModel *)model;
-(void)setCellData2:(JDSalesBtnModel *)model;
-(void)setCellData3:(JDSalesBtnModel *)model;
-(void)setCellData4:(JDSalesBtnModel *)model;

@property (weak, nonatomic) IBOutlet UILabel *psLbl;

@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@property (weak, nonatomic) IBOutlet UILabel *jeLbl;

@property (weak, nonatomic) IBOutlet UILabel *chbLbl;
@property (weak, nonatomic) IBOutlet UILabel *mlLBl;

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *rzsjLbl;
@property (weak, nonatomic) IBOutlet UILabel *ywyLbl;
@property (weak, nonatomic) IBOutlet UILabel *dhLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleView;


@property (weak, nonatomic) IBOutlet UILabel *titleView1;

@property (weak, nonatomic) IBOutlet UILabel *clientLbl;
@end
