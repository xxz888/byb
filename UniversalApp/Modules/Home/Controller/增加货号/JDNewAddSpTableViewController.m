//
//  JDNewAddSpTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/10.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDNewAddSpTableViewController.h"
#import "SelectedListView.h"
#import "WTTableAlertView.h"
#import "YBPopupMenu.h"
#import "JDMdCaoZuoViewController.h"
@interface JDNewAddSpTableViewController ()<UITextFieldDelegate,YBPopupMenuDelegate,UITextViewDelegate>

@end

@implementation JDNewAddSpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LoginModel * model = AD_USERDATAARRAY;
    _tf1.delegate = self;
    _tf2.delegate = self;
    _tf3.delegate = self;
    _tf4.delegate = self;
    _tf5.delegate = self;
    _tf6.delegate = self;
    _tf7.delegate = self;
    _tf8.delegate = self;
    _chengfenTV.delegate = self;
    _tf10.delegate = self;
    _beizhuTV.delegate = self;

    
    if (self.resultDic) {
        self.title = @"修改商品";
        self.tf1.text = _resultDic[@"spmc"];
        self.tf2.text = _resultDic[@"sphh"];
        self.tf3.text = _resultDic[@"jldw"];
        self.tf4.text = _resultDic[@"fjldw"];
        self.tf5.text = _resultDic[@"gyshh"];
        self.tf6.text = _resultDic[@"gysbz"];
        self.tf7.text = CCHANGE_OTHER(_resultDic[@"fk"]);
        self.tf8.text =   CCHANGE_OTHER(_resultDic[@"kz"]);
        self.chengfenTV.text = _resultDic[@"cf"];
        self.tf10.text = CCHANGE_OTHER(_resultDic[@"mgjm"]);
        self.tf11.text = [_resultDic[@"sfdj"] integerValue] == 0 ? @"否" :@"是";
        self.beizhuTV.text = _resultDic[@"bz"];
        
        [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@9001]];
    }else{
        self.title = @"添加商品";
    }
    
    if (_chengfenTV.text.length == 0 || _beizhuTV.text.length == 0 ) {
        self.chengfenTV.text = @"请输入成分";
        self.beizhuTV.text  = @"请输入备注";
    }
    if ([_chengfenTV.text isEqualToString:@"请输入成分"]) {
        _chengfenTV.textColor = KGrayColor;
    }
    if ([_beizhuTV.text isEqualToString:@"请输入备注"]){
        _beizhuTV.textColor = KGrayColor;
    }
}
#define TITLES @[@"操作记录",@"删除"]
-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:TITLES icons:nil menuWidth:120 delegate:self];
}
#pragma mark - 右上角更多的小弹框
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    kWeakSelf(self);
    if (index == 0) {
        JDMdCaoZuoViewController * vc = [[JDMdCaoZuoViewController alloc]init];
        vc.key =  [self.resultDic[@"spid"] integerValue];
        vc.type = 7;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@([self.resultDic[@"spid"] integerValue])}];
        [AD_MANAGER requestSHRDelAction:mDic success:^(id object) {
            [weakself showToast:@"删除成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
    if ([self.title isEqualToString:@"添加商品"]) {
        title = @"新增";
    }else{
        title = @"保存";
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
    
    if ([self.title isEqualToString:@"添加商品"]) {
        [self addSpAction];
    }else{
        [self editAction];
    }
    
}

-(void)editAction{
    
    /*
     bgrbm = 0000;
     bgrmc = boss;
     bgrq = "2018-07-24 17:42:25";
     gysbm = "";
     gysid = 0;
     gysmc = "";
     gysqx = 1;
     jdrbm = 0000;
     jdrmc = boss;
     jdrq = "2018-07-24 17:42:25";
     skwz = "";
     spbm = 000002;
     spjc = "";
     tp = "<null>";
     url = "";
     zjf = yhr;
     */
    NSDictionary * dic = @{@"spmc":_tf1.text,
                           @"sphh":_tf2.text,
                           @"jldw":_tf3.text,
                           @"fjldw":_tf4.text,
                           @"gyshh":_tf5.text,
                           @"gysbz":_tf6.text,
                           @"fk":_tf7.text,
                           @"kz":_tf8.text,
                           @"cf":_chengfenTV.text,
                           @"mgjm":_tf10.text,
                           @"sfdj":[self.tf11.text isEqualToString:@"是"] ? @(1) :@(0),
                           @"bz":_beizhuTV.text,
                           @"shangPinColorVOList":@[],
                           @"fslbl":@([_resultDic[@"fslbl"] integerValue]),
                           @"spid":@([_resultDic[@"spid"] integerValue]),
                           @"jdrid":@([_resultDic[@"jdrid"] integerValue]),
                           @"gysid":@([_resultDic[@"gysid"] integerValue]),
                           @"spps":_resultDic[@"spps"],
                           @"spflid":@([_resultDic[@"spflid"] integerValue]),
                           @"yscount":@([_resultDic[@"yscount"] integerValue]),
                           @"bgrid":@([_resultDic[@"bgrid"] integerValue]),
                           @"spsl":@([_resultDic[@"spsl"] integerValue]),
                           @"bgrbm":_resultDic[@"bgrbm"],
                           @"bgrmc":_resultDic[@"bgrmc"],
                           @"bgrq":_resultDic[@"bgrq"],
                           @"gysbm":_resultDic[@"gysbm"],
                            @"bgrq":_resultDic[@"bgrq"],
                            @"gysid":_resultDic[@"gysid"],
                           @"gysmc":_resultDic[@"gysmc"],
                           @"gysqx":_resultDic[@"gysqx"],
                           @"jdrbm":_resultDic[@"jdrbm"],
                           @"jdrq":_resultDic[@"jdrq"],
                           @"skwz":_resultDic[@"skwz"],
                           @"spbm":_resultDic[@"spbm"],
                           @"spjc":_resultDic[@"spjc"],
                           @"tp":_resultDic[@"tp"],
                           @"url":_resultDic[@"url"],
                           @"zjf":_resultDic[@"zjf"],
                           };
    kWeakSelf(self);
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    [AD_MANAGER requestEditSp:mDic success:^(id object) {
        [weakself showToast:@"修改成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];

    
    
}

-(void)addSpAction{
    NSDictionary * dic = @{@"spmc":_tf1.text,
                           @"sphh":_tf2.text,
                           @"jldw":_tf3.text,
                           @"fjldw":_tf4.text,
                           @"gyshh":_tf5.text,
                           @"gysbz":_tf6.text,
                           @"fk":_tf7.text,
                           @"kz":_tf8.text,
                           @"cf":_chengfenTV.text,
                           @"mgjm":_tf10.text,
                           @"sfdj":[self.tf11.text isEqualToString:@"是"] ? @(1) :@(0),
                           @"bz":_beizhuTV.text,
                           @"shangPinColorVOList":@[],
                           @"fslbl":@0,
                           @"sfdj":@0,
                           @"spid":@0,
                           @"jdrid":@0,
                           @"gysid":@0,
                           @"spps":@0,
                           @"spflid":@0,
                           @"yscount":@0,
                           @"bgrid":@0,
                           @"spsl":@0,
                           };
    kWeakSelf(self);
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string}];
    [AD_MANAGER requestAddNewSp:mDic success:^(id object) {
        [LEEAlert alert].config
        .LeeTitle(@"添加成功!")
        .LeeContent(@"")
        .LeeCancelAction(@"返回列表", ^{
            
        })
        .LeeAction(@"继续添加", ^{
            _tf1.text = @"";
            _tf2.text = @"";
            _tf3.text = @"";
            _tf4.text = @"";
            _tf5.text = @"";
            _tf6.text = @"";
            _tf7.text = @"";
            _tf8.text = @"";
            _chengfenTV.text = @"";
            _tf10.text = @"";
            _tf11.text = @"否";
            _beizhuTV.text = @"";
            [_tf1 becomeFirstResponder];
        })
        .LeeShow();
        
    }];
    
}
- (IBAction)btn3Action:(UIButton *)btn {
    [self selectDanWei:btn.tag];
}
- (IBAction)btn4Action:(UIButton *)btn {
    [self selectDanWei:btn.tag];
}
-(void)selectDanWei:(NSInteger)tag{
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"米"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"码"],
                   [[SelectedListModel alloc] initWithSid:2 Title:@"千克"],
                   [[SelectedListModel alloc] initWithSid:3 Title:@"克"],
                   [[SelectedListModel alloc] initWithSid:4 Title:@"公斤"],
                   [[SelectedListModel alloc] initWithSid:5 Title:@"斤"],
                   [[SelectedListModel alloc] initWithSid:6 Title:@"个"],
                   [[SelectedListModel alloc] initWithSid:7 Title:@"kg"],
                   [[SelectedListModel alloc] initWithSid:8 Title:@"g"]];

    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            if (tag == 10001) {
                weakself.tf3.text = model.title;

            }else{
                weakself.tf4.text = model.title;

            }
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
- (IBAction)btn11Action:(id)sender{
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"否"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"是"]];
    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            weakself.tf11.text = model.title;
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _tf1) {
        [_tf1 resignFirstResponder];
        [_tf2 becomeFirstResponder];
    }else if (textField == _tf2){
        [_tf2 resignFirstResponder];
        [_tf3 becomeFirstResponder];
    }else if (textField == _tf3){
        [_tf3 resignFirstResponder];
        [_tf4 becomeFirstResponder];
    }else if (textField == _tf4){
        [_tf4 resignFirstResponder];
        [_tf5 becomeFirstResponder];
    }else if (textField == _tf5){
        [_tf5 resignFirstResponder];
        [_tf6 becomeFirstResponder];
    }else if (textField == _tf6){
        [_tf6 resignFirstResponder];
        [_tf7 becomeFirstResponder];
    }else if (textField == _tf7){
        [_tf7 resignFirstResponder];
        [_tf8 becomeFirstResponder];
    }else if (textField == _tf8){
        [_tf8 resignFirstResponder];
        [_chengfenTV becomeFirstResponder];
    }
   /*
    else if (textField == _chengfenTV){
        [_chengfenTV resignFirstResponder];
        [_tf10 becomeFirstResponder];
    }else if (textField == _tf10){
        [_tf10 resignFirstResponder];
        [_btn12 becomeFirstResponder];
    }else if (textField == _btn12){
        [_btn12 resignFirstResponder];
    }
    */
    return YES;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length < 1){
        textView.text = textView.tag == 40001 ? @"请输入成分" : @"请输入备注";
        textView.textColor = [UIColor grayColor];
        
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@"请输入备注"] || [textView.text isEqualToString:@"请输入成分"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if (textView == self.chengfenTV) {
            [self.chengfenTV resignFirstResponder];
            [self.chengfenTV becomeFirstResponder];
            [_tf10 becomeFirstResponder];
        }else if (textView == self.beizhuTV){
            [self.beizhuTV resignFirstResponder];
        }
    }
    return YES;
}
@end
