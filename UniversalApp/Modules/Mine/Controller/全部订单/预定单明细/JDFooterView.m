//
//  JDFooterView.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDFooterView.h"

@implementation JDFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btn1Action:(UIButton *)btn {
    self.bt1Block(btn);
}

- (IBAction)btn2Action:(UIButton *)btn {
    self.bt2Block();
}
@end
