//
//  JDJiaGongZhuanChang4TableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDJiaGongZhuanChang4TableViewController.h"
#import "JDSalesAffirmRunTableViewCell.h"
#import "JDSelectCkPageModel.h"
#import "JDSelectShrModel.h"
#import "JDSelectYgModel.h"
#import "SelectedListView.h"
#import "JDSelectSpModel.h"
#import "JDSalesAffirmViewController.h"
#import "JDDingJinViewController.h"
#import "JDAddSpViewController.h"
#import "JDSalesActionViewController.h"
#import "JDJiaGongOrderViewController.h"
#define RunSection 2

@interface JDJiaGongZhuanChang4TableViewController ()<UITextViewDelegate,UITextFieldDelegate>
/** 动态cell的数据源 */
@property (nonatomic, strong) NSMutableArray *runArr;
@property (weak, nonatomic) IBOutlet UITableViewCell *runCell;
@property(nonatomic,copy)UITableView * runCellTableView;


@end

@implementation JDJiaGongZhuanChang4TableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.bzTV.delegate = self;
    self.tf2.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"JDSalesAffirmRunTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSalesAffirmRunTableViewCell"];
    //固定的布行名称
    LoginModel * model = AD_USERDATAARRAY;
    [self.btn6 setTitle:model.mdmc forState:0];
    [self textViewDidEndEditing:self.bzTV];
    
    self.bzTV.textColor = KGrayColor;
    
}
-(void)allUIControlGetValue{
    
    
    
    
    [self.btn1 setTitle: AD_MANAGER.affrimDic[@"gysmcOut"]  forState:0];
    [self.btn2 setTitle: AD_MANAGER.affrimDic[@"gysmcIn"] forState:0];
    
    self.bzTV.text = AD_MANAGER.affrimDic[@"djbz"] ;
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.selectOrderBtn setTitle:AD_MANAGER.affrimDic[@"ddhm"] forState:0];

    //试用
    [self allUIControlGetValue];
}
//点击编辑和挑选商品的通用方法
-(void)clickEditAndGoOnSpAction{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDAddSpViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddSpViewController"];
    if (AD_MANAGER.affrimDic[@"where"] && [AD_MANAGER.affrimDic[@"where"] isEqualToString:@"YES"]) {
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark ========== 编辑按钮的方法，如果是从草稿进来的，就push到选择商品的界面 ==========
-(void)editBtnClicked:(UIButton *)btn{
    [self clickEditAndGoOnSpAction];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 2) {
        NSInteger sumNum = [[AD_SHARE_MANAGER getSectionAndRowCount] count];
        return sumNum;//商品颜色的数组
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //第0组
    if (indexPath.section == 0) {
        if (CaiGouBOOL && indexPath.row == 1) {
            return 0;
        }
        //第一组
    }else if (indexPath.section == 1) {
        if ((ORDER_ISEQUAl(XiaoShouDan) || ORDER_ISEQUAl(YangPinDan) ||ORDER_ISEQUAl(TuiHuoDan))  && indexPath.row == 0) {
            return 0;
        }else if (CaiGouBOOL) {
            //如果是采购的单子，第1组
            return 0;
        }
        //第二组
    }else if (indexPath.section == 2) {
        if ( ORDER_ISEQUAl(YangPinDan) ||  ORDER_ISEQUAl(YuDingDan) || ORDER_ISEQUAl(JiaGongZhuanChang)) {
            return 100;
        }else{
            JDAddColorModel * model = [AD_SHARE_MANAGER getSectionAndRowCount][indexPath.row];
            if (model.isShowMore){
                NSInteger i = ([model.psArray count] + 3 - 1) / 3 ;
                return 40 * (i == 0 ? 1 : i) + 100;
            } else{
                return 100;
            }
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(2 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:2]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        
        JDSalesAffirmRunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDSalesAffirmRunTableViewCell"];
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"JDSalesAffirmRunTableViewCell" owner:nil options:nil].lastObject;
        }
        //动态cell的方法
        [cell setRunColorValue:nil colorModel:[AD_SHARE_MANAGER getSectionAndRowCount][indexPath.row]];
        
        cell.titleLbl.hidden =  cell.editBtn.hidden =
        ![[AD_SHARE_MANAGER getSectionTitleArray] containsObject:@(indexPath.row)];
        
        
        
        
        
        [cell.editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        kWeakSelf(self);
        cell.upDownBlock = ^(JDSalesAffirmRunTableViewCell *currentCell) {
            NSIndexPath *reloadIndexPath = [weakself.tableView indexPathForCell:currentCell];
            if (reloadIndexPath) {
                [weakself.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
}
#pragma mark ========== 点击添加货号的方法，如果是从草稿进来的，就push到选择商品的界面 ==========
- (IBAction)addSpBtnAction:(id)sender {
    [self clickEditAndGoOnSpAction];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        //titile
        UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, KScreenWidth, 40)];
        HeaderLabel.backgroundColor = JDRGBAColor(247, 249, 251);
        HeaderLabel.font = [UIFont boldSystemFontOfSize:15];
        HeaderLabel.textColor = JDRGBAColor(153, 153, 153);
        HeaderLabel.text = @"已选商品";
        [view addSubview:HeaderLabel];
        return view;
    }else if (section == 1){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        view.backgroundColor = JDRGBAColor(247, 249, 251);
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_dizhi"]];
        imageView.frame = CGRectMake(0, 0, kScreenWidth, 3);
        [view addSubview:imageView];
        return view;
    }
    return  [super tableView:tableView viewForHeaderInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 10;
    }else if (section == 2){
        return 40;
    }
    return 0;
}


//业务员
- (IBAction)btn5Action:(id)sender {
    
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    NSMutableArray * mArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0 ; i <  AD_MANAGER.selectYgPageArray.count; i++) {
        JDSelectYgModel * ygModel = AD_MANAGER.selectYgPageArray[i];
        [mArray addObject:[[SelectedListModel alloc] initWithSid:ygModel.ygid Title:ygModel.ygmc]];
    }
    
    view.array = [NSArray arrayWithArray:mArray];
    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            [weakself.btn5 setTitle:model.title forState:0];
            [AD_MANAGER.affrimDic setValue:model.title forKey:@"jsrmc"];
            [AD_MANAGER.affrimDic setValue:@(model.sid) forKey:@"jsrid"];

      
            
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

- (IBAction)selectOrderAction:(id)sender {
    JDJiaGongOrderViewController * vc = [[JDJiaGongOrderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ========== 选择送货日期 ==========
- (void)dateClick{
    kWeakSelf(self);
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    
    picker.frame = CGRectMake(0, 40, KScreenWidth, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    ipad_alertController;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        //预定发货日期
        [weakself.btn4 setTitle:[date stringWithFormat:@"yyyy-MM-dd"] forState:0];
        [AD_MANAGER.affrimDic setValue:weakself.btn4.titleLabel.text forKey:@"rzrq"];
        
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
//定金button
- (IBAction)dingjinBtnAction:(id)sender {
    kWeakSelf(self);
    JDDingJinViewController * VC = [[JDDingJinViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if(textView.text.length < 1){
        textView.text = @"填写你的备注(选填)";
        textView.textColor = KGrayColor;
    }
    [AD_MANAGER.affrimDic setValue:textView.text forKey:@"djbz"];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"填写你的备注(选填)"]){
        textView.text=@"";
        textView.textColor=KGrayColor;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [AD_MANAGER.affrimDic setValue:textField.text forKey:@"shdz"];
    [self.tf2 resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [AD_MANAGER.affrimDic setValue:textField.text forKey:@"shdz"];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [self.bzTV resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}


@end
