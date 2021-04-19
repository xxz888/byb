
//  JDBlueToothSettingViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/18.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDBlueToothSettingViewController.h"
#import "JDBlueToothSettingTableViewController.h"
#import "JDBluePreviewViewController.h"
#import "JDLongBlueToothTableViewController.h"

@interface JDBlueToothSettingViewController ()
@property(nonatomic,strong)JDBlueToothSettingTableViewController * VC;

@end

@implementation JDBlueToothSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打印设置";
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"JDBlueToothSettingTableViewController"]) {
        JDBlueToothSettingTableViewController * nav = [segue destinationViewController];
        self.VC = nav;
    }
}
//保存打印方案
- (IBAction)saveBtnAction:(id)sender {
    [self requestData2];
}
#define titileArray  @[@"商品颜色合并",@"商品颜色缸号合并",@"商品合并"]
-(void)requestData2{
    if ([self.VC.dayinmokuaiLbl.text isEqualToString:@"请选择打印模块"] ) {
        [self showToast:@"请选择打印模块"];
        return;
    }
    NSInteger dygs = [titileArray indexOfObject:self.VC.shujugeshiLbl.text];
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"DW_DWXX5":self.VC.danwei5Tf.text,
                                                                             @"DW_DWXX4":self.VC.danwei4Tf.text,
                                                                             @"DW_DWXX3":self.VC.danwei3Tf.text,
                                                                             @"DW_DWXX2":self.VC.danwei2Tf.text,
                                                                             @"DW_DWXX1":self.VC.danwei1Tf.text,
                                                                             @"NOTE_DYGS":@(dygs),
                                                                             @"NOTE_MHDYPS":@([self.VC.pishuTf.text integerValue]),
                                                                             @"DW_DWMC":self.VC.danweiTf.text,
                                                                             }];
         [AD_MANAGER printXiaoShouSaveAction:mDic success:^(id object) {
        [weakself showToast:@"保存成功"];
        [weakself saveCachePrintWay];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
//打印预览
- (IBAction)priviewBtnAction:(id)sender {
    [self saveCachePrintWay];
    [AD_SHARE_MANAGER pushPrintYuLan:self.navigationController];
}

//缓存打印参数
-(void)saveCachePrintWay{
    //只有这个地方才可以保存打印的参数
    NSString * wayname = [self.VC.dayinmokuaiLbl.text containsString:@"[定制]"] ? [self.VC.dayinmokuaiLbl.text replaceAll:@"[定制]" target:@""] : self.VC.dayinmokuaiLbl.text;
    NSInteger cloud = [self.VC.dayinmokuaiLbl.text containsString:@"[定制]"] ? 0 : 1;
    //保存打印参数
    [AD_MANAGER.printWay setValue:wayname forKey:@"wayname"];
    [AD_MANAGER.printWay setValue:@(cloud) forKey:@"cloud"];
}
@end
