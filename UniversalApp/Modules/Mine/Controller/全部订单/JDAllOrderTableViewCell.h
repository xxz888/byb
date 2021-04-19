//
//  JDAllOrderTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/1.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface JDAllOrderTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightLbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;

@property (weak, nonatomic) IBOutlet UILabel *lbl6;
@property (weak, nonatomic) IBOutlet UILabel *lbl7;
@property (weak, nonatomic) IBOutlet UILabel *lbl8;
@property (weak, nonatomic) IBOutlet UILabel *lbl1tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl3tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl2tag;
@property (weak, nonatomic) IBOutlet UIImageView *titleImgV;
@property (weak, nonatomic) IBOutlet UILabel *lbl7Tag;
@property (weak, nonatomic) IBOutlet UIView *shoukuanView;
@property (weak, nonatomic) IBOutlet UILabel *shouKuanLbl;
@property (weak, nonatomic) IBOutlet UILabel *middleLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastLbl;

@property (weak, nonatomic) IBOutlet UILabel *firstLbl;
-(void)setYangPinAndYuDing:(NSDictionary *)dic titleBtn:(NSString *)title;
-(void)setXiaoShouDan:(NSDictionary *)dic titleBtn:(NSString *)title;
-(void)setShouKuanDan:(NSDictionary *)dic titleBtn:(NSString *)title;
-(void)setChuKuDan:(NSDictionary *)dic titleBtn:(NSString *)title;




@end
