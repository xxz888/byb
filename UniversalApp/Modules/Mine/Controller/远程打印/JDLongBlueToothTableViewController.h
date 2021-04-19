//
//  JDLongBlueToothTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

@interface JDLongBlueToothTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UILabel *printstyleLbl;
@property (weak, nonatomic) IBOutlet UITextField *countLbl;
- (IBAction)longPrintAction:(id)sender;
- (IBAction)printPriviewAction:(id)sender;
- (IBAction)printSelectAction:(id)sender;
@property (nonatomic,strong) NSMutableArray * shArray;
@property (nonatomic,assign) NSInteger spid;
@property (nonatomic,strong) NSString *printWay;
- (IBAction)spPrintAction:(id)sender;
@property (nonatomic,assign) BOOL whereCome; // yes 是从商品界面过来的
@end
