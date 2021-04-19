//
//  JDAddCWGLViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddCWGLViewController.h"
#import "SelectedListView.h"
#import "YBPopupMenu.h"
#import "JDMdCaoZuoViewController.h"

@interface JDAddCWGLViewController ()<YBPopupMenuDelegate,UITextViewDelegate>
@property (nonatomic,strong) NSMutableDictionary * dataDic;

@end

@implementation JDAddCWGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataDic = [[NSMutableDictionary alloc]init];
    self.title = @"账户详情";
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    self.bzTv.delegate = self;
    self.bzTv.textColor = KGrayColor;

    //如果有值的话，是修改
    if (self.whereCome) {
        [self requestDataEdit];
           [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@90001]];
    }
 
}
- (IBAction)addAction:(id)sender {
    if (self.whereCome) {
        [self saveEdit];
    }else{
        [self requestDataAdd];
    }
}
-(void)requestDataAdd{
    
    NSDictionary * dic = @{
                           @"zhid":@(0),
                           @"zhmc":self.mcTf.text,
                           @"sfdj":[self.djLbl.text isEqualToString:@"否"] ? @(0):@(1),
                           @"zhjc":self.jcTf.text,
                           @"ckid":@(0),
                           @"zhlx":[self.zhlxLbl.text isEqualToString:@"现金"] ? @(0) :
                               [self.zhlxLbl.text isEqualToString:@"银行"] ? @(1) :
                               [self.zhlxLbl.text isEqualToString:@"支付宝"] ? @(2) :
                               [self.zhlxLbl.text isEqualToString:@"微信"] ? @(3) : @(4),
                           @"zh":self.zhTf.text,
                           @"bz":self.bzTv.text,
                           @"ckmc":@"",
                           @"ckbm":@"",
                         

                           };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    kWeakSelf(self);
    [AD_MANAGER requestCWGLAddAction:mDic success:^(id object) {
        
        [LEEAlert alert].config
        .LeeTitle(@"添加成功")
        .LeeContent(@"")
        .LeeCancelAction(@"返回列表", ^{
            [weakself.navigationController popViewControllerAnimated:YES];
            // 取消点击事件Block
        })
        .LeeAction(@"继续添加", ^{
            weakself.mcTf.text = @"";
            weakself.jcTf.text = @"";
            weakself.zhlxLbl.text = @"";
            weakself.zhTf.text = @"";
            weakself.djLbl.text = @"";
            weakself.bzTv.text =@"";
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        
    }];
}
-(void)saveEdit{

    
    NSDictionary * dic = @{@"zhid":@([self.dataDic[@"zhid"] integerValue]),//
                           @"zhmc":self.mcTf.text,//
                           @"sfdj":[self.djLbl.text isEqualToString:@"否"] ? @(0):@(1),//

                           @"zhjc":self.jcTf.text,//
                           @"ckid":@([self.dataDic[@"ckid"] integerValue]),//
                           @"zhlx":[self.zhlxLbl.text isEqualToString:@"现金"] ? @(0) ://
                                   [self.zhlxLbl.text isEqualToString:@"银行"] ? @(1) :
                                   [self.zhlxLbl.text isEqualToString:@"支付宝"] ? @(2) :
                                   [self.zhlxLbl.text isEqualToString:@"微信"] ? @(3) : @(4),
                           @"zh":self.zhTf.text,//
                           @"bz":self.bzTv.text,//
                           };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    kWeakSelf(self);
    [AD_MANAGER requestCWGLEditAction:mDic success:^(id object) {
        [weakself showToast:@"修改成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)requestDataEdit{
    
    
    NSDictionary * dic = @{@"id":@(self.cwuglId)};
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dic];
    kWeakSelf(self);
    [AD_MANAGER requestCWGLShowAction:mDic success:^(id object) {
        
        weakself.dataDic = object[@"data"];
        NSString * str1 =  [dic[@"zhlx"] integerValue] == 0 ? @"现金" :
        [dic[@"zhlx"] integerValue] == 1 ? @"银行" :
        [dic[@"zhlx"] integerValue] == 2 ? @"支付宝" :
        [dic[@"zhlx"] integerValue] == 3 ? @"微信" : @"其他";
        
        
        
        
        weakself.mcTf.text = weakself.dataDic[@"zhmc"];
        weakself.jcTf.text = weakself.dataDic[@"zhjc"];
        weakself.zhlxLbl.text = str1;
        weakself.zhTf.text = weakself.dataDic[@"zh"];
        weakself.djLbl.text = [weakself.dataDic[@"sfdj"] integerValue] == 0 ? @"否" : @"是";
        weakself.bzTv.text = weakself.dataDic[@"bz"];
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
        vc.key = [self.dataDic[@"zhid"] integerValue];
        vc.type = 6;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1){
        
        
        [LEEAlert alert].config
        .LeeTitle(@"你确定要删除吗?")
        .LeeContent(@"")
        .LeeCancelAction(@"取消", ^{
            
            // 取消点击事件Block
        })
        .LeeAction(@"确认", ^{
            
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@([self.dataDic[@"zhid"] integerValue])}];
            [AD_MANAGER requestCWGLDelAction:mDic success:^(id object) {
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
//账户类型
- (IBAction)zhlxAction:(id)sender {
    kWeakSelf(self);
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"现金"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"银行"],
                    [[SelectedListModel alloc] initWithSid:2 Title:@"支付宝"],
                    [[SelectedListModel alloc] initWithSid:3 Title:@"微信"],
                    [[SelectedListModel alloc] initWithSid:4 Title:@"其他"]];
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            weakself.zhlxLbl.text = model.title;
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
//是否冻结
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
