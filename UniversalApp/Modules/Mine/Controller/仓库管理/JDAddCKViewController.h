//
//  JDAddCKViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDAddCKViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *mcTf;
- (IBAction)typeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UITextField *mjTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextView *detailTV;
- (IBAction)djAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *djLbl;
@property (weak, nonatomic) IBOutlet UITextView *bzTV;
- (IBAction)saveAction:(id)sender;
@property (nonatomic,assign) BOOL whereCome; // yes是 有数据  no是新增
@property (nonatomic,assign) NSInteger ckid;//仓库管理的id



@end
