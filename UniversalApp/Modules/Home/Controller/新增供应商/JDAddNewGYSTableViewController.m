//
//  JDAddNewGYSTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/6.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddNewGYSTableViewController.h"
#import "JDAddNewGYSLxrViewController.h"
#import "YBPopupMenu.h"
#import "JDMdCaoZuoViewController.h"
#import "SelectedListView.h"
@interface JDAddNewGYSTableViewController ()<YBPopupMenuDelegate,UITextViewDelegate>
@property(nonatomic,strong)id object;
@property (nonatomic,strong) NSMutableDictionary * resultDic;

@end

@implementation JDAddNewGYSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.whereCome) {
        self.title = @"供应商详情";
    }else{
        self.title = @"新增供应商";
    }
    self.detailTV.textColor = KGrayColor;
    self.detailTV.delegate = self;
    
    if (self.whereCome) {
        kWeakSelf(self);
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(self.gysid)}];
        [AD_MANAGER requestGYSShowList:mDic success:^(id object) {
            _resultDic = [[NSMutableDictionary alloc]initWithDictionary:object[@"data"]];
            weakself.gysmcTf.text = _resultDic[@"gysmc"];
            weakself.gysdhTf.text = _resultDic[@"lxdh"];
            _object = [NSMutableArray arrayWithArray:_resultDic[@"tbda_gys_lxrs"]];
            weakself.lxrMcTf.text = [NSString stringWithFormat:@"%ld位联系人",[_resultDic[@"tbda_gys_lxrs"] count]];
            
            
            weakself.detailTV.text =_resultDic[@"lxdz"] ;
            
            
            
            weakself.zdyfkTf.text = CCHANGE_OTHER(_resultDic[@"zdyfk"]);
            weakself.yszkTf.text = CCHANGE_OTHER(_resultDic[@"yfzk"]);
            weakself.bzTf.text = _resultDic[@"bz"];
            [weakself.sfdjBtn setTitle:[_resultDic[@"sfdj"] integerValue] == 0 ? @"否" : @"是" forState:0];
            [weakself.yfzkBtnTag setTitle:@"欠款" forState:0];
            [weakself.addBtn setTitle:@"查看 >" forState:0];
            weakself.lxrMcTf.userInteractionEnabled = NO;
        }];
        [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@90001]];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
#define TITLES @[@"操作记录",@"删除"]
-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:TITLES icons:nil menuWidth:120 delegate:self];
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    kWeakSelf(self);
    
    if (index == 0) {
        JDMdCaoZuoViewController * vc = [[JDMdCaoZuoViewController alloc]init];
        vc.key = self.gysid;
        vc.type = 9;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (index == 1){
        
        
        [LEEAlert alert].config
        .LeeTitle(@"你确定要删除吗?")
        .LeeContent(@"")
        .LeeCancelAction(@"取消", ^{
            
            // 取消点击事件Block
        })
        .LeeAction(@"确认", ^{
            
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(self.gysid)}];
            [AD_MANAGER requestGongYingShangDelAction:mDic success:^(id object) {
                [weakself showToast:@"供应商删除成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        
    }
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

#pragma mark ========== 尾视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 85)];
    view.backgroundColor = JDRGBAColor(247, 249, 251);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, KScreenWidth - 32, 45);
    btn.center = view.center;
    NSString * title = @"";
    if (self.whereCome) {
        title = @"保存";
    }else{
        title = @"新增";
    }
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = JDRGBAColor(0, 163, 255);
    ViewRadius(btn, 5);
    btn.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(saveBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 85;
}

-(void)saveBtnclicked:(UIButton *)btn{
    [self requestData];
}
-(void)requestData{

    if (self.whereCome) {
        kWeakSelf(self);
        
        [self.resultDic setValue:@(self.gysid) forKey:@"gysid"];
        [self.resultDic setValue:_object forKey:@"tbda_gys_lxrs"];
        [self.resultDic setValue:_gysmcTf.text forKey:@"gysmc"];
        [self.resultDic setValue:[self.sfdjBtn.titleLabel.text isEqualToString:@"是"] ? @(1) :@(0) forKey:@"sfdj"];
        [self.resultDic setValue:_gysdhTf.text forKey:@"lxdh"];
        [self.resultDic setValue:_szdqTf.text forKey:@"lxdz"];
        [self.resultDic setValue:@"" forKey:@"yzbm"];
        [self.resultDic setValue:_zdyfkTf.text forKey:@"zdyfk"];
        [self.resultDic setValue:_bzTf.text forKey:@"bz"];
        NSString * string = [ADTool dicConvertToNSString:self.resultDic];
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
        [AD_MANAGER requestEditGongYingShangList:mDic success:^(id object) {
            NSInteger gysid = [object[@"data"][@"gysid"] integerValue];
            if ([weakself.object count] > 0) {
                //保存联系人
                NSString * string = [ADTool arrayConvertToNSString:weakself.object];
                NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(gysid),@"data":string}];
                [AD_MANAGER requestaddLxrList:mDic success:^(id object) {
                    [weakself requestYingFuZHangKuan:gysid];
                }];
            }else{
                [weakself requestYingFuZHangKuan:gysid];
            }
            
            
            
          
        }];
        
    }else{
        kWeakSelf(self);
        NSDictionary * dic = @{@"gysmc":_gysmcTf.text,
                               @"sfdj":[self.sfdjBtn.titleLabel.text isEqualToString:@"是"] ? @(1) :@(0),
                               @"lxdh":_gysdhTf.text,
                               @"lxdz":_szdqTf.text,
                               @"yzbm":@"",
                               @"zdyfk":_zdyfkTf.text,
                               @"bz":_bzTf.text,

                               };
        NSString * string = [ADTool dicConvertToNSString:dic];
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
        [AD_MANAGER requestAddGongYingShangList:mDic success:^(id object) {
            NSInteger gysid = [object[@"data"][@"gysid"] integerValue];
            if ([weakself.object count] > 0) {
                //保存联系人
                NSString * string = [ADTool arrayConvertToNSString:weakself.object];
                NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(gysid),@"data":string}];
                [AD_MANAGER requestaddLxrList:mDic success:^(id object) {
                    [weakself requestYingFuZHangKuan:gysid];
                }];
            }else{
                [weakself requestYingFuZHangKuan:gysid];
            }
        }];
        
    }
}

-(void)requestYingFuZHangKuan:(NSInteger)gysid{
    if ([self.yszkTf.text doubleValue] > 0) {
        NSDictionary * yfzkDic = @{@"gysid":@(gysid),@"je":@([self.yszkTf.text doubleValue])};
        NSMutableDictionary * yfzkmDic = [AD_SHARE_MANAGER requestSameParamtersDic:yfzkDic];
        [AD_MANAGER requestYingFuGongYingShangList:yfzkmDic success:^(id object) {
            [self popViewController];
        }];
    }else{
        [self popViewController];
    }
}

-(void)popViewController{
    [self showToast:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sfdjAction:(id)sender {
    kWeakSelf(self);
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"未冻结"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"冻结"]];
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
             [weakself.sfdjBtn setTitle:model.sid == 0 ? @"否" : @"是" forState:0] ;
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

- (IBAction)addLxrAction:(id)sender {
    kWeakSelf(self);
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDAddNewGYSLxrViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddNewGYSLxrViewController"];
    VC.lxrBlock = ^(id object) {
        [weakself.addBtn setTitle:@"查看 >" forState:0];
        weakself.lxrMcTf.text = [NSString stringWithFormat:@"%ld位联系人",[object count]];
        weakself.object = object;
    };
    VC.gysid = self.gysid;
    VC.whereCome = self.whereCome;
    VC.dataSource = [NSMutableArray arrayWithArray:self.object];
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if(textView.text.length < 1){
        textView.text = @"如街道、楼牌号等";
        textView.textColor = KGrayColor;
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"如街道、楼牌号等"]){
        textView.text=@"";
        textView.textColor=KGrayColor;
    }
}
- (IBAction)dingweiAction:(id)sender {
    [AD_SHARE_MANAGER dingweiAction:self.view tf:self.szdqTf tv:self.detailTV];

}
@end
