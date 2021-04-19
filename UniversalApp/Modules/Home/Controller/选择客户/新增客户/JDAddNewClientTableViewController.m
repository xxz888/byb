

//
//  JDAddNewClientTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddNewClientTableViewController.h"
#import "SelectedListView.h"
#import "JDSelectYgModel.h"
#import "WTTableAlertView.h"
#import "YBPopupMenu.h"
#import "JDMdCaoZuoViewController.h"
#import "JDAddNewGYSLxrViewController.h"
// 导入封装类头文件
#import "SYCLLocation.h"
@interface JDAddNewClientTableViewController ()<UITextFieldDelegate,YBPopupMenuDelegate>{
    NSInteger _ywyid;
    NSMutableDictionary * _resultDic;
}
@property (nonatomic,strong) NSMutableArray * object;

@end

@implementation JDAddNewClientTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.whereCome) {
        self.title = @"客户详情";
    }else{
        self.title = @"新增客户";
    }
    LoginModel * model = AD_USERDATAARRAY;

    _ywyid = 0;
    //门店赋值
    self.lbl9.text = model.mdmc;
    
    self.tf1.delegate = self;
    self.tf7.delegate = self;
    self.tf10.delegate = self;
    self.tf11.delegate = self;
    self.tf13.delegate = self;
    
    if (self.whereCome) {
        kWeakSelf(self);
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(self.khid)}];
        [AD_MANAGER requestClientList:mDic success:^(id object) {
            NSMutableDictionary * dic = object[@"data"];
            _resultDic = [[NSMutableDictionary alloc]initWithDictionary:object[@"data"]];
            weakself.tf1.text = dic[@"khmc"];
            weakself.lxrTf.text = [NSString stringWithFormat:@"%ld位联系人",[_resultDic[@"tbda_kh_lxrs"] count]];
            [weakself.lxrBtn setTitle:@"查看 >" forState:0];
            weakself.object = [NSMutableArray arrayWithArray:_resultDic[@"tbda_kh_lxrs"]];
            weakself.tf7.text  = dic[@"lxdz"];
            weakself.tf8.text  = dic[@"lxdz"];
            [weakself.btn8 setTitle:dic[@"ywymc"] forState:0];
            weakself.lbl9.text = dic[@"mdmc"];
            [weakself.btn9 setTitle:dic[@"tag"] forState:0];
            weakself.tf10.text = dic[@"bz"];
            weakself.tf11.text = doubleToNSString([dic[@"zdysk"] doubleValue]);
            [weakself.btn12 setTitle:[dic[@"sfdj"] integerValue] == 0 ? @"否" :@"是" forState:0];
            weakself.tf13.text = doubleToNSString([dic[@"yszk"] doubleValue]);
        }];
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
        vc.key = self.khid;
        vc.type = 8;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (index == 1){
        
        
        [LEEAlert alert].config
        .LeeTitle(@"你确定要删除吗?")
        .LeeContent(@"")
        .LeeCancelAction(@"取消", ^{
            
            // 取消点击事件Block
        })
        .LeeAction(@"确认", ^{
            
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(self.khid)}];
            [AD_MANAGER requestdeleteClient:mDic success:^(id object) {
                [weakself showToast:@"客户删除成功"];
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

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
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
    
    if (self.whereCome) {
        [self editClient];
    }else{
        [self addNewClient];
    }
    

    
}
-(void)editClient{
    
    [_resultDic setValue:_tf1.text forKey:@"khmc"];
    [_resultDic setValue:[self.btn12.titleLabel.text isEqualToString:@"是"] ? @(1) :@(0) forKey:@"sfdj"];
    [_resultDic setValue:@(_ywyid) forKey:@"ywyid"];
    [_resultDic setValue:self.tf8.text forKey:@"lxdz"];
    [_resultDic setValue:@([self.tf11.text doubleValue]) forKey:@"zdysk"];
    [_resultDic setValue:self.btn9.titleLabel.text forKey:@"tag"];
    [_resultDic setValue:@([self.tf13.text doubleValue]) forKey:@"yszk"];
    [_resultDic setValue:self.btn8.titleLabel.text forKey:@"ywymc"];

    kWeakSelf(self);
    NSString * string = [ADTool dicConvertToNSString:_resultDic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    [AD_MANAGER requestEditClient:mDic success:^(id object) {
        NSInteger khid = [object[@"data"][@"khid"] integerValue];
        if ([weakself.object count] > 0) {
            //保存联系人
            NSString * string = [ADTool arrayConvertToNSString:weakself.object];
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(khid),@"data":string}];
            [AD_MANAGER requestaddKhLxrList:mDic success:^(id object) {
                [weakself requestYingShouZHangKuan:khid];
            }];
        }else{
            [weakself requestYingShouZHangKuan:khid];
        }
    }];
}


-(void)addNewClient{
    LoginModel * model = AD_USERDATAARRAY;

    NSDictionary * dic = @{@"khmc":_tf1.text,
                           @"sfdj":[self.btn12.titleLabel.text isEqualToString:@"是"] ? @(1) :@(0),
                           @"ywyid":@(_ywyid),
                           @"lxdh":_tf2.text,
                           @"lxdz":[self.tf7.text append:self.tf8.text],
                           @"zdysk":@([self.tf11.text doubleValue]),
                           @"tag":self.btn9.titleLabel.text,
                           @"tbda_kh_addresss":@[],
                           @"yszk":@([self.tf13.text doubleValue]),
                           @"ywymc":self.btn8.titleLabel.text,
                           @"mdid":model.mdid
                           };
    
    kWeakSelf(self);
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    [AD_MANAGER requestAddClient:mDic success:^(id object) {
        NSInteger khid = [object[@"data"][@"khid"] integerValue];
        if ([weakself.object count] > 0) {
            //保存联系人
            NSString * string = [ADTool arrayConvertToNSString:weakself.object];
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(khid),@"data":string}];
            [AD_MANAGER requestaddKhLxrList:mDic success:^(id object) {
                [weakself requestYingShouZHangKuan:khid];
            }];
        }else{
            [weakself requestYingShouZHangKuan:khid];
        }
    }];
}
-(void)requestYingShouZHangKuan:(NSInteger)khid{
    kWeakSelf(self);
    if ([self.tf13.text doubleValue] > 0) {
        NSDictionary * yfzkDic = @{@"khid":@(khid),@"je":@([self.tf13.text doubleValue])};
        NSMutableDictionary * yfzkmDic = [AD_SHARE_MANAGER requestSameParamtersDic:yfzkDic];
        [AD_MANAGER requestKeHuYingFuList:yfzkmDic success:^(id object) {
            [weakself popViewController];
        }];
    }else{
        [weakself popViewController];
    }
}
-(void)popViewController{
    [self showToast:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
//业务员
- (IBAction)btn8Action:(id)sender {
    NSMutableDictionary* mDic3 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pagesize":@"500",@"pon":@"",@"keywords":@""}];
    [AD_MANAGER requestSelectYgPage:mDic3 success:^(id object) {
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i <  AD_MANAGER.selectYgPageArray.count; i++) {
            JDSelectYgModel * ygModel = AD_MANAGER.selectYgPageArray[i];
            [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:ygModel.ygmc]];
        }
        view.array = [NSArray arrayWithArray:mArray];
        kWeakSelf(self);
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                _ywyid = model.sid;
                [weakself.btn8 setTitle:model.title forState:0];
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
    }];
}
//标签
- (IBAction)btn9Action:(id)sender {
    NSArray * array = @[@"大客户",@"小客户"];
    kWeakSelf(self);
    WTTableAlertView* alertview = [WTTableAlertView initWithTitle:nil options:array singleSelection:NO selectedItems:AD_MANAGER.markArray completionHandler:^(NSArray * _Nullable options) {
        [AD_MANAGER.markArray removeAllObjects];
        [AD_MANAGER.markArray addObjectsFromArray:options];
        
    
        NSString * title = @"";
        for (NSInteger i = 0 ; i < options.count; i++) {
            NSInteger index = [options[i] integerValue];
            title = [[array[index] append:@" "] append:title];
        }
        [weakself.btn9 setTitle:[title append:@""] forState:0];
        
    }];
    [alertview show];
}
//是否冻结
- (IBAction)btn12Action:(id)sender {
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"否"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"是"]];
    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            [weakself.btn12 setTitle:[model.title append:@""] forState:0];
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
//自动跳转下一个textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
- (IBAction)dingweiAction:(id)sender {
    [AD_SHARE_MANAGER dingweiAction:self.view tf:self.tf7 tv:self.tf8];
}
- (IBAction)addLxrAction:(id)sender {
    kWeakSelf(self);
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDAddNewGYSLxrViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddNewGYSLxrViewController"];
    VC.lxrBlock = ^(id object) {
        [weakself.lxrBtn setTitle:@"查看 >" forState:0];
        weakself.lxrTf.text = [NSString stringWithFormat:@"%ld位联系人",[object count]];
        weakself.object = object;
    };
    VC.khid = self.khid;
    VC.whereCome = self.whereCome;
    VC.dataSource = [NSMutableArray arrayWithArray:self.object];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
