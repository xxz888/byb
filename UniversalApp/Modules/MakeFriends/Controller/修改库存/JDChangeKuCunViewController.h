//
//  JDChangeKuCunViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/25.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDChangeKuCunViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *selectCangKuBtn;
- (IBAction)selectCangKuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,assign) NSInteger spid;
@property (nonatomic,assign) NSInteger ckid;

@end
