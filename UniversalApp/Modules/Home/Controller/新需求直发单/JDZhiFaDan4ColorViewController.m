//
//  JDZhiFaDan4ColorViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/22.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDZhiFaDan4ColorViewController.h"
#import "JDSelectOddCollectionViewCell.h"
#import "JDAddColorModel.h"
#import "JDAddSpViewController.h"
@interface JDZhiFaDan4ColorViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property(nonatomic,copy)UICollectionView * bootomCollectionView;

@end

@implementation JDZhiFaDan4ColorViewController
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
    
    NSString * spid = [NEW_AffrimDic_SectionArray[self.index] allKeys][0];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500",@"keywords":self.searchTf.text,@"spid":spid}];
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
    //得到所有keys的数组
    NSMutableArray * keysArr = [[NSMutableArray alloc]init];
    NSString * spid = [NEW_AffrimDic_SectionArray[self.index] allKeys][0];
    NSMutableArray * keysArrModel = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[NEW_AffrimDic_SectionArray[self.index][spid][@"color"] count]; i++) {
        JDAddColorModel * colorModel = NEW_AffrimDic_SectionArray[self.index][spid][@"color"][i][@"model"];
         [keysArr addObject:colorModel.sh];

    }
    
    //如果插入过，直接dismiss
    if ([keysArr containsObject:NSIntegerToNSString(model.sh)]) {
        
    }else{
        [NEW_AffrimDic_SectionArray[self.index][spid][@"color"] addObject:@{@"model":model,@"colArray":[[NSMutableArray alloc]init]}];
    }
    
    
    
    

//    model.saveFuDanWei = self.spModel.fjldw;
//    model.saveDanWei = self.spModel.jldw;
    kWeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        //请求这个颜色的进价
        
        [weakself.delegate dissmissValue:weakself.index];
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
@end
