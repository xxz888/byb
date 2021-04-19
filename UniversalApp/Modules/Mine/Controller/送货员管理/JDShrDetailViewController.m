//
//  JDShrDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDShrDetailViewController.h"
#import "SelectedListView.h"
#import "YBPopupMenu.h"
#import "JDMdCaoZuoViewController.h"
@interface JDShrDetailViewController ()<YBPopupMenuDelegate,UITextViewDelegate>
@property (nonatomic,strong) NSMutableDictionary * dataDic;

@end

@implementation JDShrDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataDic = [[NSMutableDictionary alloc]init];
    self.title = @"送货员详情";
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    self.bzTV.textColor = KGrayColor;

    self.bzTV.delegate = self;
    //如果有值的话，是修改
    if (self.whereCome) {
        [self requestDataEdit];
        [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@90001]];
    }
}
- (IBAction)djAction:(id)sender{
    kWeakSelf(self);
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"未冻结"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"冻结"]];
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            weakself.djLbl.text = model.sid == 0 ? @"否" : @"是";
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



- (IBAction)saveAction:(id)sender{
    if (self.whereCome) {
        [self saveEdit];
    }else{
        [self requestDataAdd];
    }
}

-(void)requestDataAdd{
    
    NSDictionary * dic = @{
                           @"shrmc":self.nameTf.text,//
                           @"sfdj":[self.djLbl.text isEqualToString:@"否"] ? @(0):@(1),//
                           @"bz":self.bzTV.text,//
                           @"sjhm":self.phoneTf.text//

                           };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    kWeakSelf(self);
    [AD_MANAGER requestSHRAddAction:mDic success:^(id object) {
        
        [LEEAlert alert].config
        .LeeTitle(@"添加成功")
        .LeeContent(@"")
        .LeeCancelAction(@"返回列表", ^{
            [weakself.navigationController popViewControllerAnimated:YES];
            // 取消点击事件Block
        })
        .LeeAction(@"继续添加", ^{
            weakself.nameTf.text = @"";
            weakself.phoneTf.text = @"";
            weakself.djLbl.text = @"";
            weakself.bzTV.text = @"";
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        
    }];
}
-(void)saveEdit{
    
    
    NSDictionary * dic = @{@"shrid":@([self.dataDic[@"shrid"] integerValue]),//
                           @"shrmc":self.nameTf.text,//
                           @"sjhm":self.phoneTf.text,//
                           @"sfdj":[self.djLbl.text isEqualToString:@"否"] ? @(0):@(1),//
                           @"bz":self.bzTV.text//
                           };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    kWeakSelf(self);
    [AD_MANAGER requestSHREditAction:mDic success:^(id object) {
        [weakself showToast:@"修改成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)requestDataEdit{
    
    
    NSDictionary * dic = @{@"id":@(self.shrid)};
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dic];
    kWeakSelf(self);
    [AD_MANAGER requestSHRShowAction:mDic success:^(id object) {
        
        weakself.dataDic = object[@"data"];
        weakself.nameTf.text = weakself.dataDic[@"shrmc"];
        weakself.phoneTf.text = weakself.dataDic[@"sjhm"];
        weakself.djLbl.text = [weakself.dataDic[@"sfdj"] integerValue] == 0 ? @"否" : @"是";
        weakself.bzTV.text = weakself.dataDic[@"bz"];
    }];
}

#define TITLES @[@"操作记录",@"删除"]
-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:TITLES icons:nil menuWidth:120 delegate:self];
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    kWeakSelf(self);
    
    if (index == 0) {
        JDMdCaoZuoViewController * vc = [[JDMdCaoZuoViewController alloc]init];
        vc.key = self.shrid;
        vc.type = 5;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1){
        
        
        [LEEAlert alert].config
        .LeeTitle(@"你确定要删除吗?")
        .LeeContent(@"")
        .LeeCancelAction(@"取消", ^{
            
            // 取消点击事件Block
        })
        .LeeAction(@"确认", ^{
            
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@([self.dataDic[@"shrid"] integerValue])}];
            [AD_MANAGER requestSHRDelAction:mDic success:^(id object) {
                [weakself showToast:@"删除成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
