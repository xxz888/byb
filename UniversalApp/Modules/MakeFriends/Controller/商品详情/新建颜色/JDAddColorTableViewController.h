//
//  JDAddColorTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

@interface JDAddColorTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UITextField *colorTf;
@property (weak, nonatomic) IBOutlet UITextField *cdColorTf;
@property (weak, nonatomic) IBOutlet UIImageView *colorImg;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
- (IBAction)imgBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *price1Tf;
@property (weak, nonatomic) IBOutlet UITextField *lowTf;
@property (weak, nonatomic) IBOutlet UITextField *cbTf;
@property (weak, nonatomic) IBOutlet UITextField *zdkcTf;
@property (weak, nonatomic) IBOutlet UITextField *zdpsTf;


@property (nonatomic,strong) JDSelectSpModel * spModel;

@property (nonatomic,assign) BOOL whereCome;
@property (nonatomic,strong) NSString * sh;
@property (weak, nonatomic) IBOutlet UILabel *danweiLbl;

@end
