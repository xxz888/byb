//
//  JDAddCKViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddCKViewController.h"
#import "SelectedListView.h"
#import "YBPopupMenu.h"
#import "JDMdCaoZuoViewController.h"

@interface JDAddCKViewController ()<YBPopupMenuDelegate,UITextViewDelegate>
@property (nonatomic,strong) NSMutableDictionary * dataDic;

@end

@implementation JDAddCKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"仓库详情";
    _dataDic = [[NSMutableDictionary alloc]init];

    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    self.bzTV.delegate = self;
    self.bzTV.textColor = KGrayColor;

    //如果有值的话，是修改
    if (self.whereCome) {
        [self requestDataEdit];
        [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@90001]];
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
        vc.key = self.ckid;
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (index == 1){
        
        
        [LEEAlert alert].config
        .LeeTitle(@"你确定要删除吗?")
        .LeeContent(@"")
        .LeeCancelAction(@"取消", ^{
            
            // 取消点击事件Block
        })
        .LeeAction(@"确认", ^{
            
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@([self.dataDic[@"ckid"] integerValue])}];
            [AD_MANAGER requestDelCKAction:mDic success:^(id object) {
                [weakself showToast:@"删除门店成功"];
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


- (IBAction)row1Action:(id)sender {
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
- (IBAction)addAction:(id)sender {
    if (self.whereCome) {
        [self requestDataEdit];
    }else{
        [self requestDataAdd];
    }
}
-(void)requestDataAdd{
    
    NSDictionary * dic = @{
                           @"bz":self.bzTV.text,
                           @"sf":@"",
                           @"lxdh":self.phoneTf.text,
                           @"jtdz":self.detailTV.text,
                           @"ckmc":self.mcTf.text,
                           @"cs":@"",
                           @"jd":@"",
                           @"cdmj":self.mjTf.text,
                           @"isselect":@(NO),
                           @"ckid":@(0),
                           @"jdrid":@(0),
                           @"bgrid":@(0),
                           @"sfdj":[self.djLbl.text isEqualToString:@"否"] ? @(0):@(1),

                           };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    kWeakSelf(self);
    [AD_MANAGER requestAddCKction:mDic success:^(id object) {
        
        [LEEAlert alert].config
        .LeeTitle(@"添加成功")
        .LeeContent(@"")
        .LeeCancelAction(@"返回列表", ^{
            [weakself.navigationController popViewControllerAnimated:YES];
            // 取消点击事件Block
        })
        .LeeAction(@"继续添加", ^{
            weakself.mcTf.text = @"";
            weakself.typeLbl.text = @"";
            weakself.mjTf.text = @"";
            weakself.phoneTf.text = @"";
            weakself.detailTV.text = @"";
            weakself.djLbl.text =@"";
            weakself.bzTV.text = @"";
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        
    }];
}


-(void)requestDataEdit{
    
    
    NSDictionary * dic = @{@"id":@(self.ckid)};
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dic];
    kWeakSelf(self);
    [AD_MANAGER requestShowCKAction:mDic success:^(id object) {

        weakself.dataDic = object[@"data"];
        NSString * str1 = [dic[@"cklx"] integerValue] == 0 ? @"配货仓" :
        [dic[@"cklx"] integerValue] == 1 ? @"储存仓":
        [dic[@"cklx"] integerValue] == 2 ? @"退货仓":@"次品仓";
        
        
        
        
        weakself.mcTf.text = weakself.dataDic[@"ckmc"];
        weakself.typeLbl.text = str1;
        weakself.mjTf.text = doubleToNSString([weakself.dataDic[@"cdmj"] doubleValue]);
        weakself.phoneTf.text = weakself.dataDic[@"lxdh"];
        weakself.detailTV.text = weakself.dataDic[@"jtdz"];
        weakself.djLbl.text = [weakself.dataDic[@"sfdj"] integerValue] == 0 ? @"否" : @"是";
        weakself.bzTV.text = weakself.dataDic[@"bz"];
    }];
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

- (IBAction)typeAction:(id)sender {
    kWeakSelf(self);
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"配货仓"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"储存仓"],
                   [[SelectedListModel alloc] initWithSid:2 Title:@"退货仓"],
                   [[SelectedListModel alloc] initWithSid:3 Title:@"次品仓"]];
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            weakself.typeLbl.text = model.title;
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
- (IBAction)djAction:(id)sender {
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
- (IBAction)saveAction:(id)sender {
    if (self.whereCome) {
        [self saveEdit];
    }else{
        [self requestDataAdd];
    }
}



-(void)saveEdit{
    NSDictionary * dic = @{@"bgrbm":self.dataDic[@"bgrbm"],
                           @"zjf":self.dataDic[@"zjf"],
                           @"bgrq":self.dataDic[@"bgrq"],
                           @"bgrmc":self.dataDic[@"bgrmc"],
                           @"jdrmc":self.dataDic[@"jdrmc"],
                           @"jdrq":self.dataDic[@"jdrq"],
                           @"sf":self.dataDic[@"sf"],
                           @"ckbm":self.dataDic[@"sf"],
                           @"cs":self.dataDic[@"cs"],
                           @"dq":self.dataDic[@"dq"],
                           @"jdrbm":@([self.dataDic[@"jdrbm"] integerValue]),
                           @"isselect":@(NO),
                           @"cklx":@([self.dataDic[@"cklx"] integerValue]),
                           @"ckid":@([self.dataDic[@"ckid"] integerValue]),
                           @"jdrid":@([self.dataDic[@"jdrid"] integerValue]),
                           @"bgrid":@([self.dataDic[@"bgrid"] integerValue]),

                           @"lxdh":self.phoneTf.text,
                           @"jtdz":self.detailTV.text,
                           @"ckmc":self.mcTf.text,
                           @"cdmj":@([self.mjTf.text doubleValue]),
                           @"sfdj":[self.djLbl.text isEqualToString:@"否"] ? @(0):@(1),
                           @"bz":self.bzTV.text
                           };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    kWeakSelf(self);
    [AD_MANAGER requestEDitCKction:mDic success:^(id object) {
        [weakself showToast:@"修改仓库成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
@end
