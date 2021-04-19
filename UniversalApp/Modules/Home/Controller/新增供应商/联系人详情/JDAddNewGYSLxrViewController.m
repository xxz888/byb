//
//  JDAddNewGYSLxrViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/7.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddNewGYSLxrViewController.h"
#import "JDAddNewGYSLxrTableViewCell.h"

@interface JDAddNewGYSLxrViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSMutableArray * _delTagArray;
}
@property(nonatomic,strong)UITableView * bottomTableView;

@end

@implementation JDAddNewGYSLxrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人详情";
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    _delTagArray = [[NSMutableArray alloc]init];

     [self requestDataLxrShow];


    [self.bottomTableView reloadData];
    [self addNavigationItemWithTitles:@[@"保存"] isLeft:NO target:self action:@selector(saveBtnAction:) tags:nil];
   
}

-(void)requestDataLxrShow{
    
    if (self.dataSource.count == 0) {
            [self getDataSource];
    }else{
    
            NSMutableArray * copyDataSouce = [NSMutableArray arrayWithArray:self.dataSource];
            for (NSInteger i = 0; i < copyDataSouce.count; i++) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:copyDataSouce[i]];
                [self.dataSource replaceObjectAtIndex:i withObject:dic];
                [self.dataSource[i] setValue:[@"联系人" append:NSIntegerToNSString(i+1)] forKey:@"AALXR"];
            }
            
            [self.bottomTableView reloadData];
    }

}
-(void)saveBtnAction:(UIButton *)btn{
    [self.view endEditing:YES];
    [self requestData];
}
//保存按钮请求方法
-(void)requestData{
    if (self.dataSource.count == 0) {
        [self showToast:@"请添加联系人!"];
        return;
    }
    
    self.lxrBlock(self.dataSource);
    [self.navigationController popViewControllerAnimated:YES];
    

}
#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDAddNewGYSLxrTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDAddNewGYSLxrTableViewCell"];
        _bottomTableView.separatorStyle = 0;
        [self.view addSubview:_bottomTableView];
    }
    return _bottomTableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"JDAddNewGYSLxrTableViewCell";
    JDAddNewGYSLxrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[JDAddNewGYSLxrTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        cell.selectionStyle = 0;
    }
    [cell.lxrTitleBtn setTitle:self.dataSource[indexPath.row][@"AALXR"] forState:0];
    cell.nameTf.text = self.dataSource[indexPath.row][@"lxrxm"];
    cell.lxrSjhTf.text = self.dataSource[indexPath.row][@"lxrsj"];
    cell.lxrPhoneTf.text = self.dataSource[indexPath.row][@"lxrdh"];
    cell.zwtf.text = self.dataSource[indexPath.row][@"lxrzw"];
    cell.lxrEmail.text = self.dataSource[indexPath.row][@"lxremail"];
    cell.lxrQQTf.text = self.dataSource[indexPath.row][@"lxrqq"];
    
    cell.nameTf.delegate = self;
    cell.zwtf.delegate = self;
    cell.lxrPhoneTf.delegate = self;
    cell.lxrSjhTf.delegate = self;
    cell.lxrEmail.delegate = self;
    cell.lxrQQTf.delegate = self;
    cell.tag = indexPath.row;
    
    kWeakSelf(self);
    cell.delcellBlock = ^(JDAddNewGYSLxrTableViewCell * cell) {
        NSIndexPath * indexPath = [weakself.bottomTableView indexPathForCell:cell];
//        [weakself.dataSource addObject:@(indexPath.row)];
        [weakself.dataSource removeObjectAtIndex:indexPath.row];
        [weakself.bottomTableView reloadData];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 350;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark ========== 尾视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 85)];
    view.backgroundColor = JDRGBAColor(247, 249, 251);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, KScreenWidth - 32, 45);
    btn.center = view.center;
    NSString * title = @"新增";
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
    [self getDataSource];
}
-(void)getDataSource{
    NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
    [mDic setValue:[@"联系人" append:NSIntegerToNSString(self.dataSource.count+1)] forKey:@"AALXR"];
    [self.dataSource addObject:mDic];
    [self.bottomTableView reloadData];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
        [self.view endEditing:YES];
    JDAddNewGYSLxrTableViewCell * cell = (JDAddNewGYSLxrTableViewCell *)textField.superview.superview.superview.superview;
    NSIndexPath * indexPath = [self.bottomTableView indexPathForCell:cell];
        [self.dataSource[indexPath.row] setValue:@(_gysid) forKey:@"gysid"];
        [self.dataSource[indexPath.row] setValue:@0 forKey:@"xh"];
        [self.dataSource[indexPath.row] setValue:cell.nameTf.text forKey:@"lxrxm"];
        [self.dataSource[indexPath.row] setValue:cell.lxrSjhTf.text forKey:@"lxrsj"];
        [self.dataSource[indexPath.row] setValue:cell.lxrPhoneTf.text forKey:@"lxrdh"];
        [self.dataSource[indexPath.row] setValue:cell.zwtf.text forKey:@"lxrzw"];
        [self.dataSource[indexPath.row] setValue:cell.lxrEmail.text forKey:@"lxremail"];
        [self.dataSource[indexPath.row] setValue:cell.lxrQQTf.text forKey:@"lxrqq"];
}
@end
