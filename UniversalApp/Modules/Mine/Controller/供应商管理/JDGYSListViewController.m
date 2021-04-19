//
//  JDGYSListViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/8/7.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDGYSListViewController.h"
#import "JDGYSListTableViewCell.h"
#import "JDAddNewGYSTableViewController.h"
@interface JDGYSListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * bottomTableView;
@property (weak, nonatomic) IBOutlet UITextField *khTf;

@property (weak, nonatomic) IBOutlet UITextField *gysTf;



@property (nonatomic,strong) NSMutableArray * indexArray;
@property (nonatomic,strong) NSMutableArray * dataArray;




@end

@implementation JDGYSListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"供应商列表";
    _khTf.delegate = self;
    _indexArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    [self.gysTf addTarget:self action:@selector(changeTf:) forControlEvents:UIControlEventValueChanged];
    self.gysTf.delegate = self;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self requestData];
}
-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500",@"keywords":self.gysTf.text}];
    [AD_MANAGER requestGongYingShangListAction:mDic success:^(id object) {
        [_dataArray removeAllObjects];
        _dataArray = [weakself userSorting:[NSMutableArray arrayWithArray:object[@"data"][@"list"]]];
        [weakself.bottomTableView reloadData];
    }];
}

- (IBAction)searchTf:(id)sender {
    [self requestData];

}

#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.bottomView.frame.size.height) style:UITableViewStylePlain];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDGYSListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDGYSListTableViewCell"];
        _bottomTableView.separatorStyle = 0;
        [self.bottomView addSubview:_bottomTableView];
    }
    return _bottomTableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
//返回右侧索引标题数组
//这个标题的内容时和分区标题相对应
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexArray;
}
//设置 右侧索引标题 对应的分区索引

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //返回 对应的分区索引
    return index-1;
}
//cell 内容的向右缩进 级别
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 245;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 20)];
    //titile
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth, 20)];
    HeaderLabel.backgroundColor = JDRGBAColor(247, 249, 251);
    HeaderLabel.font = [UIFont boldSystemFontOfSize:13];
    HeaderLabel.textAlignment = NSTextAlignmentLeft;
    HeaderLabel.text = _indexArray[section];
    [view addSubview:HeaderLabel];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"JDGYSListTableViewCell";
    JDGYSListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[JDGYSListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    NSDictionary * dic = _dataArray[indexPath.section][indexPath.row];
    cell.titleLbl.text = dic[@"gysmc"];
    cell.telLbl.text = dic[@"lxrsj"];
    
    
    if ([dic[@"tbda_gys_lxrs"] count] == 0) {
        cell.lxrInfoLabel.text = [NSString stringWithFormat:@"%@ %@ %@",dic[@"lxrxm"],dic[@"lxrsj"],dic[@"lxrzw"]];
        cell.emailLbl.text = dic[@"lxremail"];
        cell.qqlbl.text = dic[@"lxrqq"];
        cell.addressTV.text = dic[@"lxdz"];
    }else{
        cell.lxrInfoLabel.text = [NSString stringWithFormat:@"%@ %@ %@",dic[@"tbda_gys_lxrs"][0][@"lxrxm"],dic[@"tbda_gys_lxrs"][0][@"lxrsj"],dic[@"tbda_gys_lxrs"][0][@"lxrzw"]];
        cell.emailLbl.text = dic[@"tbda_gys_lxrs"][0][@"lxremail"];
        cell.qqlbl.text = dic[@"tbda_gys_lxrs"][0][@"lxrqq"];
        cell.addressTV.text = dic[@"tbda_gys_lxrs"][0][@"lxdz"];
    }

    

    cell.yfzkLbl.text = CCHANGE_OTHER(dic[@"yfzk"]);
    cell.sfzkLbl.text = CCHANGE_OTHER(dic[@"sfzk"]);
    cell.qkLbl.text = CCHANGE_OTHER(dic[@""]);
    cell.addressTV.userInteractionEnabled = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = _dataArray[indexPath.section][indexPath.row];
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDAddNewGYSTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddNewGYSTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    VC.whereCome = YES;
    VC.gysid = [dic[@"gysid"] integerValue];
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)addKhAction:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDAddNewGYSTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddNewGYSTableViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestData];
    [self.view endEditing:YES];
    return YES;
}
-(void)changeTf:(UITextField *)tf{
      [self requestData];
}
//第二步 根据第一步获取到的 拼音首字母 对汉字进行排序

-(NSMutableArray *)userSorting:(NSMutableArray *)modelArr{
    [_indexArray removeAllObjects];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i='A';i<='Z';i++){
        NSMutableArray *rulesArray = [[NSMutableArray alloc] init];
        NSString *str1=[NSString stringWithFormat:@"%c",i];
        for(int j=0;j<modelArr.count;j++){
            NSDictionary * dic = [modelArr objectAtIndex:j];  //这个model 是我自己创建的 里面包含用户的姓名 手机号 和 转化成功后的首字母
            if([[self getLetter:dic[@"gysmc"]] isEqualToString:str1]){
                [rulesArray addObject:dic];    //把首字母相同的人物model 放到同一个数组里面
                [modelArr removeObject:dic];   //model 放到 rulesArray 里面说明这个model 已经拍好序了 所以从总的modelArr里面删除
                j--;
            }else{
            }
        }
        if (rulesArray.count !=0) {
            [array addObject:rulesArray];
            [_indexArray addObject:[NSString stringWithFormat:@"%c",i]]; //把大写字母也放到一个数组里面
        }
    }
    if (modelArr.count !=0) {
        [array addObject:modelArr];
        [_indexArray addObject:@"#"];  //把首字母不是A~Z里的字符全部放到 array里面 然后返回
    }
    return array;
}
-(NSString *) getLetter:(NSString *) strInput{
    strInput = [strInput stringByReplacingOccurrencesOfString:@" " withString:@""];

    if ([strInput length]) {
        
        NSMutableString *ms = [[NSMutableString alloc] initWithString:strInput];
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        
        NSArray *pyArray = [ms componentsSeparatedByString:@" "];
        if(pyArray && pyArray.count > 0){
            ms = [[NSMutableString alloc] init];
            for (NSString *strTemp in pyArray) {
                ms = [ms stringByAppendingString:[strTemp substringToIndex:1]];
            }
            
            return [[ms uppercaseString] substringToIndex:1];
        }
        
        ms = nil;
    }
    return nil;
}
@end
