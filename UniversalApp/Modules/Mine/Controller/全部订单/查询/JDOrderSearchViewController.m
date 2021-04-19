//
//  JDOrderSearchViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/6.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDOrderSearchViewController.h"
#import "CXSearchSectionModel.h"
#import "CXSearchModel.h"
#import "CXSearchCollectionViewCell.h"
#import "SelectCollectionReusableView.h"
#import "SelectCollectionLayout.h"
#import "CXDBHandle.h"
#import "JDAllOrderViewController.h"
static NSString *const cxSearchCollectionViewCell = @"CXSearchCollectionViewCell";

static NSString *const headerViewIden = @"HeadViewIden";
@interface JDOrderSearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SelectCollectionCellDelegate,UICollectionReusableViewButtonDelegate,UITextFieldDelegate>

/**
 *  存储网络请求的热搜，与本地缓存的历史搜索model数组
 */
@property (nonatomic, strong) NSMutableArray *sectionArray;
/**
 *  存搜索的数组 字典
 */
@property (nonatomic,strong) NSMutableArray *searchArray;

@property (weak, nonatomic) IBOutlet UICollectionView *cxSearchCollectionView;

@property (weak, nonatomic) IBOutlet UITextField *cxSearchTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) UITableView * bottomTableView;
@property (nonatomic,strong) JDAllOrderViewController * VC;
@property (weak, nonatomic) IBOutlet UIButton *orderTypeBtn;


@end

@implementation JDOrderSearchViewController
- (IBAction)dismissBtnActioin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)reloadData:(NSString *)textString
{
    [self.searchArray addObject:[NSDictionary dictionaryWithObject:textString forKey:@"content_name"]];
    
    NSDictionary *searchDict = @{@"section_id":@"2",@"section_title":@"历史记录",@"section_content":self.searchArray};
    
    /***由于数据量并不大 这样每次存入再删除没问题  存数据库*/
    NSDictionary *parmDict  = @{@"category":@"1"};
    [CXDBHandle saveStatuses:searchDict andParam:parmDict];
    
    CXSearchSectionModel *model = [[CXSearchSectionModel alloc]initWithDictionary:searchDict];
    if (self.sectionArray.count > 1) {
        [self.sectionArray removeLastObject];
    }
    [self.sectionArray addObject:model];
    [self.cxSearchCollectionView reloadData];
    
    
   
    
    [self clicktypeOrder:self.cxSearchTextField.text];

}
-(void)clicktypeOrder:(NSString *)searchText{
    self.bottomView.hidden = NO;
    for (UIViewController * VC in [self.navigationController viewControllers]) {
        if ([VC isKindOfClass:[JDAllOrderViewController class]]) {
            self.VC = VC;
        }
    }

    self.VC.whereCome = @"detail";
    self.bottomTableView  = self.VC.bottomTableView;
    [self.bottomView addSubview:self.bottomTableView];
    [self.view endEditing:YES];
    
if ([self.orderTypeBtn.titleLabel.text isEqualToString:@"预订单"]) {
    self.VC.selectTag1 = 0;
    [self.VC commonRequest:searchText];
}else if ([self.orderTypeBtn.titleLabel.text isEqualToString:@"销售单"]) {
    self.VC.selectTag1 = 1;
    [self.VC commonRequest:searchText];
}else if ([self.orderTypeBtn.titleLabel.text isEqualToString:@"样品单"]) {
    self.VC.selectTag1 = 2;
    [self.VC commonRequest:searchText];
}else if ([self.orderTypeBtn.titleLabel.text isEqualToString:@"退货单"]) {
    self.VC.selectTag1 = 3;
    [self.VC commonRequest:searchText];
}else if ([self.orderTypeBtn.titleLabel.text isEqualToString:@"收款单"]) {
    self.VC.selectTag1 = 4;
    [self.VC commonRequest:searchText];
}
    self.cxSearchTextField.text = @"";

}
#pragma mark ========== 选择订单的类型 ==========
- (IBAction)selectOrderTypeAction:(UIButton *)btn {
    kWeakSelf(self);
    [LEEAlert actionsheet].config
    .LeeTitle(nil)
    .LeeAction(@"预订单", ^{
         weakself.VC.selectTag1 = 0;
        [weakself.VC commonRequest:weakself.cxSearchTextField.text];
        [btn setTitle:@"预订单" forState:0];
    })
    .LeeAction(@"销售单", ^{
        [btn setTitle:@"销售单" forState:0];
        weakself.VC.selectTag1 = 1;
        [weakself.VC commonRequest:weakself.cxSearchTextField.text];
    })
    .LeeAction(@"样品单", ^{
        [btn setTitle:@"样品单" forState:0];
        weakself.VC.selectTag1 = 2;
        [weakself.VC commonRequest:weakself.cxSearchTextField.text];

        
    })
    .LeeAction(@"退货单", ^{
     
        [btn setTitle:@"退货单" forState:0];
        weakself.VC.selectTag1 = 3;
        [weakself.VC commonRequest:weakself.cxSearchTextField.text];
    })
    .LeeAction(@"收款单", ^{
        [btn setTitle:@"收款单" forState:0];
        weakself.VC.selectTag1 = 4;
        [weakself.VC commonRequest:weakself.cxSearchTextField.text];

    })
    .LeeCancelAction(@"取消", ^{

    })
    .LeeShow();
}

-(NSMutableArray *)sectionArray
{
    if (_sectionArray == nil) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

-(NSMutableArray *)searchArray
{
    if (_searchArray == nil) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareData];
    
    [self.cxSearchCollectionView setCollectionViewLayout:[[SelectCollectionLayout alloc] init] animated:YES];
    [self.cxSearchCollectionView registerClass:[SelectCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIden];
    [self.cxSearchCollectionView registerNib:[UINib nibWithNibName:@"CXSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cxSearchCollectionViewCell];
    
    self.cxSearchTextField.delegate = self;
    /***  可以做实时搜索*/
    //    [self.cxSearchTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)prepareData
{
    /**
     *  测试数据 ，字段暂时 只用一个 titleString，后续可以根据需求 相应加入新的字段
     */
    NSDictionary *testDict = @{@"section_id":@"1",@"section_title":@"",@"section_content":@[]};
    NSMutableArray *testArray = [@[] mutableCopy];
    [testArray addObject:testDict];
    
    /***  去数据查看 是否有数据*/
    NSDictionary *parmDict  = @{@"category":@"1"};
    NSDictionary *dbDictionary =  [CXDBHandle statusesWithParams:parmDict];
    
    if (dbDictionary.count) {
        [testArray addObject:dbDictionary];
        [self.searchArray addObjectsFromArray:dbDictionary[@"section_content"]];
    }
    
    for (NSDictionary *sectionDict in testArray) {
        CXSearchSectionModel *model = [[CXSearchSectionModel alloc]initWithDictionary:sectionDict];
        [self.sectionArray addObject:model];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CXSearchSectionModel *sectionModel =  self.sectionArray[section];
    return sectionModel.section_contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cxSearchCollectionViewCell forIndexPath:indexPath];
    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
    CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
    [cell.contentButton setTitle:contentModel.content_name forState:UIControlStateNormal];
    cell.selectDelegate = self;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]){
        SelectCollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIden forIndexPath:indexPath];
        view.delectDelegate = self;
        CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
        [view setText:sectionModel.section_title];
        /***  此处完全 也可以自定义自己想要的模型对应放入*/
        if(indexPath.section == 0)
        {
            [view setImage:@""];
            view.delectButton.hidden = YES;
        }else{
            [view setImage:@"cxSearch"];
            view.delectButton.hidden = NO;
        }
        reusableview = view;
    }
    return reusableview;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
    if (sectionModel.section_contentArray.count > 0) {
        CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
        return [CXSearchCollectionViewCell getSizeWithText:contentModel.content_name];
    }
    return CGSizeMake(80, 24);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - SelectCollectionCellDelegate
- (void)selectButttonClick:(CXSearchCollectionViewCell *)cell;
{
    NSIndexPath* indexPath = [self.cxSearchCollectionView indexPathForCell:cell];
    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
    CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
    [self clicktypeOrder:contentModel.content_name];

}

#pragma mark - UICollectionReusableViewButtonDelegate
- (void)delectData:(SelectCollectionReusableView *)view;
{
    if (self.sectionArray.count > 1) {
        [self.sectionArray removeLastObject];
        [self.searchArray removeAllObjects];
        [self.cxSearchCollectionView reloadData];
        [CXDBHandle saveStatuses:@{} andParam:@{@"category":@"1"}];
    }
}
#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.cxSearchTextField resignFirstResponder];
}
#pragma mark - textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self reloadData:textField.text];

    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        return NO;
    }
    /***  每搜索一次   就会存放一次到历史记录，但不存重复的*/
    if ([self.searchArray containsObject:[NSDictionary dictionaryWithObject:textField.text forKey:@"content_name"]]) {
        return YES;
    }
    return YES;
}



@end
