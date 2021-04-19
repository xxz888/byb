//
//  JDJiaGongOrderTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "TableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDJiaGongOrderTableViewCell : TableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *shuliangLbl;
@property (weak, nonatomic) IBOutlet UILabel *pishuLbl;

@end

NS_ASSUME_NONNULL_END
