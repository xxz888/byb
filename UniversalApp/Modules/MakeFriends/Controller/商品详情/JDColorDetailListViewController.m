//
//  JDColorDetailListViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDColorDetailListViewController.h"
#import "JDColorDetailTableViewCell.h"
#import "JDAddColorModel.h"
#import "YBPopupMenu.h"
#import "JDAddColorTableViewController.h"
#import "JDLongBlueToothTableViewController.h"
#import "SelectedListView.h"
#import "JDColorKuCunDetailViewController.h"
@interface JDColorDetailListViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>{
    BOOL _selectBOOL; //判断是不是展示前边图片的
    BOOL _selectIndexBOOL;//判断点击的是不是明细
}
@property(nonatomic,strong)UITableView * colorTableView;
@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation JDColorDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self requestData];
}
-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"spid":@(self.spModel.spid)}];
    [AD_MANAGER requestAddColorPage:mDic success:^(id str) {
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:AD_MANAGER.addColorArray];
        [weakself firstStatus];
        [weakself.colorTableView reloadData];
    }];
}
//第一种情况
-(void)firstStatus{
    _selectBOOL = NO;
    _bottomHeight.constant = 0;
    [self.backBtn setTitle:@"返回" forState:0];
    [self.addBtn setTitle:@" " forState:0];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:0];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jiasehao"] forState:0];
}
//第二种情况
-(void)secondStatus{
    _selectBOOL = YES;
    [self.backBtn setTitle:@"取消" forState:0];
    [self.backBtn setImage:nil forState:0];
    [self.addBtn setTitle:@"全选" forState:0];
    [self.addBtn setImage:nil forState:0];
}
#pragma mark lazy loading...
-(UITableView *)colorTableView {
    if (!_colorTableView) {
        _colorTableView = [[UITableView alloc]initWithFrame:self.colorView.bounds style:UITableViewStylePlain];
        _colorTableView.delegate = self;
        _colorTableView.dataSource = self;
        [_colorTableView registerNib:[UINib nibWithNibName:@"JDColorDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDColorDetailTableViewCell"];
        [self.colorView addSubview:_colorTableView];
    }
    return _colorTableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _selectIndexBOOL ?  200 :  70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"JDColorDetailTableViewCell";
    JDColorDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[JDColorDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.selectionStyle = 0;
    cell.selectBOOL = _selectBOOL;
    JDAddColorModel * model = _dataSource[indexPath.row];
    cell.kucunLbl.tag = indexPath.row;
    if (!_selectIndexBOOL) {
        cell.stackView1.hidden = NO;
        cell.stackView2.hidden = YES;
        [cell setValueCell:model];
    }else{
        cell.stackView1.hidden = YES;
        cell.stackView2.hidden = NO;
        [cell setValueTagCell:model];

    }

    cell.kucunblock = ^(NSInteger index) {
        JDAddColorModel * colorModel = _dataSource[index];
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
              view.isSingle = YES;
              NSMutableArray * mArray = [[NSMutableArray alloc]init];
              for (NSInteger i = 0 ; i <  AD_MANAGER.selectCkPageArray.count; i++) {
                  JDSelectCkPageModel * ckModel = AD_MANAGER.selectCkPageArray[i];
                  [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:ckModel.ckmc]];
              }
              
              view.array = [NSArray arrayWithArray:mArray];
              kWeakSelf(self);
              view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                  [LEEAlert closeWithCompletionBlock:^{
                      SelectedListModel * model = array[0];
                      //仓库
                      NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
                      [dic setValue:model.title forKey:@"ckmc"];
                      [dic setValue:weakself.spModel.sphh forKey:@"spvalue"];
                      [dic setValue:colorModel.ys forKey:@"ys"];
                      
                      [dic setValue:@"" forKey:@"spflmc"];
                      [dic setValue:@"" forKey:@"cdmc"];
                      [dic setValue:@"" forKey:@"sfm"];
                      [dic setValue:@"1" forKey:@"mobile"];
                      JDColorKuCunDetailViewController * vc = [[JDColorKuCunDetailViewController alloc]init];
                      vc.dic = [NSMutableDictionary dictionaryWithDictionary:dic];
                      [weakself.navigationController pushViewController:vc animated:YES];
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

    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.backBtn.titleLabel.text isEqualToString:@"返回"]) {
   
        JDAddColorModel * model = _dataSource[indexPath.row];
        UIStoryboard * stroryBoard2 = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
        JDAddColorTableViewController * VC = [stroryBoard2 instantiateViewControllerWithIdentifier:@"JDAddColorTableViewController"];
        VC.spModel = self.spModel;
        VC.whereCome = YES;
        VC.sh = model.sh;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        ((JDAddColorModel *)_dataSource[indexPath.row]).isShowMore = ! ((JDAddColorModel *)_dataSource[indexPath.row]).isShowMore;
        [self.colorTableView reloadData];
    }

}

#define TITLES1 @[@"新建颜色",@"切换为详细信息",@"批量修改价格",@"批量设置最低库存",@"打印色卡(远程打印)"]
#define TITLES2 @[@"新建颜色",@"切换为列表信息",@"批量修改价格",@"批量设置最低库存",@"打印色卡(远程打印)"]

-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:_selectIndexBOOL ? TITLES2 :TITLES1  icons:nil menuWidth:190 delegate:self];
}
#pragma mark - 右上角更多的小弹框
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (index == 0) {
        UIStoryboard * stroryBoard2 = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
        JDAddColorTableViewController * VC = [stroryBoard2 instantiateViewControllerWithIdentifier:@"JDAddColorTableViewController"];
        VC.spModel = self.spModel;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else if (index == 1){
        _selectIndexBOOL = !_selectIndexBOOL;
        [_colorTableView reloadData];
        _headerHeight.constant = _selectIndexBOOL ? 0 : 50;
    }
else if (index == 2){
        [self secondStatus];
        _bottomHeight.constant = 50;
        [self.setBottomBtn setTitle:@"设置价格信息" forState:0];
        [_colorTableView reloadData];
    }else if (index == 3){
        [self secondStatus];

        [self.setBottomBtn setTitle:@"设置库存信息" forState:0];
        _bottomHeight.constant = 50;
        [_colorTableView reloadData];
    }else if (index == 4){
        [self secondStatus];
        [self.setBottomBtn setTitle:@"远程打印色卡信息" forState:0];
        _bottomHeight.constant = 50;
        [_colorTableView reloadData];
    }
}
- (IBAction)backVCAction:(UIButton *)btn  {
    if ([btn.titleLabel.text isEqualToString:@"返回"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([btn.titleLabel.text isEqualToString:@"取消"]){
        [self firstStatus];
        [_dataSource removeAllObjects];
        //取消的话，清空所有的选择
        [_dataSource addObjectsFromArray:AD_MANAGER.addColorArray];
        _bottomHeight.constant = 0;
        [_colorTableView reloadData];
    }
}
- (void)layoutSubviews{
    [_colorTableView setBounds:self.colorView.bounds];
}
- (IBAction)addNewColorAction:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@" "]) {
            [self moreAction:btn];
    }else if ([btn.titleLabel.text isEqualToString:@"全选"]){
        for (NSInteger i = 0; i < self.dataSource.count; i++) {
            ((JDAddColorModel *)_dataSource[i]).isShowMore = YES;
        }
        [_colorTableView reloadData];
    }

}
-(NSMutableArray *)getSelectArray{
    NSMutableArray * shsArray = [[NSMutableArray alloc]init];
    for (JDAddColorModel * model in _dataSource) {
        if (model.isShowMore) {
            [shsArray addObject:model.sh];
        }
    }
    return shsArray;
}
-(void)changePriceAndKucun{
    
}
- (IBAction)setBottomAction:(id)sender {
    
    if ([self.setBottomBtn.titleLabel.text isEqualToString:@"设置库存信息"]) {
        [self setKuCunInfon];
    }else if ([self.setBottomBtn.titleLabel.text isEqualToString:@"设置价格信息"]){
        [self setPriceInfo];
    }else if ([self.setBottomBtn.titleLabel.text isEqualToString:@"远程打印色卡信息"]){
        [self setYuanChengPrintInfo];
    }
}
-(void)setYuanChengPrintInfo{
    AD_MANAGER.orderType = SPDA;
    
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"OtherVC" bundle:nil];
    JDLongBlueToothTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDLongBlueToothTableViewController"];
    VC.spid = self.spModel.spid;
    VC.shArray = [[NSMutableArray alloc]initWithArray:[self getSelectArray]];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];

}
-(void)setPriceInfo{
    // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
    __block UITextField *tf1 = nil;
    __block UITextField *tf2 = nil;
    __block UITextField *tf3 = nil;
    
    [LEEAlert alert].config
    .LeeTitle(@"设置价格")
    .LeeContent(nil)
    .LeeAddTextField(^(UITextField *textField) {
        textField.placeholder = @"请输入建议售价";
        textField.textColor = [UIColor darkGrayColor];
        tf1 = textField; //赋值
    })
    .LeeAddTextField(^(UITextField *textField) {
        textField.placeholder = @"请输入最低售价";
        textField.textColor = [UIColor darkGrayColor];
        tf2 = textField; //赋值
    })
    .LeeAddTextField(^(UITextField *textField) {
        textField.placeholder = @"请输入成本价";
        textField.textColor = [UIColor darkGrayColor];
        tf3 = textField; //赋值
    })
    .LeeAction(@"确定", ^{
        [tf1 resignFirstResponder];
        [tf2 resignFirstResponder];
        [tf3 resignFirstResponder];
        kWeakSelf(self);
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"spid":@(self.spModel.spid),
                                                                                 @"cbdj":@([tf3.text doubleValue]),
                                                                                 @"zdsj":@([tf2.text doubleValue]),
                                                                                 @"bzsj":@([tf1.text doubleValue]),
                                                                                 @"zdkc":@"",
                                                                                 @"shs":[self getSelectArray]
                                                                                 }];
        [AD_MANAGER requestAllChangePriceAction:mDic success:^(id str) {
            [weakself requestData];
        }];
        
    })
    .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
    .LeeShow();
}
-(void)setKuCunInfon{
    __block UITextField *tf1 = nil;
    [LEEAlert alert].config
    .LeeTitle(@"设置库存")
    .LeeContent(nil)
    .LeeAddTextField(^(UITextField *textField) {
        textField.placeholder = @"请输入最低库存数量";
        textField.textColor = [UIColor darkGrayColor];
        tf1 = textField; //赋值
    })
    .LeeAction(@"确定", ^{
        [tf1 resignFirstResponder];
        
        kWeakSelf(self);
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"spid":@(self.spModel.spid),
                                                                                 @"cbdj":@"",
                                                                                 @"zdsj":@"",
                                                                                 @"bzsj":@"",
                                                                                 @"zdkc":@([tf1.text doubleValue]),
                                                                                 @"shs":[self getSelectArray]
                                                                                 }];
        [AD_MANAGER requestAllChangePriceAction:mDic success:^(id str) {
            [weakself requestData];
        }];
        
    })
    .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
    .LeeShow();
}
@end
