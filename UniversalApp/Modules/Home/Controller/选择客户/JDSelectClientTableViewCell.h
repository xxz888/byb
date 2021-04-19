//
//  JDSelectClientTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JDSelectClientModel.h"
@interface JDSelectClientTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *clientNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *creditLbl;


-(void)setValueModel:(JDSelectClientModel *)model;
@end
