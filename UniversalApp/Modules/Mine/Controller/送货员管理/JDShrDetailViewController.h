//
//  JDShrDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDShrDetailViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
- (IBAction)djAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *djLbl;
@property (weak, nonatomic) IBOutlet UITextView *bzTV;
- (IBAction)saveAction:(id)sender;


@property (nonatomic,assign) BOOL whereCome;
@property (nonatomic,assign) NSInteger shrid;
@end
