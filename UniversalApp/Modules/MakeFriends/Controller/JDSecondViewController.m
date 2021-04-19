//
//  JDSecondViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/28.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSecondViewController.h"
#import "JDSelectOddCollectionViewCell.h"
#import "JDSecondCollectionViewCell.h"
#import "JDNewAddSpTableViewController.h"
#import "SelectedListView.h"
#import "JDSpDetailViewController.h"
#import "JDNewAddSpTableViewController.h"
#import "JDSeKaWebViewController.h"
#import "HWScanViewController.h"

@interface JDSecondViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>@property(nonatomic,copy)UICollectionView * bootomCollectionView;

@end

@implementation JDSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bottomView addSubview:self.bootomCollectionView];
    self.searchTF.delegate = self;
    
    //1.创建手势对象

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];

    //2.手势相关的属性

    //点击次数（默认1）

    tapGesture.numberOfTapsRequired = 1;

    //手指的个数（默认1）

    tapGesture.numberOfTouchesRequired = 1;

    //3.把手势与视图相关联

    [self.scanImv addGestureRecognizer:tapGesture];
    self.scanImv.userInteractionEnabled = YES;
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    HWScanViewController *vc = [[HWScanViewController alloc] init];
   [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self requestData:@""];

}


-(void)requestData:(NSString *)sort{
    NSMutableDictionary * mDic;
    if ([sort isEqualToString:@""]) {
        mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"2000",@"keywords":self.searchTF.text,@"showdj":@1}];
    }else{
        mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"2000",@"keywords":self.searchTF.text,@"sort":sort,@"showdj":@1}];
    }

    kWeakSelf(self);
    [AD_MANAGER requestSelectSpPage:mDic success:^(id str) {
        [weakself.bootomCollectionView reloadData];
        
        [weakself.bootomCollectionView.mj_header endRefreshing];
        [weakself.bootomCollectionView.mj_footer endRefreshing];
    }];
}
#pragma mark ========== 创建tableview ==========
#pragma mark lazy loading...
-(UICollectionView *)bootomCollectionView{
    if (!_bootomCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((KScreenWidth - 1) / 2 , 80);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _bootomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,KScreenHeight - 106 - kTabBarHeight-kStatusBarHeight) collectionViewLayout:layout];
        _bootomCollectionView.backgroundColor = JDRGBAColor(247, 249, 251);
        _bootomCollectionView.delegate = self;
        _bootomCollectionView.dataSource = self;
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _bootomCollectionView.mj_header = header;
        
        [_bootomCollectionView registerNib:[UINib nibWithNibName:@"JDSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JDSecondCollectionViewCell"];
        
    }
    return _bootomCollectionView;
}
#pragma mark ————— 下拉刷新 —————
-(void)headerRereshing{
    [self requestData:@""];
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return AD_MANAGER.selectSpPageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JDSecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDSecondCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = KWhiteColor;
    JDSelectSpModel * model = AD_MANAGER.selectSpPageArray[indexPath.row];
    cell.lbl1.text = model.sphh;
    cell.lbl2.text = model.spmc;
    if (model.sfdj == 0) {
        cell.lbl3.text = [[@"库存:" append:doubleToNSString(model.spsl)] append:model.jldw];
        cell.lbl3.textColor = JDRGBAColor(153, 153, 153);

    }else{
        cell.lbl3.text = @"冻结";
        cell.lbl3.textColor = JDRGBAColor(38, 207, 126);
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * stroryBoard2 = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDSpDetailViewController * VC = [stroryBoard2 instantiateViewControllerWithIdentifier:@"JDSpDetailViewController"];
    VC.spModel = AD_MANAGER.selectSpPageArray[indexPath.row];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
   
}
- (IBAction)addSpAction:(id)sender {
    UIImage * un_image = [UIImage imageNamed:@"icon_xinzeng"];
    NSData *data1 = UIImagePNGRepresentation(un_image);
    NSData *data = UIImagePNGRepresentation(self.addCancleBtn.imageView.image);
    
    if ([self.addCancleBtn.titleLabel.text isEqualToString:@"取消"]) {
        [self.addCancleBtn setTitle:@"" forState:0];
        [self.addCancleBtn setImage:[UIImage imageNamed:@"icon_xinzeng"] forState:0];
        self.searchTF.text = @"";
        [self requestData:@""];
        return;
    }
    if ([data isEqual:data1]) {
        UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
        JDNewAddSpTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDNewAddSpTableViewController"];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else{

    }

}

//搜索
- (IBAction)changeTFValue:(id)sender {
    
}

//选择分类
- (IBAction)btn1Action:(id)sender {
    [self showToast:@"暂无分类"];
}
//库存排序
- (IBAction)btn2Actioin:(id)sender {
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"默认排序"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"库存从高到低"],
                   [[SelectedListModel alloc] initWithSid:2 Title:@"库存从低到高"]];
    kWeakSelf(self);
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            SelectedListModel * model = array[0];
            [weakself.btn2 setTitle:model.title forState:0];
            //点击排序，更改sort的值，刷新
            [weakself requestData:NSIntegerToNSString(model.sid)];
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //如果开始编辑，来判断tf的值
//    [self.addCancleBtn setTitle:@"取消" forState:0];
//    [self.addCancleBtn setImage:[UIImage imageNamed:@""] forState:0];
//    HWScanViewController *vc = [[HWScanViewController alloc] init];
//
//    kWeakSelf(self);
//      vc.scanblock = ^(NSString * scanString) {
//          weakself.searchTF.text = scanString;
//          [weakself requestData:@"0"];
//      };
//       [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //点击排序，更改sort的值，刷新
    [self requestData:@"0"];
    [self.searchTF resignFirstResponder];
    return YES;
}
- (IBAction)sekaAction:(id)sender {
    if (!Quan_Xian(@"色卡资料库")) {
        [UIView showToast:QUANXIAN_ALERT_STRING(@"色卡资料库",@"0")];
        return;
    }
    JDSeKaWebViewController * VC = [[JDSeKaWebViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
