//
//  JDYsqvKLineViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/26.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDYsqvKLineViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIView *kLineView;
- (IBAction)selectSegmentAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
- (IBAction)clickBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *beginLbl;
@property (weak, nonatomic) IBOutlet UILabel *endLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
