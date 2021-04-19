//
//  JDNewAddShouKuanTableViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/10.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootTableViewController.h"
#import "JDSelectClientModel.h"
@interface JDNewAddShouKuanTableViewController : RootTableViewController


@property(nonatomic,strong)NSString * noteno;
@property(nonatomic,assign)NSInteger djzt;
@property(nonatomic,strong)NSString * jsr;

@property (weak, nonatomic) IBOutlet UILabel *clientLbl;

@property (weak, nonatomic) IBOutlet UILabel *menDianLbl;


@property (weak, nonatomic) IBOutlet UILabel *jingshourenLbl;


@property (weak, nonatomic) IBOutlet UILabel *clientLblTag;
@property (weak, nonatomic) IBOutlet UILabel *bencishoukuanLblTag;


@property (weak, nonatomic) IBOutlet UILabel *bencishoukuanLbl;

@property (weak, nonatomic) IBOutlet UILabel *zhekoujineLbl;
@property (weak, nonatomic) IBOutlet UILabel *qiankuanLbl;

@property (weak, nonatomic) IBOutlet UITextField *beizhuTf;

@property (weak, nonatomic) IBOutlet UILabel *bencishoukuanDetail;
@property (weak, nonatomic) IBOutlet UILabel *zhekoujineDetail;
@property (weak, nonatomic) IBOutlet UILabel *danjuhaoLbl;
@property (weak, nonatomic) IBOutlet UILabel *caozuoTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *caozuoyuanLbl;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;


@property (nonatomic,assign) BOOL section3Show;//yes 显示出第三组
@property (nonatomic,assign) BOOL section12Show;//yes 显示第12组
@property (nonatomic,assign) BOOL moreBtn;//yes 显示更多的按钮 no不显示



@end
