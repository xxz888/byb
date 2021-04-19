//
//  JDDYDetailTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDDYDetailTableViewController.h"
#import "JDDYManagerDetailTableViewCell.h"
#import "JDCKModel.h"
#import "JDMDModel.h"
#import "JDQXModel.h"
#import "OpenUDID.h"
#import "SelectedListView.h"
#import "YBPopupMenu.h"
#import "JDMdCaoZuoViewController.h"
@interface JDDYDetailTableViewController ()<clickSelectBtn,YBPopupMenuDelegate>{
    NSArray * _tbsys_ygmdczqxs;
    NSArray * _tbsys_ygckczqxs;
    NSArray * _tbsys_ygjs;
    NSString * _secretcode;
    
    NSMutableArray * _allMdArray;

}
@property(nonatomic,strong)NSMutableDictionary * resultDic;
@end

@implementation JDDYDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工详情";
    _resultDic = [[NSMutableDictionary alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"JDDYManagerDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDDYManagerDetailTableViewCell"];
    _array1 = [[NSMutableArray alloc]init];
    _array2 = [[NSMutableArray alloc]init];
    _array3 = [[NSMutableArray alloc]init];

    _myArray1 = [[NSMutableArray alloc]init];
    _myArray2 = [[NSMutableArray alloc]init];
    _myArray3 = [[NSMutableArray alloc]init];
    _allMdArray = [[NSMutableArray alloc]init];
    
    
    _tbsys_ygmdczqxs  = [[NSMutableArray alloc]init];
    _tbsys_ygckczqxs  = [[NSMutableArray alloc]init];
    _tbsys_ygjs  = [[NSMutableArray alloc]init];

    _secretcode = @"";
    if ([self.phoneTf.text isEqualToString:@""]) {
        self.changePhone.hidden = YES;
    }else{
        self.changePhone.hidden = NO;
    }
    [self requestShowData];
    //门店的所有
    [self requestAllMd];
    
    
    //如果有值的话，是修改
    if (self.whereCome) {
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
        vc.key = self.ygid;
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
            NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@([self.resultDic[@"ygid"] integerValue])}];
            [AD_MANAGER requestDYDelAction:mDic success:^(id object) {
                [weakself showToast:@"店员删除成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        
    }
}
-(void)requestAllMd{
    NSMutableDictionary * qitaDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@(1),@"pagesize":@(1000)}];
    [AD_MANAGER requestAllMdAction:qitaDic success:^(id object) {
        [_allMdArray removeAllObjects];
        [_allMdArray addObjectsFromArray:object[@"data"][@"list"]];
    }];
}
-(void)requestShowData{
    kWeakSelf(self);
    NSMutableDictionary * qitaDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@(1),@"pagesize":@(1000)}];
    [AD_MANAGER requestAllMdAction:qitaDic success:^(id object) {
        [_array1 removeAllObjects];
        [_array1 addObjectsFromArray:object[@"data"][@"list"]];
        [AD_MANAGER requestCKListAction:qitaDic success:^(id object) {
            [_array2 removeAllObjects];
            [_array2 addObjectsFromArray:object[@"data"][@"list"]];
            [AD_MANAGER requestQXJSAction:qitaDic success:^(id object) {
                [_array3 removeAllObjects];
                [_array3 addObjectsFromArray:object[@"data"]];
                
                if (self.whereCome) {
                    [weakself requestDianYuanList];

                }else{
                    //开始造model
                    [weakself writeNewModel:@{}];
                }
            }];
            
        }];
        
    }];

}
-(void)requestDianYuanList{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(self.ygid),@"qx":@(1)}];
    [AD_MANAGER requestDYShowAction:mDic success:^(id object) {
        [_resultDic removeAllObjects];
        _resultDic = object[@"data"];
        _tbsys_ygmdczqxs = _resultDic[@"tbsys_ygmdczqxs"];
        _tbsys_ygckczqxs = _resultDic[@"tbsys_ygckczqxs"];
        _tbsys_ygjs= _resultDic[@"tbsys_ygjs"];

        weakself.nameTf.text = _resultDic[@"ygmc"];
        weakself.bhTf.text = _resultDic[@"ygbm"];
        weakself.mdLbl.text = _resultDic[@"ssmdmc"];
        weakself.phoneTf.text = _resultDic[@"sjhm"];
        
        weakself.djLbl.text = [_resultDic[@"sfdj"] integerValue] == 0 ? @"否" : @"是";
        weakself.bzTV.text = _resultDic[@"bz"];
        
        //开始造model
        [weakself writeNewModel:object];
        
    }];
}
-(void)writeNewModel:(id)object{
    //门店的model
    [_myArray1 removeAllObjects];
    for (NSDictionary * dic1 in _array1) {
        JDMDModel * mdModel = [[JDMDModel alloc]init];
        mdModel.mdid = [dic1[@"mdid"] integerValue];
        mdModel.mdmc = dic1[@"mdmc"];
        mdModel.ygid = [self.resultDic[@"ygid"] integerValue];
        mdModel.select = NO;
        for (NSDictionary * dic2 in object[@"data"][@"tbsys_ygmdczqxs"]) {
            if ([dic2[@"mdmc"] isEqualToString:dic1[@"mdmc"]]) {
                mdModel.select = YES;
                break;
            }
        }
        [_myArray1 addObject:mdModel];
    }

    
    //仓库的model
    [_myArray2 removeAllObjects];
    for (NSDictionary * dic1 in _array2) {
        JDCKModel * mdModel = [[JDCKModel alloc]init];
        mdModel.ckid = [dic1[@"ckid"] integerValue];
        mdModel.ckmc = dic1[@"ckmc"];
        mdModel.ygid = [self.resultDic[@"ygid"] integerValue];
        mdModel.select = NO;
        for (NSDictionary * dic2 in object[@"data"][@"tbsys_ygckczqxs"]) {
            if ([dic2[@"ckmc"] isEqualToString:dic1[@"ckmc"]]) {
                mdModel.select = YES;
                break;
            }
        }
        [_myArray2 addObject:mdModel];
    }
    
    //权限的model
    [_myArray3 removeAllObjects];
    for (NSDictionary * dic1 in _array3) {
        JDQXModel * mdModel = [[JDQXModel alloc]init];
        mdModel.jsmc = dic1[@"jsmc"];
        mdModel.jsid = [dic1[@"jsid"] integerValue];
        mdModel.ygid = [self.resultDic[@"ygid"] integerValue];
        mdModel.select = NO;
        for (NSDictionary * dic2 in object[@"data"][@"tbsys_ygjs"]) {
            if ([dic2[@"jsmc"] isEqualToString:dic1[@"jsmc"]]) {
                mdModel.select = YES;
                break;
            }
        }
        [_myArray3 addObject:mdModel];
    }
    
    [self.tableView reloadData];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
            if (indexPath.row == 4) {
                if ([self.phoneTf.text isEqualToString:@""] || !self.whereCome) {
                    return 50;
                }else{
                    return 0;
                }
            }
    }else if (indexPath.section == 1 ||indexPath.section == 2 ||indexPath.section == 3 ) {
        return 120;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}

//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){// （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }else   if(2 == indexPath.section){//（动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:2]];
    }else   if(3 == indexPath.section){//（动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:3]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        JDDYManagerDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDDYManagerDetailTableViewCell" forIndexPath:indexPath];
        cell.whereComeCell = @"1";
        cell.whereCome = self.whereCome;
        cell.HomeArray = [[NSMutableArray alloc]initWithArray:self.myArray1];
        [cell.addCountCollectionView reloadData];
        cell.clickSelectBtnDelegate = self;
        cell.title.text = @"门店";
        return cell;
    }else if (indexPath.section == 2){
        JDDYManagerDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDDYManagerDetailTableViewCell" forIndexPath:indexPath];
        cell.whereComeCell = @"2";
        cell.whereCome = self.whereCome;

        cell.HomeArray =  [[NSMutableArray alloc]initWithArray:self.myArray2];
        cell.clickSelectBtnDelegate = self;
        [cell.addCountCollectionView reloadData];
        cell.title.text = @"仓库";
        return cell;
    }else if (indexPath.section == 3){
        JDDYManagerDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDDYManagerDetailTableViewCell" forIndexPath:indexPath];
        cell.whereComeCell = @"3";
        cell.whereCome = self.whereCome;

        cell.HomeArray =  [[NSMutableArray alloc]initWithArray:self.myArray3];
        [cell.addCountCollectionView reloadData];
        cell.clickSelectBtnDelegate = self;
        cell.title.text = @"权限";
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}
//门店
-(void)clickSelectBtn1:(NSMutableArray *)array{
    NSMutableArray * ooArray = [[NSMutableArray alloc]init];
    for (JDMDModel * model in array) {
        if (model.select) {
            [ooArray addObject:@{@"mdid":@(model.mdid),@"ygid":@(model.ygid)}];
        }
    }
    
    _tbsys_ygmdczqxs =  [NSArray arrayWithArray:ooArray];
}
//仓库
-(void)clickSelectBtn2:(NSMutableArray *)array{
    NSMutableArray * ooArray = [[NSMutableArray alloc]init];
    for (JDCKModel * model in array) {
        if (model.select) {
            [ooArray addObject:@{@"ckid":@(model.ckid),@"ygid":@(model.ygid)}];
        }
    }
    _tbsys_ygckczqxs =[NSArray arrayWithArray:ooArray];
}
//权限
-(void)clickSelectBtn3:(NSMutableArray *)array{
    NSMutableArray * ooArray = [[NSMutableArray alloc]init];
    for (JDQXModel * model in array) {
        if (model.select) {
            [ooArray addObject:@{@"jsid":@(model.jsid),@"ygid":@(model.ygid)}];
        }
    }
    _tbsys_ygjs = [NSArray arrayWithArray:ooArray];
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

- (IBAction)mdAction:(id)sender {
    
    
    kWeakSelf(self);
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    NSMutableArray * arary = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < _allMdArray.count; i++) {
        [arary addObject:[[SelectedListModel alloc] initWithSid:i Title:_allMdArray[i][@"mdmc"]]];
    }
    view.array = [NSArray arrayWithArray:arary];
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            weakself.mdLbl.text = model.title;
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

//如果有手机号码的话，就是修改手机号码
- (IBAction)changePhoneAction:(id)sender {
    
    
}

//发送手机验证码
- (IBAction)sendPhoneCodeAction:(WLCaptcheButton *)btn{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"clientid":[OpenUDID value],@"mobile":self.phoneTf.text}];
    [AD_MANAGER requestDYSendPhoneCodeAction:mDic success:^(id object) {
        _secretcode = object[@"data"];
        [weakself showToast:@"验证码已发送到你的手机,请注意查收"];
        [btn fire];
    }];
}
- (IBAction)saveBtnAction:(id)sender {
    if (self.whereCome) {
        [self requestDataEdit];
    }else{
        [self requestDataSave];
    }
}
-(void)requestDataSave{
    
    kWeakSelf(self);
    NSInteger ssmdid = 0;
    for (NSDictionary * dic in _allMdArray) {
        if ([dic[@"mdmc"] isEqualToString:self.mdLbl.text] ) {
            ssmdid = [dic[@"mdid"] integerValue];
        }
    }
    NSDictionary * dic = @{@"ygmc":self.nameTf.text,
                           @"ygbm":self.bhTf.text,
                           @"ssmdid":@(ssmdid),
                           @"ygid":@(0),
                           @"tbsys_ygmdczqxs":_tbsys_ygmdczqxs,
                           @"tbsys_ygckczqxs":_tbsys_ygckczqxs,
                           @"tbsys_ygjs":_tbsys_ygjs,
                           @"sjhm":self.phoneTf.text,
                           @"sfdj":[self.djLbl.text isEqualToString:@"否"] ? @(0):@(1),//
                           @"bz":self.bzTV.text,//
                           @"ygid":@(0),
                           @"jdrid":@(0),
                           @"bgrid":@(0),
                           @"isselect":@(0)
                           };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"secretcode":_secretcode,@"data":string,@"qx":@(1),@"code":self.codePhoneTf.text}];
    [AD_MANAGER requestDYAddAction:mDic success:^(id object) {
        
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
            weakself.mdLbl.text = @"";
            
            
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        
    }];
}
//保存编辑
-(void)requestDataEdit{
    kWeakSelf(self);
    NSDictionary * dic = @{@"ygmc":self.nameTf.text,
                           @"ygbm":self.bhTf.text,
                           @"ssmdid":@([self.resultDic[@"ssmdid"] integerValue]),
                           @"ygid":@([self.resultDic[@"ygid"] integerValue]),
                           @"tbsys_ygmdczqxs":_tbsys_ygmdczqxs,
                           @"tbsys_ygckczqxs":_tbsys_ygckczqxs,
                           @"tbsys_ygjs":_tbsys_ygjs,
                           @"sjhm":self.phoneTf.text,
                           @"sfdj":[self.djLbl.text isEqualToString:@"否"] ? @(0):@(1),//
                           @"bz":self.bzTV.text//
                           };
    NSString * string = [ADTool dicConvertToNSString:dic];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"secretcode":_secretcode,@"data":string,@"qx":@(1),@"code":self.codePhoneTf.text}];
    [AD_MANAGER requestDYEditAction:mDic success:^(id object) {
        [weakself showToast:@"员工修改成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
@end
