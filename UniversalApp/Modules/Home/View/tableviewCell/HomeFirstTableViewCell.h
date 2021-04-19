//
//  HomeFirstTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface HomeFirstTableViewCell : BaseTableViewCell

- (IBAction)xiaoxiAction:(id)sender;

- (IBAction)saoyisaoAction:(id)sender;







typedef void(^tfChange)();
@property (weak, nonatomic) IBOutlet UITextField *searchGoodTf;
@property (nonatomic,copy) tfChange block;
@end
