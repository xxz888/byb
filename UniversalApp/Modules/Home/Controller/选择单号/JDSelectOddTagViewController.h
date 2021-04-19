//
//  JDSelectOddTagViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/16.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@protocol spVCDissmissVCDelegate <NSObject>
-(void)spVCdissmissValue;
@end
@interface JDSelectOddTagViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextAction:(id)sender;
@property (nonatomic,strong) JDSelectSpModel * spModel;
@property (nonatomic,weak) id<spVCDissmissVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
- (IBAction)cancleAction:(id)sender;
@property (nonatomic,strong) NSString *OpenType;

@end
