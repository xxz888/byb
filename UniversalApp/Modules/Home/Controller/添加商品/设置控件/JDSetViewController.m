//
//  JDSetViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/6/30.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSetViewController.h"

@interface JDSetViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;





@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@end

@implementation JDSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 

}


- (IBAction)makeSureAction:(id)sender {
}

- (IBAction)cancleBtnAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches anyObject].view != self.middleView) {
        // 判断点击的区域如果不是菜单按钮_btnMenu, 则关闭菜单
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)btnAction:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    



}
@end
