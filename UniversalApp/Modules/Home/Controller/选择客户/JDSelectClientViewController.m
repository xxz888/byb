//
//  JDSelectClientViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSelectClientViewController.h"
#import "JDSelectClientTableViewCell.h"
#import "LoginModel.h"
#import "JDSelectOddTagViewController.h"
#import "JDAddNewClientTableViewController.h"
#import "JDAddNewGYSTableViewController.h"
@interface JDSelectClientViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic,copy)UITableView * selectTableView;
@property (nonatomic,strong) NSMutableArray * indexArray;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation JDSelectClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CaiGouBOOL ? @"选择供应商" : @"选择客户";
    _indexArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _searchTf.delegate = self;
//    _whereInteger = 0;
        [self addNavigationItemWithTitles:@[@"+新增"] isLeft:NO target:self action:@selector(addClientBtn:) tags:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self requestData:@{@"pageno":@"1",@"pagesize":@"500",@"keywords":self.searchTf.text}];
}
#pragma mark ========== 新增客户 ==========
-(void)addClientBtn:(UIButton *)btn{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];

    
    if (CaiGouBOOL) {
        
        JDAddNewGYSTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddNewGYSTableViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        JDAddNewClientTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddNewClientTableViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }

    
}
-(void)requestData:(NSDictionary *)dic{
    
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:dic];
    kWeakSelf(self);

    if (CaiGouBOOL) {
        [AD_MANAGER requestGongYingShangListAction :mDic success:^(id str) {
            

            [weakself reloadTableView];
        }];
    }else{
        [AD_MANAGER requestSelectKhPage:mDic success:^(id str) {
            
            [weakself reloadTableView];
        }];
    }
}
-(void)refershHeader{
    [self requestData:@{@"pageno":@"1",@"pagesize":@"500",@"keywords":self.searchTf.text}];

}
-(void)reloadTableView{
    [self.selectTableView.mj_header endRefreshing];
    [self.selectTableView.mj_footer endRefreshing];
    [_dataArray removeAllObjects];
    _dataArray = [self userSorting:AD_MANAGER.selectKhPageArray];
    [self.selectTableView reloadData];
}
#pragma mark lazy loading...
-(UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc]initWithFrame:self.bottomView.bounds style:UITableViewStylePlain];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.tableFooterView = [[UIView alloc]init];
        [_selectTableView registerNib:[UINib nibWithNibName:@"JDSelectClientTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDSelectClientTableViewCell"];

        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refershHeader)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _selectTableView.mj_header = header;
    }
    [self.bottomView addSubview:_selectTableView];
    return _selectTableView;
}

- (IBAction)valueChangedTf:(UITextField *)sender {
    [self requestData:@{@"pageno":@"1",@"pagesize":@"500",@"keywords":sender.text}];
}
#pragma tableView--delegate
#pragma tableView
#pragma mark -表格索引

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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDSelectClientTableViewCell * cell = [self.selectTableView dequeueReusableCellWithIdentifier:@"JDSelectClientTableViewCell" forIndexPath:indexPath];
    JDSelectClientModel * model =_dataArray[indexPath.section][indexPath.row];
    [cell setValueModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    JDSelectOddTagViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSelectOddTagViewController"];
    JDSelectClientModel * model =_dataArray[indexPath.section][indexPath.row];
    [AD_MANAGER.affrimDic setValue: CaiGouBOOL ? model.gysmc : model.khmc forKey:CaiGouBOOL ? @"gysmc" :@"khmc"];
    
    if (_whereInteger == 0) {
        [self.navigationController pushViewController:VC animated:YES];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestData:@{}];
    [self.view endEditing:YES];
    return YES;
}

//第二步 根据第一步获取到的 拼音首字母 对汉字进行排序

-(NSMutableArray *)userSorting:(NSMutableArray *)modelArr{
    [_indexArray removeAllObjects];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i='A';i<='Z';i++){
        NSMutableArray *rulesArray = [[NSMutableArray alloc] init];
        NSString *str1=[NSString stringWithFormat:@"%c",i];
        for(int j=0;j<modelArr.count;j++){
            JDSelectClientModel * model = [modelArr objectAtIndex:j];  //这个model 是我自己创建的 里面包含用户的姓名 手机号 和 转化成功后的首字母
            if([[self getLetter:CaiGouBOOL ? model.gysmc : model.khmc] isEqualToString:str1]){
                [rulesArray addObject:model];    //把首字母相同的人物model 放到同一个数组里面
                [modelArr removeObject:model];   //model 放到 rulesArray 里面说明这个model 已经拍好序了 所以从总的modelArr里面删除
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
