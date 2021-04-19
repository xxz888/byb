//
//  JDJiaGongFaHuoColor3ViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDJiaGongFaHuoColor3ViewController.h"
#import "JDSelectOddCollectionViewCell.h"
#import "JDAddColorModel.h"
#import "JDAddSpViewController.h"

@interface JDJiaGongFaHuoColor3ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property(nonatomic,copy)UICollectionView * bootomCollectionView;


@end

@implementation JDJiaGongFaHuoColor3ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择货色";
    self.searchTf.delegate = self;
    [self.searchTf becomeFirstResponder];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self requestData];
}
#pragma mark ========== 搜索框值改变，开始网络请求 ==========
- (IBAction)searchTfChanged:(id)sender {
    [self requestData];
}

-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500",@"keywords":self.searchTf.text,@"spid":self.spid}];
    [AD_MANAGER requestAddColorPage:mDic success:^(id str) {
        weakself.bootomCollectionView.backgroundColor = JDRGBAColor(247, 249, 251);
        [weakself.bootomCollectionView reloadData];
    }];
}
#pragma mark ========== 创建tableview ==========
#pragma mark lazy loading...
-(UICollectionView *)bootomCollectionView{
    if (!_bootomCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((KScreenWidth - 1) / 2 , 51);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _bootomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,self.bottomView.frame.size.height) collectionViewLayout:layout];
        _bootomCollectionView.delegate = self;
        _bootomCollectionView.dataSource = self;
        //        _bootomCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _bootomCollectionView.backgroundColor = KWhiteColor;
        
        [_bootomCollectionView registerNib:[UINib nibWithNibName:@"JDSelectOddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JDSelectOddCollectionViewCell"];
        [self.bottomView addSubview:_bootomCollectionView];
    }
    return _bootomCollectionView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return AD_MANAGER.addColorArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JDSelectOddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDSelectOddCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = KWhiteColor;
    JDAddColorModel * model = AD_MANAGER.addColorArray[indexPath.row];
    [cell setColorValueData:model];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JDAddColorModel * model = AD_MANAGER.addColorArray[indexPath.row];
    model.saveFuDanWei = self.spModel.fjldw;
    model.saveDanWei = self.spModel.jldw;
    kWeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        [weakself.delegate dissmissValue:model];
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.bootomCollectionView removeFromSuperview];
    self.bootomCollectionView = nil;
    
}
#pragma mark ========== 选择按钮方法 ==========
- (IBAction)selectBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    kWeakSelf(self);
    [AD_MANAGER requestAddColorPage:mDic success:^(id str) {
        BOOL have = NO;
        for (JDAddColorModel * model in AD_MANAGER.addColorArray) {
            //如果没有找到颜色
            if (![model.ys isEqualToString:textField.text]) {
                have = YES;
            }else{
                have = NO;
            }
        }
        if (!have) {
            NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"spid":@(self.spModel.spid),@"ys":textField.text}];
            [AD_MANAGER requestAutoAddYs:mDic1 success:^(id object) {
                [weakself showToast:@"这款颜色尚未存档,将在下单后为你自动建档!"];
                
                JDAddColorModel * newModel = [[JDAddColorModel alloc]init];
                [newModel setValuesForKeysWithDictionary:object[@"data"]];
                [newModel setValue:self.spModel.jldw forKey:@"saveDanWei"];
                [newModel setValue:self.spModel.fjldw forKey:@"saveFuDanWei"];
                [newModel setValue:@(0) forKey:@"saveZhuFuTag"];
                [weakself dismissViewControllerAnimated:YES completion:^{
                    [weakself.delegate dissmissValue:newModel];
                }];
            }];
        }
    }];
    
    
    
    return YES;
    
}

@end
