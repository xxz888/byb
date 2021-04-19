//
//  JDYangPinDanTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JDSelectSpModel.h"
#import "JDAddColorModel.h"


typedef void(^editFinfishBlock)();
@class JDYangPinDanTableViewCell;

@protocol JDYangPinDanChangeDelegate <NSObject>

-(void)priceYpChangeAction:(UITextField *)priceTf ;
-(void)piShuChangeAction:(UITextField *)priceTf;
-(void)ChangDuChangeAction:(UITextField *)priceTf;

-(void)khkhChangeAction:(UITextField *)priceTf;
-(void)kongchaChangeAction:(UITextField *)priceTf;
-(void)beizhuChangeAction:(UITextField *)priceTf;
-(void)danweiChangeAction:(UILabel *)lbl;
-(void)zhuFuDanWeiTag:(NSInteger)tag label:(UILabel *)label;

@end


@interface JDYangPinDanTableViewCell : BaseTableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *colorImg;
@property (weak, nonatomic) IBOutlet UILabel *colorLbl;
@property (weak, nonatomic) IBOutlet UILabel *stockLbl;

@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UITextField *tf3;
@property (weak, nonatomic) IBOutlet UITextField *tf4;
@property (weak, nonatomic) IBOutlet UITextField *tf5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *psWidth;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
- (IBAction)btn1Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//空差离左边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kongchaConstraint;
//备注离最上边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beizhuConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

//设置view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setViewHConstraint;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UITextField *view3;
-(void)setCellValueData:(JDSelectSpModel *)spModel color:(JDAddColorModel *)colorModel;

@property (weak, nonatomic) IBOutlet UIView *psView;

- (IBAction)tf1Change:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lbl3;


@property(nonatomic,weak) id<JDYangPinDanChangeDelegate> yangpinDelegate;

@property (nonatomic,copy) editFinfishBlock editFinfishBlock;
@end


