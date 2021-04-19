//
//  JDSalesSearchTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/13.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"
typedef void(^sendResultDicBlock)(NSMutableDictionary *);
@interface JDSalesSearchTableViewController : RootTableViewController
- (IBAction)startTimeAction:(id)sender;
- (IBAction)endTimeBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UIButton *khbqBtn;
@property (weak, nonatomic) IBOutlet UIButton *khmcBtn;

@property (weak, nonatomic) IBOutlet UITextField *spmcTf;

@property (weak, nonatomic) IBOutlet UITextField *ystf;
@property (weak, nonatomic) IBOutlet UIButton *ywyBtn;

- (IBAction)searchAction:(id)sender;
@property (nonatomic,copy) sendResultDicBlock sendBlock;

@end
