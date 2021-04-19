//
//  JDAddSpViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectSpModel.h"
#import "JDSelectClientModel.h"
#import "JDAddColorModel.h"
#import "JDAddColorTableViewCell.h"
#import "JDAddCountCollectionViewCell.h"
#import "JDAddColorViewController.h"
#import "JDSalesAffirmViewController.h"
#import "JDSalesNavigationBar.h"
#import "JDSelectOddViewController.h"
@interface JDAddSpViewController : RootViewController
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

@property (nonatomic) NSString * oddCome; // 1为从点击过来的

@end
