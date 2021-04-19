//
//  JDAllOrderViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/1.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDAllOrderViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIImageView *btn1Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn2Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn3Img;
@property (weak, nonatomic) IBOutlet UIImageView *btn4Img;

//4个button的公用方法
- (IBAction)allBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
- (IBAction)titleBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)searchBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buildBtn;
- (IBAction)buildBtnAction:(id)sender;

- (IBAction)backAction:(id)sender;
@property (nonatomic,assign) NSInteger selectTag1;
@property (nonatomic,assign) NSInteger selectTag2;

@property(nonatomic,strong)UITableView * bottomTableView;
-(void)commonRequest:(NSString *)keywords;
@property(nonatomic,strong)NSString * whereCome;
//点击预定单已审核
-(void)cellAShenHeAxtion:(NSDictionary *)dic;


//销售单草稿
-(void)cellCCaogaoAxtion:(NSDictionary *)resultDic;
@end
