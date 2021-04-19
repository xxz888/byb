//
//  JDZhiFaDan5TableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/30.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDZhiFaDan5TableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *colorImg;
@property (weak, nonatomic) IBOutlet UILabel *colorLbl;
@property (weak, nonatomic) IBOutlet UILabel *stockLbl;
@property (weak, nonatomic) IBOutlet UILabel *jinjiaLbl;

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@end

NS_ASSUME_NONNULL_END
