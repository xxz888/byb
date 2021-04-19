//
//  JDAddColorTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
@class JDAddColorTableViewCell;
#import "JDAddColorModel.h"
#import "JDSelectSpModel.h"
typedef void(^editFinfishBlock)();

@protocol JDCellPriceChangeDelegate <NSObject>
-(void)priceChangeAction:(UITextField *)priceTf;
-(void)countChangeAction:(NSString *)sumCount tf:(UITextField *)countTf;
-(void)fcountChangeAction:(NSString *)sumCount count:(UITextField *)countTf fcount:(UITextField *)fcountTf;
-(void)zhuFuDanWeiTagAction:(NSInteger)tag label:(UILabel *)label;


-(void)countMinusAction:(NSString *)sumCount tf:(UITextField *)countTf count:(NSInteger)count;
-(void)saveKhkhChangeAction:(UITextField *)priceTf;
-(void)savekongchaChangeAction:(UITextField *)priceTf;
-(void)xcbeizhuChangeAction:(UITextField *)priceTf;
@end
@interface JDAddColorTableViewCell : BaseTableViewCell
//添加数量，动态改变cell高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeAddCountLayout;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak) id<JDCellPriceChangeDelegate>priceDelegate;
@property(nonatomic,weak) id<JDCellPriceChangeDelegate>countDelegate;

@property (nonatomic,strong) NSArray * dataArr;
@property (weak, nonatomic) IBOutlet UILabel *addCountLbl;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *khkhConstraint;

-(void)setCellValueData:(JDSelectSpModel *)spModel color:(JDAddColorModel *)colorModel ;


@property (nonatomic,copy) editFinfishBlock editFinfishBlock;
@property (weak, nonatomic) IBOutlet UIImageView *colorImg;
@property (weak, nonatomic) IBOutlet UILabel *colorLbl;
@property (weak, nonatomic) IBOutlet UILabel *stockLbl;

@property (weak, nonatomic) IBOutlet UITextField *sigPriceTf;
@property (weak, nonatomic) IBOutlet UITextField *countTf;
@property (weak, nonatomic) IBOutlet UITextField *khkhTf;
@property (weak, nonatomic) IBOutlet UITextField *kcTf;
@property (weak, nonatomic) IBOutlet UITextField *bzTf;
@property (weak, nonatomic) IBOutlet UITextField *fcountTf;


@property (weak, nonatomic) IBOutlet UIView *spDetailView;

@property (weak, nonatomic) IBOutlet UILabel *spNameLbl;
@property (weak, nonatomic) IBOutlet UIView *khkhView;
@property (weak, nonatomic) IBOutlet UIView *kcView;
@property (weak, nonatomic) IBOutlet UIView *bzView;
@property (nonatomic,strong) JDSelectSpModel * spModel;
@property (nonatomic,strong) JDAddColorModel * colorModel;




@property (weak, nonatomic) IBOutlet UILabel *countTag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *khkhHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kcHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bzHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *khkhWidth;

- (IBAction)selectDanWeiAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *fcountLbl;

@property (weak, nonatomic) IBOutlet UILabel *danWeiLbl;
- (IBAction)fcountDidEndAction:(UITextField *)sender;

@end
