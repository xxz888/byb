//
//  JDAddMdViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDAddMdViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *mendTf;

- (IBAction)row1Action:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *row1lbl;
@property (weak, nonatomic) IBOutlet UITextView *bzTv;
- (IBAction)addAction:(id)sender;

@property (nonatomic,strong) NSDictionary * resultDic;
- (IBAction)saveBtnAction:(id)sender;

@property (nonatomic,assign) BOOL whereCome; // yes是 有数据  no是新增
@property (nonatomic,strong) NSString * where; //
@property (weak, nonatomic) IBOutlet UILabel *mdLblTag;

@end
