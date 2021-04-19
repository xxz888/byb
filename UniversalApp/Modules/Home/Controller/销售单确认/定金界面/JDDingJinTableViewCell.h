//
//  JDDingJinTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface JDDingJinTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payWayImg;
@property (weak, nonatomic) IBOutlet UILabel *pagWayName;
@property (weak, nonatomic) IBOutlet UITextField *pagWayTf;

@property (nonatomic,assign) NSInteger  zhid;
@end
