//
//  JDOrder1FaHuoTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol JDCellTfChangeDelegate <NSObject>
-(void)countChangeAction:(UITextField *)tf array:(NSMutableArray *)array;
-(void)delChangeAction:(UITextField *)tf array:(NSMutableArray *)array;

@end
@interface JDOrder1FaHuoTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;
@property (weak, nonatomic) IBOutlet UITextField *msTf;
- (IBAction)msTfAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addMsBtn;
//- (IBAction)addMsActionf:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addViewHConstraint;

@property (weak, nonatomic) IBOutlet UILabel *Blbl1;
@property (weak, nonatomic) IBOutlet UILabel *Blbl2;
@property (weak, nonatomic) IBOutlet UILabel *Blbl3;
- (IBAction)fMsAction:(id)sender;


@property (nonatomic,strong) NSMutableArray * countArray;
@property (weak, nonatomic) IBOutlet UILabel *danweiLbl;

- (IBAction)btnAction:(id)sender;

@property (nonatomic,weak) id<JDCellTfChangeDelegate> countDelegate;
@property (weak, nonatomic) IBOutlet UIView *collectSubView;
@property (nonatomic,strong) NSString * danweiStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subHeight;

@property (nonatomic,assign) double  price;
@property (weak, nonatomic) IBOutlet UITextField *fuMsTf;

-(void)setCellDic:(NSDictionary * )dic;
@end
