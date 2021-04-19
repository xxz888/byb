//
//  JDDYManagerTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface JDDYManagerTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *bmLbl;
@property (weak, nonatomic) IBOutlet UILabel *qxLbl;
@property (weak, nonatomic) IBOutlet UILabel *bzLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;

@end
