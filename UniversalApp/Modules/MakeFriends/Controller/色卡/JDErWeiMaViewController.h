//
//  JDErWeiMaViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/24.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDErWeiMaViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIImageView *erweimaImg;
@property (nonatomic,strong) NSString *URLString;
- (IBAction)chaAction:(id)sender;

@end
