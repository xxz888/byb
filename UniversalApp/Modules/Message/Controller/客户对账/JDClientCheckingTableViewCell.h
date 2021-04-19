//
//  JDClientCheckingTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
typedef void(^weiXinBlock)(NSInteger);
@interface JDClientCheckingTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *clientLBl;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;

@property (weak, nonatomic) IBOutlet UILabel *lbl6;
@property (weak, nonatomic) IBOutlet UILabel *lbl7;

@property (weak, nonatomic) IBOutlet UILabel *rightLbl;
@property (weak, nonatomic) IBOutlet UILabel *shoukuanTag;
@property (weak, nonatomic) IBOutlet UILabel *qimoyingshouTag;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
- (IBAction)weixinAction:(id)sender;
@property (nonatomic,copy) weiXinBlock weixinblock;
@end
