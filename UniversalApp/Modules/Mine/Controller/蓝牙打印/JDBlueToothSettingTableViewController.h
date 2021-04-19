//
//  JDBlueToothSettingTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/18.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

@interface JDBlueToothSettingTableViewController : RootTableViewController
@property (nonatomic,strong) NSMutableDictionary * resultDic;
@property (weak, nonatomic) IBOutlet UITextField *danweiTf;
@property (weak, nonatomic) IBOutlet UITextField *pishuTf;
@property (weak, nonatomic) IBOutlet UILabel *shujugeshiLbl;
@property (weak, nonatomic) IBOutlet UILabel *dayinmokuaiLbl;
@property (weak, nonatomic) IBOutlet UITextField *fenshuTf;
@property (weak, nonatomic) IBOutlet UITextField *danwei1Tf;
@property (weak, nonatomic) IBOutlet UITextField *danwei2Tf;
@property (weak, nonatomic) IBOutlet UITextField *danwei3Tf;
@property (weak, nonatomic) IBOutlet UITextField *danwei4Tf;
@property (weak, nonatomic) IBOutlet UITextField *danwei5Tf;
@property (nonatomic,strong) NSString *printWay;

@end
