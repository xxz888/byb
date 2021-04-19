//
//  JDDYManagerCollectionViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDDYManagerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
- (IBAction)collectAction:(id)sender;

@end
