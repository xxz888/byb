//
//  JDZhiFaDan4CollectionViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/21.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDZhiFaDan4CollectionViewCell.h"

@implementation JDZhiFaDan4CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)delAction:(UIButton*)sender{
    self.delBlock(sender.tag);
}
@end
