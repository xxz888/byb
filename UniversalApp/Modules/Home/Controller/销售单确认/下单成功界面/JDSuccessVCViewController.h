//
//  JDSuccessVCViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDSuccessVCViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *chakanOrder;
@property (nonatomic,strong) NSString *noteno;
@property (weak, nonatomic) IBOutlet UIButton *printBtn;

- (IBAction)chakanOrderAction:(id)sender;
@end
