//
//  JDSpDetailViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSpDetailViewController.h"
#import "SDCycleScrollView.h"
#import "JDNewAddSpTableViewController.h"
#import "JDColorDetailListViewController.h"
#import "JDLongBlueToothTableViewController.h"
#import "JDChangeKuCunViewController.h"
#import "ZoomImageView.h"
#import "ImageScale.h"
@interface JDSpDetailViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) NSMutableDictionary * spDetailDic;
@property (nonatomic,strong) NSMutableArray * colorImgArray;
@property (nonatomic, strong) ImageScale *imageScale;


@end

@implementation JDSpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    _colorImgArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    ViewBorderRadius(self.printBQBtn, 5, 0.5, JDRGBAColor(0, 163, 255));

    NSMutableDictionary* mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pagesize":@"500"}];
    [AD_MANAGER requestSelectCkPage:mDic1 success:^(id object) {}];
    
    ViewRadius(self.editBtn, 5);
    [self addNavigationItemWithTitles:@[@"编辑"] isLeft:NO target:self action:@selector(editSpDetail:) tags:@[@9001]];

}
//编辑
-(void)editSpDetail:(UIButton *)btn{
    
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDNewAddSpTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDNewAddSpTableViewController"];
    VC.resultDic  = _spDetailDic;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self requestData];

}

//商品详情请求
-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(self.spModel.spid)}];
    [AD_MANAGER requestShangPinDetailAction:mDic success:^(id object) {
        _spDetailDic = [[NSMutableDictionary alloc]init];
        _spDetailDic = object[@"data"];
        NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"spid":@([_spDetailDic[@"spid"] integerValue])}];
        [AD_MANAGER requestColorDetailAction:mDic1 success:^(id object) {
            [_colorImgArray removeAllObjects];
            [_colorImgArray addObjectsFromArray:object[@"data"]];
            //开始赋值
            [weakself setAllConValue];
        }];
    }];
}
-(void)setAllConValue{
    self.lbl1.text = self.spDetailDic[@"spmc"];
    self.lbl2.text = self.spDetailDic[@"sphh"];
    self.lbl3.text = self.spDetailDic[@"cf"];
    self.lbl4.text = self.spDetailDic[@"fk"];
    
    self.Albl1.text = self.spDetailDic[@"jldw"];
    self.Albl2.text = self.spDetailDic[@"kz"];
    self.Albl3.text = self.spDetailDic[@"gysmc"];
    self.Albl4.text = self.spDetailDic[@"gysbz"];
    
    self.Blbl1.text = self.spDetailDic[@"mgjm"];
    self.Blbl2.text = self.spDetailDic[@"gyshh"];
    
    self.Clbl1.text = NSIntegerToNSString([self.spDetailDic[@"yscount"] integerValue]);
    self.Clbl2.text = doubleToNSString([self.spDetailDic[@"spsl"] doubleValue]);
    
    
    NSMutableArray * urlArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in _colorImgArray) {
        if ([dic[@"oritpurl"] length] != 0) {
            [urlArray addObject:dic[@"oritpurl"]];

        }
    }
    
    
    [self setUpSycleScrollView:urlArray];


}
//添加滚动视图
- (void)setUpSycleScrollView:(NSMutableArray *)imageArray{
    
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.underView.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    cycleScrollView3.bannerImageViewContentMode =  1;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.autoScrollTimeInterval = 4;
    cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:imageArray];
    [cycleScrollView3 setPlaceholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.underView addSubview:cycleScrollView3];
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index imageView:(UIImageView *)imageView{
    self.imageScale= [ImageScale new];
    [self.imageScale scaleImageView:imageView];
//    KGestureRecognizerType gRType= 0;
//    [[ZoomImageView getZoomImageView]showZoomImageView:imageView addGRType:gRType];
}


- (IBAction)colorDetailAction:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDColorDetailListViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDColorDetailListViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.spModel= self.spModel;
    [self.navigationController pushViewController:VC animated:YES];
    
}

//批量修改颜色库存
- (IBAction)editAction:(id)sender {
    
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDChangeKuCunViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDChangeKuCunViewController"];
    VC.spid = self.spModel.spid;
    [self.navigationController pushViewController:VC animated:YES];
}
//打印标签
- (IBAction)printBQAction:(id)sender {
        AD_MANAGER.orderType = SPDA;
        
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"OtherVC" bundle:nil];
        JDLongBlueToothTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDLongBlueToothTableViewController"];
        VC.spid = self.spModel.spid;
        VC.whereCome = YES;
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
}
@end
