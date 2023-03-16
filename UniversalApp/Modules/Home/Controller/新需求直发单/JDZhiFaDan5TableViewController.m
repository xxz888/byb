//
//  JDZhiFaDan5TableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/22.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDZhiFaDan5TableViewController.h"
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
#import "JDSelectClientModel.h"
#import "JDZhiFaDan5TableViewCell.h"
#import "JDZhiFaDan4ViewController.h"
@interface JDZhiFaDan5TableViewController ()<UITextViewDelegate,UITextFieldDelegate>
/** 动态cell的数据源 */
@property (nonatomic, strong) NSMutableArray *runArr;
@property (weak, nonatomic) IBOutlet UITableViewCell *runCell;
@property(nonatomic,copy)UITableView * runCellTableView;

@end

@implementation JDZhiFaDan5TableViewController
-(NSInteger)getColorArrayCount{
    double colorArrayAllCount = 0.00;
    for (NSInteger i = 0 ; i < [NEW_AffrimDic_SectionArray count]; i++) {
        NSString * key = [NEW_AffrimDic_SectionArray[i] allKeys][0];
        NSArray * countArr = NEW_AffrimDic_SectionArray[i][key][@"color"];
        for (NSInteger k = 0; k < countArr.count; k++) {
            colorArrayAllCount += 1;
        }
    }
    return colorArrayAllCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.bzTV.delegate = self;
    self.tf2.delegate = self;
    [self.smallTableView registerNib:[UINib nibWithNibName:@"JDZhiFaDan5TableViewCell" bundle:nil] forCellReuseIdentifier:@"JDZhiFaDan5TableViewCell"];
    //固定的布行名称
    LoginModel * model = AD_USERDATAARRAY;
    [self.btn6 setTitle:model.mdmc forState:0];
    [self textViewDidEndEditing:self.bzTV];
    
    self.bzTV.textColor = KGrayColor;
    
    

    self.smallTableViewHeight.constant = 20 + [self getColorArrayCount] * 90 + [NEW_AffrimDic_SectionArray count] * 40;
    self.smallTableView.userInteractionEnabled = NO;
}
-(void)allUIControlGetValue{
    JDSelectClientModel * kehuModel = NEW_AffrimDic[@"kehu"];
    JDSelectClientModel * gysModel = NEW_AffrimDic[@"gongyingshang"];
    

    [self.btn0 setTitle:gysModel.gysmc forState:0];

    [self.btn1 setTitle:kehuModel.khmc forState:0];
    
    
    if (!gysModel.gysmc) {
        [self.btn0 setTitle:NEW_AffrimDic[@"gysmc"] forState:0];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //试用
    [self allUIControlGetValue];
}
//点击编辑和挑选商品的通用方法
-(void)clickEditAndGoOnSpAction{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"XinXuQiu" bundle:nil];
    JDZhiFaDan4ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDZhiFaDan4ViewController"];
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


#pragma mark ========== 点击添加货号的方法，如果是从草稿进来的，就push到选择商品的界面 ==========
- (IBAction)addSpBtnAction:(id)sender {
    [self clickEditAndGoOnSpAction];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 888) {
        NSString *title = @"";
        for (JDSelectSpModel * spModle in AD_MANAGER.selectSpPageArray) {
            if ([[NEW_AffrimDic_SectionArray[section] allKeys][0] intValue] == spModle.spid) {
                title = spModle.spmc;
            }
        }
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 40)];
        view.backgroundColor = KWhiteColor;
        UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, KScreenWidth, 40)];
        HeaderLabel.font = [UIFont boldSystemFontOfSize:16];
        HeaderLabel.textColor = JDRGBAColor(25, 25, 25);
        HeaderLabel.text = title;
        [view addSubview:HeaderLabel];
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = JDRGBAColor(235, 235, 235);
        imageView.frame = CGRectMake(0, 39, KScreenWidth,0.5);
        [view addSubview:imageView];
        return view;
    }else  if (section == 1){
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
    if (tableView.tag == 888) {
        return 40;
    }else if(section == 1){
        return 10;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 888) {
        return [NEW_AffrimDic_SectionArray count];

    }
    return  [super numberOfSectionsInTableView:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 888) {
        NSString * spid = [NEW_AffrimDic_SectionArray[section] allKeys][0];
        NSInteger  count = [NEW_AffrimDic_SectionArray[section][spid][@"color"] count];
        return count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 888) {
        return 100;
    }else{
        if (indexPath.section == 2) {
            return 75 + [self getColorArrayCount] * 90  + [NEW_AffrimDic_SectionArray count] * 40 ;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 888) {
        JDZhiFaDan5TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDZhiFaDan5TableViewCell"];
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"JDZhiFaDan5TableViewCell" owner:nil options:nil].lastObject;
        }
        NSString * spid = [NEW_AffrimDic_SectionArray[indexPath.section] allKeys][0];
        JDSelectSpModel * spModel = NEW_AffrimDic_SectionArray[indexPath.section][spid][@"sp"];
        JDAddColorModel * colorModel = NEW_AffrimDic_SectionArray[indexPath.section][spid][@"color"][indexPath.row][@"model"];
        //颜色头像
        NSURL *url = [NSURL URLWithString:colorModel.imgurl];
        UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        cell.colorImg.image = imagea;
        //颜色名字
        cell.colorLbl.text = colorModel.ys;
        //库存
        cell.stockLbl.text = [[@"库存: " append:kGet2fDouble(colorModel.kczsl)] append:spModel.jldw];
        //进价
        cell.jinjiaLbl.text = [@"进价: " append:kGet2fDouble(colorModel.cbdj)];
        //
        cell.lbl1.text = [NSString stringWithFormat:@"%ld",[colorModel.psArray count]];
        //
        NSMutableArray * colorArray = [[NSMutableArray alloc]initWithArray:NEW_AffrimDic_SectionArray[indexPath.section][spid][@"color"][indexPath.row][@"colArray"]];
        double jisuanCount = 0.0;
        for (NSString * str  in colorArray) {
            jisuanCount += [str doubleValue];
        }
        cell.lbl2.text = [kGet2fDouble(jisuanCount) append:spModel.jldw];
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
}
//客户
- (IBAction)btn1Action:(id)sender {
    kWeakSelf(self);
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDSalesActionViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesActionViewController"];
    VC.OpenType = @"SPVC";
    [self presentViewController:VC animated:YES completion:nil];
}
//选择地址
- (IBAction)btn2Action:(id)sender {
    kWeakSelf(self);
    JDSelectClientModel * clientModel = [AD_SHARE_MANAGER inKeHuNameOutKeHuId:AD_MANAGER.affrimDic[@"khmc"]];
    NSMutableDictionary* mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@(clientModel.Khid)}];
    [AD_MANAGER requestAddressList:mDic1 success:^(id object) {
        
        if ([object[@"data"] count] == 0) {
            [weakself showToast:@"没有可用地址,请手动输入"];
        }else{
            SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
            view.isSingle = YES;
            NSMutableArray * mArray = [[NSMutableArray alloc]init];
            for (NSInteger i = 0 ; i <  [object[@"data"] count]; i++) {
                [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:object[@"data"][i][@"shdz"]]];
            }
            view.array = [NSArray arrayWithArray:mArray];
            view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                [LEEAlert closeWithCompletionBlock:^{
                    SelectedListModel * model = array[0];
                    weakself.tf2.text = model.title;
                    aa.shdz = model.title;
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
        
    }];
}
//仓库
- (IBAction)btn3Action:(id)sender {
    
    
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    NSMutableArray * mArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0 ; i <  AD_MANAGER.selectCkPageArray.count; i++) {
        JDSelectCkPageModel * ckModel = AD_MANAGER.selectCkPageArray[i];
        [mArray addObject:[[SelectedListModel alloc] initWithSid:ckModel.ckid Title:ckModel.ckmc]];
    }
    
    view.array = [NSArray arrayWithArray:mArray];
    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            //仓库
            [weakself.btn3 setTitle:model.title forState:0];
            aa.ckid = NSIntegerToNSString(model.sid);
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
//送货员
- (IBAction)btn4Action:(id)sender {
    if (ORDER_ISEQUAl(YuDingDan)) {
        [self dateClick];
    }else if(CaiGouBOOL){
        [self btn5Action:nil];
    } else{
        
        SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
        view.isSingle = YES;
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i <  AD_MANAGER.selectShrPageArray.count; i++) {
            JDSelectShrModel * shrModel = AD_MANAGER.selectShrPageArray[i];
            [mArray addObject:[[SelectedListModel alloc] initWithSid:i Title:shrModel.shrmc]];
        }
        
        view.array = [NSArray arrayWithArray:mArray];
        kWeakSelf(self);
        view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
            [LEEAlert closeWithCompletionBlock:^{
                SelectedListModel * model = array[0];
                //仓库
                [weakself.btn4 setTitle:model.title forState:0];
                aa.shr = model.title;
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
    
}
//业务员
- (IBAction)btn5Action:(id)sender {
    
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
            [weakself.btn5 setTitle:model.title forState:0];
            aa.ywyid = NSIntegerToNSString(model.sid);
            
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
    aa.djbz = textView.text;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"填写你的备注(选填)"]){
        textView.text=@"";
        textView.textColor=KGrayColor;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    aa.shdz = textField.text;
    [self.tf2 resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    aa.shdz = textField.text;
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
