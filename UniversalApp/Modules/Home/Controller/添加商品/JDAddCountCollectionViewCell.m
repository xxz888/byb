//
//  JDAddCountCollectionViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddCountCollectionViewCell.h"

@implementation JDAddCountCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.delBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.delBtn.titleLabel.bounds.size.width, 0, -self.delBtn.titleLabel.bounds.size.width + 10)];

}
- (IBAction)delCountAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(delCountDelegate:)]) {
        [_delegate delCountDelegate:btn.tag];
    }
}

@end
