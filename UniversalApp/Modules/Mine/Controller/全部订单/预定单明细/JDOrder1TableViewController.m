//
//  JDOrder1TableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDOrder1TableViewController.h"
#import "JDFooterView.h"
#import "JDOrder1TableViewCell.h"
#import "JDClientCheckingDetailViewController.h"
#import "JDOrder1FaHuoTableViewController.h"
#import "HLPopTableView.h"
#import "UIView+HLExtension.h"
#import "YBPopupMenu.h"
#import "JDAddColorModel.h"
#import "JDSalesAffirmViewController.h"
#import "JDSelectClientModel.h"
@interface JDOrder1TableViewController ()<YBPopupMenuDelegate>{
    NSMutableArray * _sectionArray;
    NSInteger _zjzt;//冻结为冻结
}
@property(nonatomic,strong)JDFooterView * footerView;
@property(nonatomic,strong)NSDictionary * resultDic;

@end

@implementation JDOrder1TableViewController
-(void)backBtnClicked{
    for (UIViewController * VC in [self.navigationController viewControllers]) {
//        if ([VC isKindOfClass:[JDSelectOddTagViewController class]]) {
//            [self.navigationController popToViewController:VC animated:YES];
//            return;
//        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@9009]];
    
    [self requestData];
}

-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":self.noteno}];
    [AD_MANAGER requestxsddShowNote:mDic success:^(id object) {
        
        weakself.resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
        weakself.label1.text = weakself.resultDic[@"khmc"];
        weakself.label2.text = weakself.resultDic[@"ckmc"];


        [weakself.btn7 setTitle:weakself.resultDic[@"djhm"] forState:0];
        [weakself.btn8 setTitle:weakself.resultDic[@"zdrq"] forState:0];
        [weakself.btn9 setTitle:weakself.resultDic[@"ywymc"] forState:0];
        [weakself.btn10 setTitle:weakself.resultDic[@"mdmc"] forState:0];

        
        
        double dingjinyizhifu = 0;
        for (NSDictionary * djDic in weakself.resultDic[@"tbnote_xsddcb_sks"]) {
            dingjinyizhifu += [djDic[@"skje"] doubleValue];
        }
        [weakself.btn4 setTitle:CCHANGE_DOUBLE(dingjinyizhifu) forState:0];

        
        double sumxsje = 0;
        for (NSDictionary * shDic in weakself.resultDic[@"tbnote_xsddcbs"]) {
            sumxsje = [shDic[@"xsje"] doubleValue] + sumxsje;
        }
        [weakself.btn5 setTitle:CCHANGE_DOUBLE(sumxsje) forState:0];
        
        
        [_sectionArray removeAllObjects];
        [_sectionArray addObjectsFromArray:weakself.resultDic[@"tbnote_xsddcbs"]];
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
        [weakself setBottom];
        
  
    }];
}
-(void)setBottom{
    
    //终结状态 0:未 1:已终结
    NSInteger zjzt = [self.resultDic[@"zjzt"] integerValue];
    UIButton * btn1 = [self.footerView viewWithTag:30002];
    if (zjzt == 0) { //已经终结过
        [btn1 setTitle:@"终结" forState:0];
    }else{
        [btn1 setTitle:@"取消终结" forState:0];
    }
    
    
    double sumxsje1 = 0;
    double xssl1 = 0;
    
    for (NSDictionary * shDic in self.resultDic[@"tbnote_xsddcbs"]) {
        sumxsje1 = [shDic[@"xsje"] doubleValue] + sumxsje1;
        xssl1  = xssl1 + [shDic[@"ddsl"] doubleValue];
    }
    
    if (xssl1 > 0) {
        self.footerView.lbl1.text = @"未完成 还剩";
        self.footerView.lbl2.text = [CCHANGE_OTHER_DOUBLE(xssl1) append:@"米"];
    }else{
        self.footerView.lbl1.text = @"已完成";
        self.footerView.lbl2.text = @"";
    }
}
-(void)setUI{
    _sectionArray = [[NSMutableArray alloc]init];
    ViewBorderRadius(self.btn3, 5, 0.5, JDRGBAColor(0, 163, 255));
    ViewBorderRadius(self.btn6, 5, 0.5, JDRGBAColor(0, 163, 255));
    [self.tableView registerNib:[UINib nibWithNibName:@"JDOrder1TableViewCell" bundle:nil] forCellReuseIdentifier:@"JDOrder1TableViewCell"];

}
#define TITLES @[@"回到草稿", @"打印",@"远程打印"]
-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:TITLES icons:nil menuWidth:120 delegate:self];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    kWeakSelf(self);
    if (index == 1) {
        AD_MANAGER.noteno = self.noteno;
        [AD_SHARE_MANAGER blueToothCommonActionNav:self.navigationController];
        
    }else if (index == 2){
        AD_MANAGER.noteno = self.noteno;

        [AD_SHARE_MANAGER longBlueToothCommonActionNav:self.navigationController];
    }else if (index == 0){
        //回到草稿
        NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"state":@(1),@"noteno":self.resultDic[@"djhm"]}];
        [AD_MANAGER requestFanShenDan:mDic1 success:^(id object) {
            [AD_SHARE_MANAGER commonYuDingDanTiaozhuan:weakself.resultDic nav:weakself.navigationController];
        }];
    }else if (index == 3){
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":self.noteno}];
        [AD_MANAGER requestShareWeiXin:mDic success:^(id object) {
            [AD_SHARE_MANAGER showShareView:object[@"data"]];
        } notetype:@"xsdd"];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"预定单详情";
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _sectionArray.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_dizhi"]];
        imageView.frame = CGRectMake(0, 0, kScreenWidth, 3);
        [view addSubview:imageView];
        //titile
        UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 40)];
        HeaderLabel.backgroundColor = JDRGBAColor(247, 249, 251);
        HeaderLabel.font = [UIFont boldSystemFontOfSize:13];
        HeaderLabel.textColor = JDRGBAColor(153, 153, 153);
        HeaderLabel.text = @"    订单商品";
        [view addSubview:HeaderLabel];

        

        
        return view;
    }
        return  [super tableView:tableView viewForHeaderInSection:section];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 if (section == 1) {
        return 50;
    }
    return 0;
}
#pragma mark ========== 尾视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        view.backgroundColor = KClearColor;
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"JDFooterView" owner:self options:nil];
        self.footerView = [nib objectAtIndex:0];
        self.footerView.frame = CGRectMake(0, 0, KScreenWidth, 50);
        [view addSubview:self.footerView];
        
        
        [self setBottom];

    
        
        
        UIButton * btn1 = [self.footerView viewWithTag:30002];
        UIButton * btn2 = [self.footerView viewWithTag:30001];
        

        kWeakSelf(self);
        self.footerView.bt1Block = ^(UIButton * btn1) {
            UIButton * fahuoBtn = [weakself.footerView viewWithTag:30001];

            if ([btn1.titleLabel.text isEqualToString:@"终结"]) {
         
                
                [weakself zhongjieAction:0 btn1:btn1 fahuoBtn:fahuoBtn];
            }else{
          
                [weakself zhongjieAction:1 btn1:btn1 fahuoBtn:fahuoBtn];
            }
          
        };
        
        
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        
        //发货按钮
        self.footerView.bt2Block = ^{
            
//            [weakself showToast:@"功能开发中!"];
//            return ;
            JDOrder1FaHuoTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDOrder1FaHuoTableViewController"];
            VC.hidesBottomBarWhenPushed = YES;
            VC.objectDic = [[NSMutableDictionary alloc]initWithDictionary:weakself.resultDic];
            VC.noteno = weakself.noteno;
            [weakself.navigationController pushViewController:VC animated:YES];
        };

        
        return view;
    }
    return [super tableView:tableView viewForFooterInSection:section];
 
}
-(void)zhongjieAction:(NSInteger)state btn1:(UIButton *)btn1 fahuoBtn:(UIButton *)fahuoBtn{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":self.noteno,@"state":@(state)}];
    [AD_MANAGER requestZjCheckNote:mDic success:^(id object) {
          
         if (state == 1){
            [btn1 setTitle:@"终结" forState:0];
            fahuoBtn.backgroundColor = JDRGBAColor(0, 163, 255);
            [fahuoBtn setTitleColor:KWhiteColor forState:0];
            fahuoBtn.userInteractionEnabled = YES;
         }else{
             [btn1 setTitle:@"取消终结" forState:0];
             fahuoBtn.backgroundColor = [UIColor lightTextColor];
             [fahuoBtn setTitleColor:KBlackColor forState:0];
             fahuoBtn.userInteractionEnabled = NO;
         }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 3 ? 50 : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 150;

    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        JDOrder1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDOrder1TableViewCell" forIndexPath:indexPath];
        NSDictionary * dic = _sectionArray[indexPath.row];
        cell.titileLbl.text = [NSString stringWithFormat:@"%@(%@)",dic[@"spmc"],dic[@"sphh"]];
        cell.lbl1.text = dic[@"ys"];
        cell.lbl2.text = CCHANGE(dic[@"xsdj"]);
        NSString * danwei = [dic[@"jjfs"] integerValue] == 1 ?dic[@"fjldw"]  : dic[@"jldw"];
        cell.lbl3.text = [NSString stringWithFormat:@"%ld匹  %@%@",[dic[@"xsps"] integerValue],CCHANGE_OTHER(dic[@"xssl"]),danwei];
        cell.lbl4.text = [NSString stringWithFormat:@"%ld匹  %@%@",[dic[@"ddps"] integerValue],CCHANGE_OTHER(dic[@"ddsl"]),danwei];
        
        return cell;
    }

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}



- (IBAction)btn3Action:(id)sender {
}
- (IBAction)btn6Action:(id)sender {
    if (!Quan_Xian(@"查看销售额权限")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"查看销售额权限",@"0")];
        return;
    }
    
    
    
    JDClientCheckingDetailViewController * VC = [[JDClientCheckingDetailViewController alloc]init];
    VC.paramtersDic = [NSMutableDictionary dictionaryWithDictionary:@{@"begindate":[NSString getThisWeekFirstDay],@"enddate":self.resultDic[@"rzrq"]}];
    [VC.paramtersDic setValue:self.resultDic[@"khid"] forKey:@"khid"];
    VC.clientLbl = self.resultDic[@"khmc"];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
