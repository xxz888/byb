//
//  JDColorKuCunDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2020/2/18.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "JDColorKuCunDetailViewController.h"
#import "JDColorKuCunDetailViewCell.h"

#import "SelectedListView.h"
@interface JDColorKuCunDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation JDColorKuCunDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"JDColorKuCunDetailViewCell" bundle:nil ] forCellReuseIdentifier:@"JDColorKuCunDetailViewCell"];
    self.yxTableView.delegate  = self;
    self.yxTableView.dataSource = self;
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    self.ckTitle.text = [NSString stringWithFormat:@"%@库存明细(%@)",self.dic[@"ckmc"],self.dic[@"ys"]];
    [self requestCkData];
}
-(void)requestCkData{
     NSString * string = [ADTool dicConvertToNSString:self.dic];
     NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"condition":string,@"pageno":@(1),@"pagesize":@(1000)}];
     kWeakSelf(self);
     [AD_MANAGER requestColorKucunMingXi:mDic success:^(id object) {
         [weakself.dataArray removeAllObjects];
         [weakself.dataArray addObjectsFromArray:object[@"data"][@"data"]];
         [weakself.yxTableView reloadData];
     }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDColorKuCunDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDColorKuCunDetailViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.shenfenmaLbl.text = dic[@"sfm"];
    cell.pishuLbl.text = kGetString(dic[@"spps"]);
    cell.shuliangLbl.text = doubleToNSString([dic[@"spsl"] doubleValue]);
    cell.fushuliangLbl.text = doubleToNSString([dic[@"spfsl"] doubleValue]);
    cell.shishuLbl.text = doubleToNSString([dic[@"spss"] doubleValue]);
    cell.kongchaLbl.text = kGetString(dic[@"spkc"]);
    cell.ganghaoLbl.text = dic[@"gh"];
    
    [self isLinglbl:cell.shenfenmaLbl];
    [self isLinglbl:cell.pishuLbl];
    [self isLinglbl:cell.shuliangLbl];
    [self isLinglbl:cell.fushuliangLbl];
    [self isLinglbl:cell.shishuLbl];
    [self isLinglbl:cell.kongchaLbl];
//    [self isLinglbl:cell.ganghaoLbl];

    return cell;
}
-(void)isLinglbl:(UILabel *)label{
    if ([label.text doubleValue] == 0) {
        label.text = @"";
    }
}
- (IBAction)selectCkAction:(id)sender {
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
                  [weakself.dic setValue:model.title forKey:@"ckmc"];
                  weakself.ckTitle.text = [NSString stringWithFormat:@"%@库存明细(%@)",model.title,self.dic[@"ys"]];

                  //仓库
                  [weakself requestCkData];
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
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
