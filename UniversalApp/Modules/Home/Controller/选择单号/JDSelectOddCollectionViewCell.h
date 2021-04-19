//
//  JDSelectOddCollectionViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDSelectSpModel.h"
#import "JDAddColorModel.h"
@interface JDSelectOddCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *spTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *spNameLbl;
-(void)setValueData:(JDSelectSpModel *)model;
-(void)setColorValueData:(JDAddColorModel *)model;

@end
