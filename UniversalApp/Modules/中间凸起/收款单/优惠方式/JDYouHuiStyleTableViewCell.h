//
//  JDYouHuiStyleTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/10.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JDButtom.h"
@interface JDYouHuiStyleTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet JDButtom *styleBtn;
@property (weak, nonatomic) IBOutlet UITextField *priceTf;
@property (weak, nonatomic) IBOutlet UILabel *styleTitle;

@end
