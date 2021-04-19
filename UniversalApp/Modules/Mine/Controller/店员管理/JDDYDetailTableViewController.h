//
//  JDDYDetailTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"
#import "WLCaptcheButton.h"

@interface JDDYDetailTableViewController : RootTableViewController
@property (nonatomic,assign) NSInteger ygid;


@property (weak, nonatomic) IBOutlet UITextField *nameTf;

@property (weak, nonatomic) IBOutlet UITextField *bhTf;

- (IBAction)mdAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mdLbl;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;

@property (weak, nonatomic) IBOutlet UIButton *changePhone;
- (IBAction)changePhoneAction:(id)sender;
@property (weak, nonatomic) IBOutlet WLCaptcheButton *sendPhoneCode;
- (IBAction)sendPhoneCodeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *codePhoneTf;


- (IBAction)djAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *djLbl;
@property (weak, nonatomic) IBOutlet UITextView *bzTV;


- (IBAction)saveBtnAction:(id)sender;


@property (nonatomic,strong) NSMutableArray * array1;
@property (nonatomic,strong) NSMutableArray * array2;
@property (nonatomic,strong) NSMutableArray * array3;


@property (nonatomic,strong) NSMutableArray * myArray1;
@property (nonatomic,strong) NSMutableArray * myArray2;
@property (nonatomic,strong) NSMutableArray * myArray3;


@property (nonatomic,assign) BOOL whereCome;
@property (nonatomic,strong) NSString * phoneStr;

@end
