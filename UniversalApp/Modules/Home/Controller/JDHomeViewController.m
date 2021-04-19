//
//  JDHomeViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//
#import "JDHomeViewController.h"
#import "JDAddNewClientTableViewController.h"
#import "HomeFirstTableViewCell.h"
#import "HomeSecondTableViewCell.h"
#import "HomeSecondCollectionViewCell.h"
#import "HomeThirdTableViewCell.h"
#import "HomeForthTableViewCell.h"
#import "JDSalesActionViewController.h"
#import "JDClientCheckingViewController.h"
#import "JDAllOrderViewController.h"
#import "JDNewAddSpTableViewController.h"
#import "JDKeHuListViewController.h"
#import "JDSalesTagViewController.h"
#import "HomeFivThTableViewCell.h"
#import "JDJiaGongFaHuoViewController.h"
#import "JDJiaGongZhuanChang1ViewController.h"

#import "JDJiaGongShouHuo1ViewController.h"

#define CLIENT_MANAGER_ITEM  6

@interface JDHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//客户管理view
@property (weak, nonatomic) IBOutlet UIView *clientManagerView;
//客户管理view高度，可配置的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clentManagerViewHeight;

@property(nonatomic,copy)UITableView * homeTableView;

@property(nonatomic,copy)UICollectionView * homeSecondCollectionView;
@property(nonatomic,copy)UICollectionView * homeThirdCollectionView;
@property(nonatomic,copy)UICollectionView * homeFivThCollectionView;

@property (nonatomic,strong) NSDictionary * dataDic;

@end

@implementation JDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //基本配置
    [self configurationUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    //营收简报
    [self requestData];
}

-(void)requestData{
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    [AD_MANAGER requestSelectKhPage:mDic1 success:^(id str) {
        
    }];
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"date":[NSString currentDateStringyyyyMMdd]}];
    [AD_MANAGER requestqueryCw_Jyjblist:mDic success:^(id object) {
        weakself.dataDic = [NSDictionary dictionaryWithDictionary:object[@"data"]];
        
        [UIView performWithoutAnimation:^{
            [weakself.homeTableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }];
    }];
}
-(void)configurationUI{
    
}


#pragma mark ========== tableview 点击 ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}




#pragma mark ========== collectionView 点击 ==========

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
    UIStoryboard * stroryBoard3 = [UIStoryboard storyboardWithName:@"ThirdVC" bundle:nil];
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    
    //这里区分是点击哪个collectionView
    if (collectionView.tag == 1002) {
        switch (indexPath.row) {
            case 0:{//销售单
                pushXiaoShouDan(self.navigationController);
            }
                break;
            case 1:{//开预订单
                pushYuDingDan(self.navigationController);
            }
                
                break;
            case 2:{//销售单历史
                JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
                VC.hidesBottomBarWhenPushed = YES;
                VC.selectTag1 = 2;
                [self.navigationController pushViewController:VC animated:YES];

            }
                
                break;
            case 3:{//预定单历史
                JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
                VC.hidesBottomBarWhenPushed = YES;

                VC.selectTag1 = 0;
                [self.navigationController pushViewController:VC animated:YES];
            }
                
                break;
            case 4:{//添加货号
                JDNewAddSpTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDNewAddSpTableViewController"];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
            }
                
                break;
            case 5:{
                JDAddNewClientTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddNewClientTableViewController"];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
            }
                
                break;
            default:
                break;
        }
    }
    if (collectionView.tag == 1003) {
        switch (indexPath.row) {
            case 0:{
                [REQUEST_PUSH_MANAGER qxPushKeHuVC:self.navigationController];
            }
                break;
            case 1:{
                JDAddNewClientTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDAddNewClientTableViewController"];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            case 2:{
                if (!Quan_Xian(@"查看销售额权限")){
                    [UIView showToast:QUANXIAN_ALERT_STRING(@"查看销售额权限",@"0")];
                }else{
                    JDClientCheckingViewController * VC = [stroryBoard3 instantiateViewControllerWithIdentifier:@"JDClientCheckingViewController"];
                    VC.navigationController.navigationBar.hidden = NO;
                    VC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:VC animated:YES];
                }
             
            }
                break;
            default:
                break;
        }
    }
    
    if (collectionView.tag == 1004) {
        switch (indexPath.row) {
                //加工入库和加工发货前三个界面一样，就复用下了
            case 0:{
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"JiaGongFaHuo" bundle:nil];
                AD_MANAGER.orderType = JiaGongFaHuo;
                REMOVE_ALL_CACHE;
                JDJiaGongFaHuoViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDJiaGongFaHuoViewController"];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
                //加工收货
            case 1:{
                
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"JiaGongShouHuo" bundle:nil];
                AD_MANAGER.orderType = JiaGongShouHuo;
                REMOVE_ALL_CACHE;
                JDJiaGongShouHuo1ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDJiaGongShouHuo1ViewController"];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
            }
                
                break;
                //加工转厂
            case 2:{
                
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"JiaGongZhuanChang" bundle:nil];
                AD_MANAGER.orderType = JiaGongZhuanChang;
                REMOVE_ALL_CACHE;
                JDJiaGongZhuanChang1ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDJiaGongZhuanChang1ViewController"];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
            }
                
                break;
            case 3:{
                //加工入库和加工发货前三个界面一样，就复用下了
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"JiaGongFaHuo" bundle:nil];
                AD_MANAGER.orderType = YuanLiaoRuKu;
                REMOVE_ALL_CACHE;
                JDJiaGongFaHuoViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDJiaGongFaHuoViewController"];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            default:
                break;
        }
    }

}






























#pragma mark ========== tableview 创建及代理 ==========
-(UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.tableFooterView = [[UIView alloc]init];
        [_homeTableView registerNib:[UINib nibWithNibName:@"HomeFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeFirstTableViewCell"];
        [_homeTableView registerNib:[UINib nibWithNibName:@"HomeSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeSecondTableViewCell"];
        [_homeTableView registerNib:[UINib nibWithNibName:@"HomeThirdTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeThirdTableViewCell"];
        [_homeTableView registerNib:[UINib nibWithNibName:@"HomeForthTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeForthTableViewCell"];
               [_homeTableView registerNib:[UINib nibWithNibName:@"HomeFivThTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeFivThTableViewCell"];
        
        [self.view addSubview:_homeTableView];
    }
    return _homeTableView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case 1:
            title = @"  常用工具";
            break;
        case 2:
            title = @"  客户管理";
            break;
        case 3:
            title = @"  加工管理";
            break;
        case 4:
            title = @"  数据报表";
            break;
        case 5:
            title = @"  营收简报";
            break;
        default:
            break;
    }
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 40)];
    //titile
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    HeaderLabel.backgroundColor = JDRGBAColor(247, 249, 251);
    HeaderLabel.font = [UIFont boldSystemFontOfSize:13];
    HeaderLabel.textColor = JDRGBAColor(153, 153, 153);
    HeaderLabel.text = title;
    [view addSubview:HeaderLabel];

    //编辑按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    if (section == 1 || section == 2) {
        [btn setImage:[UIImage imageNamed:@"icon_bianji"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(KScreenWidth - 30, 0, 14, 14);
        btn.hidden = YES;

    }else if (section == 4){
        [btn setTitle:@"查看更多>>" forState:UIControlStateNormal];
        btn.frame = CGRectMake(KScreenWidth - 100, 0, 100, 18);
        [btn setFont:[UIFont systemFontOfSize:13]];
        [btn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else if (section == 5){
        [btn setTitle:@"今日" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(KScreenWidth - 100, 0, 66, 22);
        [btn setFont:[UIFont systemFontOfSize:13]];
        [btn setBackgroundColor:JDRGBAColor_alpha(37, 149, 255)];
        ViewBorderRadius(btn, 5, 1, JDRGBAColor(37, 149, 255));
        
    }
    btn.centerY = view.centerY;

    [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}
-(void)moreBtn:(UIButton *)btn{
    [REQUEST_PUSH_MANAGER qxPushShangPin:self.tabBarController];

}
-(void)clicked:(UIButton *)btn{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 30;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }else if (indexPath.section == 1){
        return 192;
    }else if (indexPath.section == 2){
        return 192 /2;
    }else if (indexPath.section == 3){
        return 192;
    }else if (indexPath.section == 4){
        return 10;
    }else if (indexPath.section == 5){
        return 164;
    }
    else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HomeFirstTableViewCell * cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeFirstTableViewCell" forIndexPath:indexPath];
        kWeakSelf(self);
        cell.block = ^{
            weakself.tabBarController.selectedIndex = 1;
        };
        return cell;
    }else if (indexPath.section == 1){
        HomeSecondTableViewCell * cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeSecondTableViewCell" forIndexPath:indexPath];
        [cell addSubview:self.homeSecondCollectionView];
        return cell;
    }else if (indexPath.section == 2){
        HomeThirdTableViewCell * cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeThirdTableViewCell" forIndexPath:indexPath];
        [cell addSubview:self.homeThirdCollectionView];
        return cell;
    }else if (indexPath.section == 3){
        HomeFivThTableViewCell * cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeFivThTableViewCell" forIndexPath:indexPath];
        [cell addSubview:self.homeFivThCollectionView];

        return cell;
    }
    else if (indexPath.section == 4){
        HomeSecondTableViewCell * cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeSecondTableViewCell" forIndexPath:indexPath];
        return cell;
    }else{
        HomeForthTableViewCell * cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeForthTableViewCell" forIndexPath:indexPath];
        [cell setCellData:self.dataDic];
        return cell;
    }
}



#pragma mark ========== collectionView 创建及代理 ==========
-(UICollectionView *)homeThirdCollectionView{
    if (!_homeThirdCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(KScreenWidth / 3, 100);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _homeThirdCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,200) collectionViewLayout:layout];
        _homeThirdCollectionView.backgroundColor = [UIColor clearColor];
        _homeThirdCollectionView.delegate = self;
        _homeThirdCollectionView.dataSource = self;
        _homeThirdCollectionView.tag = 1003;
        
        
        [_homeThirdCollectionView registerNib:[UINib nibWithNibName:@"HomeSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeSecondCollectionViewCell"];
    }
    return _homeThirdCollectionView;
}
-(UICollectionView *)homeSecondCollectionView{
    if (!_homeSecondCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(KScreenWidth / 3, 100);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _homeSecondCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,200) collectionViewLayout:layout];
        _homeSecondCollectionView.backgroundColor = [UIColor clearColor];
        _homeSecondCollectionView.delegate = self;
        _homeSecondCollectionView.dataSource = self;
        _homeSecondCollectionView.tag = 1002;
        
        
        
        [_homeSecondCollectionView registerNib:[UINib nibWithNibName:@"HomeSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeSecondCollectionViewCell"];
    }
    return _homeSecondCollectionView;
}
-(UICollectionView *)homeFivThCollectionView{
    if (!_homeFivThCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(KScreenWidth / 3, 100);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _homeFivThCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,200) collectionViewLayout:layout];
        _homeFivThCollectionView.backgroundColor = [UIColor clearColor];
        _homeFivThCollectionView.delegate = self;
        _homeFivThCollectionView.dataSource = self;
        _homeFivThCollectionView.tag = 1004;
        
        
        
        [_homeFivThCollectionView registerNib:[UINib nibWithNibName:@"HomeSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeSecondCollectionViewCell"];
    }
    return _homeFivThCollectionView;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collectionView.tag == 1002  ? 6 : collectionView.tag == 1004 ? 4 : 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeSecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSecondCollectionViewCell" forIndexPath:indexPath];
    [cell setItem:indexPath.row tag:collectionView.tag];
    
    return cell;
}
@end
