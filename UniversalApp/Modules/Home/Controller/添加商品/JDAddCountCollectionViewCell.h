//
//  JDAddCountCollectionViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol delCountDelegate <NSObject>
-(void)delCountDelegate:(NSInteger)tag;
@end

@interface JDAddCountCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak) id<delCountDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UILabel *countTitleLbl;

@end
