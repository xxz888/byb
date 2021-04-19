//
//  JDAddMdViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddMdViewController.h"
#import "SelectedListView.h"
#import "YBPopupMenu.h"
#import "JDMdCaoZuoViewController.h"

@interface JDAddMdViewController ()<YBPopupMenuDelegate,UITextViewDelegate>

@end

@implementation JDAddMdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.where isEqualToString:MMD] ? @"门店详情" : @"折扣类型详情";
    
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    self.bzTv.delegate = self;
    self.bzTv.textColor = KGrayColor;


    
    if (self.whereCome) {
        [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@90001]];
        //如果有值的话，是修改
        if ([self.where isEqualToString:MMD]) {
            self.mdLblTag.text = @"门店";
            self.mendTf.placeholder = @"请输入门店";
            self.mendTf.text = self.resultDic[@"mdmc"];
            self.bzTv.text = self.resultDic[@"bz"];
        }else if ([self.where isEqualToString:YYHFS]){
            self.mdLblTag.text = @"折扣类型";
            self.mendTf.placeholder = @"请输入折扣类型";

            self.mendTf.text = self.resultDic[@"zklxmc"];
            self.bzTv.text = self.resultDic[@"bz"];
        }
    }else{
        //如果有值的话，是修改
        if ([self.where isEqualToString:MMD]) {
            self.mdLblTag.text = @"门店";
            self.mendTf.placeholder = @"请输入门店";

        }else if ([self.where isEqualToString:YYHFS]){
            self.mdLblTag.text = @"折扣类型";
            self.mendTf.placeholder = @"请输入折扣类型";

        }
    }
 
    
   
}
#define TITLES @[@"操作记录",@"删除"]
-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:TITLES icons:nil menuWidth:120 delegate:self];
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    kWeakSelf(self);

    if (index == 0) {
        JDMdCaoZuoViewController * vc = [[JDMdCaoZuoViewController alloc]init];
        if ([self.where isEqualToString:MMD]) {
            vc.key = [self.resultDic[@"mdid"] integerValue];
            vc.type = 2;
        }else{
            vc.key = [self.resultDic[@"zklxid"] integerValue];
            vc.type = 4;
        }

        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1){
        
        
        [LEEAlert alert].config
        .LeeTitle(@"你确定要删除吗?")
        .LeeContent(@"")
        .LeeCancelAction(@"取消", ^{
            
            // 取消点击事件Block
        })
        .LeeAction(@"确认", ^{
            
            NSMutableDictionary * mDic;
            //如果有值的话，是修改
            if ([self.where isEqualToString:MMD]) {
               mDic  = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@([self.resultDic[@"mdid"] integerValue])}];
                [AD_MANAGER requestDelMdAction:mDic success:^(id object) {
                    [weakself showToast:@"删除门店成功"];
                    [weakself.navigationController popViewControllerAnimated:YES];
                }];
            }else if ([self.where isEqualToString:YYHFS]){
                mDic  = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@([self.resultDic[@"zklxid"] integerValue])}];
                [AD_MANAGER requestYHFSDelAction:mDic success:^(id object) {
                    [weakself showToast:@"优惠方式删除成功"];
                    [weakself.navigationController popViewControllerAnimated:YES];
                }];
            }
      
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示

    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (IBAction)row1Action:(id)sender {
    kWeakSelf(self);
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"未冻结"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"冻结"]];
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            weakself.row1lbl.text = model.sid == 0 ? @"否" : @"是";
        }];
    };
    
    [LEEAlert alert].config
    .LeeTitle(@"")
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeCustomView(view)
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}
- (IBAction)addAction:(id)sender {
    if (self.whereCome) {
        [self requestDataEdit];
    }else{
        [self requestDataAdd];
    }
}
-(void)requestDataAdd{
    NSDictionary * dic;
    if ([self.where isEqualToString:MMD]) {
        dic  = @{
                 @"bgrid":@(0),
                 @"jdrid":@(0),
                 @"mdid":@(0),
                 @"mdmc":self.mendTf.text,
                 @"sfdj":[self.row1lbl.text isEqualToString:@"否"] ? @(0):@(1),
                 @"bz":self.bzTv.text
                 };
    }else if ([self.where isEqualToString:YYHFS]){
        dic  = @{
                 @"zklxmc":self.mendTf.text,
                 @"sfdj":[self.row1lbl.text isEqualToString:@"否"] ? @(0):@(1),
                 @"bz":self.bzTv.text
                 };
    }
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    kWeakSelf(self);
    
    if ([self.where isEqualToString:MMD]) {
        [AD_MANAGER requestAddMdAction:mDic success:^(id object) {
            [weakself addSuccess];
        }];
    }else if ([self.where isEqualToString:YYHFS]){
        [AD_MANAGER requestYHFSAddAction:mDic success:^(id object) {
            [weakself addSuccess];
        }];
    }
   
}
-(void)addSuccess{
    kWeakSelf(self);

    [LEEAlert alert].config
    .LeeTitle(@"添加成功")
    .LeeContent(@"")
    .LeeCancelAction(@"返回列表", ^{
        [weakself.navigationController popViewControllerAnimated:YES];
        // 取消点击事件Block
    })
    .LeeAction(@"继续添加", ^{
        weakself.mendTf.text = @"";
        weakself.row1lbl.text = @"";
        weakself.bzTv.text = @"";
    })
    .LeeShow(); // 设置完成后 别忘记调用Show来显示
    

}

-(void)requestDataEdit{
    NSDictionary * dic;
    if ([self.where isEqualToString:MMD]) {
        dic  = @{@"bgrbm":self.resultDic[@"bgrbm"],
                 @"zjf":self.resultDic[@"zjf"],
                 @"bgrmc":self.resultDic[@"bgrmc"],
                 @"jdrmc":self.resultDic[@"jdrmc"],
                 @"jdrq":self.resultDic[@"jdrq"],
                 @"mdbm":self.resultDic[@"mdbm"],
                 @"jdrid":@([self.resultDic[@"jdrid"] integerValue]),
                 @"bgrid":@([self.resultDic[@"bgrid"] integerValue]),
                 @"bgrq":self.resultDic[@"bgrq"],
                 @"jdrbm":self.resultDic[@"jdrbm"],
                 @"mdid":@([self.resultDic[@"mdid"] integerValue]),
                 @"mdmc":self.mendTf.text,
                 @"sfdj":[self.row1lbl.text isEqualToString:@"否"] ? @(0):@(1),
                 @"bz":[self.bzTv.text isEqualToString:@"填写你的备注(选填)"] ? @"" : self.bzTv.text
                 };
    }else if ([self.where isEqualToString:YYHFS]){
        dic  = @{
                 @"zklxid":@([self.resultDic[@"zklxid"] integerValue]),
                 @"zklxmc":self.mendTf.text,
                 @"sfdj":[self.row1lbl.text isEqualToString:@"否"] ? @(0):@(1),
                 @"bz":[self.bzTv.text isEqualToString:@"填写你的备注(选填)"] ? @"" : self.bzTv.text,
                 };
    }
    NSString * string = [ADTool dicConvertToNSString:dic];

    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    kWeakSelf(self);
    
    if ([self.where isEqualToString:MMD]) {
        [AD_MANAGER requestEditMdAction:mDic success:^(id object) {
            [weakself showToast:@"门店修改成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }else if ([self.where isEqualToString:YYHFS]){
        [AD_MANAGER requestYHFSEditAction:mDic success:^(id object) {
            [weakself showToast:@"优惠方式修改成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }

}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length < 1){
        textView.text = @"填写你的备注(选填)";
        textView.textColor = KGrayColor;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"填写你的备注(选填)"]){
        textView.text=@"";
        textView.textColor=KGrayColor;
    }
}
@end
