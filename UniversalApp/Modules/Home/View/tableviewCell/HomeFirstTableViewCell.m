//
//  HomeFirstTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "HomeFirstTableViewCell.h"

@implementation HomeFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.searchGoodTf,16);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)searchSpTf:(id)sender {
    self.block();
}

- (IBAction)xiaoxiAction:(id)sender {
    [self showStringToast:KAIFAING];
}

- (IBAction)saoyisaoAction:(id)sender {
    [self showStringToast:KAIFAING];

}
@end
