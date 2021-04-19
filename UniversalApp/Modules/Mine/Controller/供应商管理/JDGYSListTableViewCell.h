//
//  JDGYSListTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/7.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface JDGYSListTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *lxrInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *qqlbl;
@property (weak, nonatomic) IBOutlet UITextView *addressTV;
@property (weak, nonatomic) IBOutlet UILabel *yfzkLbl;
@property (weak, nonatomic) IBOutlet UILabel *sfzkLbl;
@property (weak, nonatomic) IBOutlet UILabel *qkLbl;

@end
