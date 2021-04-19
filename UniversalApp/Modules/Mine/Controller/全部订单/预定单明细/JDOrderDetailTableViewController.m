//
//  JDOrderDetailTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDOrderDetailTableViewController.h"
#import "JDFooterView.h"
#import "JDSalesAffirmRunTableViewCell.h"

@interface JDOrderDetailTableViewController ()
@property(nonatomic,strong)NSDictionary * objectDic;
@property(nonatomic,strong)JDFooterView * footerView;

@property (nonatomic,strong) NSMutableArray * cellDataArray;

@end

@implementation JDOrderDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"出库单详情";
    [self.tableView registerNib:[UINib nibWithNibName:@"JDSalesAffirmRunTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSalesAffirmRunTableViewCell"];
    _cellDataArray = [[NSMutableArray alloc]init];
    [self requestData];
}
-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":self.ckData}];
    [AD_MANAGER requestChuKuDanDetail:mDic success:^(id object) {
        weakself.objectDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];

        weakself.lbl1.text = weakself.objectDic[@"khmc"];
        weakself.lbl2.text =weakself.objectDic[@"ckmc"];
        [weakself.btn3 setTitle:weakself.objectDic[@"shrmc"]  forState:0];
        weakself.connectLbl.text = weakself.objectDic[@"djhm"];
        [weakself.btn7 setTitle:weakself.objectDic[@"shrmc"]  forState:0];
        [weakself.btn8 setTitle:weakself.objectDic[@"rzrq"] forState:0];
        [weakself.btn9 setTitle:weakself.objectDic[@"mdmc"] forState:0];
        
        
        
        
        //合并cell的数据
        [_cellDataArray removeAllObjects];
        NSArray * spckcbsArray = weakself.objectDic[@"tbnote_spckcbs"];
        //先得到有多少商品，先取出所有的商品
        NSMutableArray * spidArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i<[spckcbsArray count]; i++) {
            [spidArray addObject:NSIntegerToNSString([spckcbsArray[i][@"spid"] integerValue])];
        }
        //得到去除重复商品的数组
        NSSet * spidSet = [NSSet setWithArray:spidArray];
        [spidArray removeAllObjects];
        spidArray = [NSMutableArray arrayWithArray:[spidSet allObjects]];
        //重新遍历原始数组，重新组合把相同商品的放入一个key
        NSMutableDictionary * spDic = [[NSMutableDictionary alloc]init];
        for (NSDictionary * dic1 in spckcbsArray) {
            NSMutableArray * spArr = [[NSMutableArray alloc]init];
            for (NSString * spid in spidArray) {
                if ([dic1[@"spid"] integerValue] == [spid integerValue]) {
                    [spArr addObject:dic1];
                }
                [spDic setValue:spArr forKey:NSIntegerToNSString([dic1[@"spid"] integerValue])];
            }
        }

        
        
//        [_cellDataArray addObject:spDic];
        
        
        //先取出所有的颜色
        NSMutableArray * colorArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i<[weakself.objectDic[@"tbnote_spckcbs"] count]; i++) {
            [colorArray addObject:weakself.objectDic[@"tbnote_spckcbs"][i][@"ys"]];
        }
        NSSet *set = [NSSet setWithArray:colorArray];
        [colorArray removeAllObjects];
        //得到去除重复颜色的数组
        colorArray = [NSMutableArray arrayWithArray:[set allObjects]];
        //重新遍历数组
        //重新创建一个数组，
        for (NSDictionary * dic1 in weakself.objectDic[@"tbnote_spckcbs"]) {
            for (NSString * str in colorArray) {
                if ([dic1[@"tbnote_spckcbs"] isEqualToString:str]) {
                    
                }
            }
        }
        
        

        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 230;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [self.objectDic[@"tbnote_xsddcbs"] count];
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}
#pragma mark ========== 尾视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 4) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        view.backgroundColor = KClearColor;
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"JDFooterView" owner:self options:nil];
        self.footerView = [nib objectAtIndex:0];
        self.footerView.bounds = view.bounds;
        [view addSubview:self.footerView];
        
        
        UIButton * btn1 = [self.footerView viewWithTag:30002];
        UIButton * btn2 = [self.footerView viewWithTag:30001];
        [btn2 setTitle:@"打印" forState:0];
        btn1.hidden = YES;
        kWeakSelf(self);
        self.footerView.bt2Block = ^{
            
        };
        return view;
    }
    return [super tableView:tableView viewForFooterInSection:section];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 4 ? 50 : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        JDSalesAffirmRunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDSalesAffirmRunTableViewCell" forIndexPath:indexPath];
        NSDictionary * dic = self.objectDic[@"tbnote_xsddcbs"][indexPath.row];
        [cell setChuKuDetail:dic];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}
@end
