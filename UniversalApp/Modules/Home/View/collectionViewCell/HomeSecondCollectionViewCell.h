//
//  HomeSecondCollectionViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSecondCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImg;
@property (weak, nonatomic) IBOutlet UILabel *itemLbl;
-(void)setItem:(NSInteger)row tag:(NSInteger)tag;
@end
