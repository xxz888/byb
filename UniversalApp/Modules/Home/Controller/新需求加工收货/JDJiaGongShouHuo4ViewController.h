//
//  JDJiaGongShouHuo4ViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectSpModel.h"
#import "JDSelectClientModel.h"
#import "JDAddColorModel.h"
#import "JDAddColorTableViewCell.h"
#import "JDAddCountCollectionViewCell.h"
#import "JDJiaGongFaHuoColor3ViewController.h"
#import "JDSalesNavigationBar.h"
#import "JDSelectOddViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JDJiaGongShouHuo4ViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (nonatomic,assign) NSInteger colorCount;


@property (nonatomic,strong) JDSelectClientModel * clientModel;
@property (nonatomic,strong) JDSelectSpModel * spModel;
@property (nonatomic,strong) JDAddColorModel * colorModel;

@property (weak, nonatomic) IBOutlet UIButton *clientBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;


@property(nonatomic,copy)UITableView * underTableView;//tableview

@property (weak, nonatomic) IBOutlet UILabel *selectLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLBl;
@property (nonatomic,strong) NSString * whereCome;//判断是从哪个界面进来的
@property (nonatomic,strong) NSMutableDictionary * caogaoDic;


@property (nonatomic,assign) NSInteger collectionItemCount;//销售单item
@property (weak, nonatomic) IBOutlet UIButton *jiagongStyleBtn;
- (IBAction)jiagongStleAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *jiagongPrice;

@property (nonatomic) NSString * oddCome; // 1为从点击过来的
@end

NS_ASSUME_NONNULL_END
