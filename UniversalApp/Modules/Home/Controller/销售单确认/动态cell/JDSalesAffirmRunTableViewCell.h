//
//  JDSalesAffirmRunTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JDSelectClientModel.h"
#import "JDAddColorModel.h"
#import "JDSelectSpModel.h"
@class JDSalesAffirmRunTableViewCell;
typedef void(^editBlock) ();
typedef void(^upDownBlock)(JDSalesAffirmRunTableViewCell * currentCell);
@interface JDSalesAffirmRunTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *spLbl;
@property (weak, nonatomic) IBOutlet UILabel *colorLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *colorImg;
@property (weak, nonatomic) IBOutlet UIButton *upDownBtn;
- (IBAction)upDownBtnAction:(id)sender;
-(void)setRunColorValue:(JDSelectClientModel *)clientModle colorModel:(JDAddColorModel *)colorModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgUnderHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (nonatomic,strong) JDSelectSpModel * spModel;
@property (nonatomic,strong) JDAddColorModel * colorModel;

@property (weak, nonatomic) IBOutlet UIView *collectSubView;
@property (weak, nonatomic) IBOutlet UILabel *detailxsslLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
-(void)setChuKuDetail:(NSDictionary *)dic;
@property (nonatomic,copy) upDownBlock upDownBlock;
@end
