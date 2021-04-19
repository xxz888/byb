//
//  JDZhiFaDan4CollectionViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/21.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^delActionBlock)(NSInteger);
@interface JDZhiFaDan4CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
- (IBAction)delAction:(id)sender;
@property (nonatomic,copy) delActionBlock delBlock;

@end

NS_ASSUME_NONNULL_END
