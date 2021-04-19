//
//  JDCKTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface JDCKTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLBl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *bzLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLBlTag;
@property (weak, nonatomic) IBOutlet UILabel *adressLblTag;

@end
