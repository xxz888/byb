//
//  JDJiaGongShouHuo3ViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDJiaGongShouHuo3ViewController.h"
#import "JDSelectOddCollectionViewCell.h"
#import "JDSelectSpModel.h"
#import "JDAddSpViewController.h"
#import "JDJiaGongShouHuo4ViewController.h"
@interface JDJiaGongShouHuo3ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property(nonatomic,copy)UICollectionView * bootomCollectionView;

@property (nonatomic,copy) JDSelectSpModel * spselectModel;

@end

@implementation JDJiaGongShouHuo3ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择坯布货号";
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
    //改变的话，更改选择按钮的titile
    if (self.searchTf.text.length == 0) {
        [self.selectBtn setTitle:@"取消" forState:0];
    }else{
        [self.selectBtn setTitle:@"完成" forState:0];
    }
    [self requestData];
}
-(void)requestData:(NSDictionary *)dic{
    
}
-(void)requestData{
    NSMutableDictionary * mDic;
    if (self.searchTf.text.length == 0) {
        mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
    }else{
        mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500",@"keywords":self.searchTf.text}];
    }
    kWeakSelf(self);
    [AD_MANAGER requestSelectSpPage:mDic success:^(id str) {
        
        weakself.bootomCollectionView.backgroundColor = JDRGBAColor(247, 249, 251);
        [weakself.bootomCollectionView reloadData];
    }];
}
#pragma mark ========== 创建tableview ==========
#pragma mark lazy loading...
-(UICollectionView *)bootomCollectionView{
    if (!_bootomCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((KScreenWidth - 1 )/ 2 , 80);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _bootomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,self.bottomView.frame.size.height) collectionViewLayout:layout];
        _bootomCollectionView.backgroundColor = [UIColor clearColor];
        _bootomCollectionView.delegate = self;
        _bootomCollectionView.dataSource = self;
        _bootomCollectionView.backgroundColor = KWhiteColor;
        
        [_bootomCollectionView registerNib:[UINib nibWithNibName:@"JDSelectOddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JDSelectOddCollectionViewCell"];
    }
    [self.bottomView addSubview:_bootomCollectionView];
    
    return _bootomCollectionView;
}
//每个单元格的大小size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((KScreenWidth - 1 )/ 2, 80);
    
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
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
    
    JDSelectOddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDSelectOddCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = KWhiteColor;
    JDSelectSpModel * model = AD_MANAGER.selectSpPageArray[indexPath.row];
    [cell setValueData:model];
    for(int i =0; i < [cell.spTitleLbl.text length]; i++) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:cell.spTitleLbl.text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[cell.spTitleLbl.text rangeOfString:self.searchTf.text]];
        cell.spTitleLbl.attributedText = str;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"JiaGongShouHuo" bundle:nil];
    JDJiaGongShouHuo4ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDJiaGongShouHuo4ViewController"];
    JDSelectSpModel * spModel =  AD_MANAGER.selectSpPageArray[indexPath.row];
    //每点击一次，就加一个model
    NSMutableArray * mArr = [[NSMutableArray alloc]init];
    //这一步判断如果添加过这个商品，就不往数组里面添加了
    //得到所有keys的数组
    NSMutableArray * keysArr = [[NSMutableArray alloc]init];
    if (AD_MANAGER.sectionArray.count > 0) {
        for (NSDictionary * dic in AD_MANAGER.sectionArray) {
            [keysArr addObject:[dic allKeys][0]];
        }
    }
 
        if (AD_MANAGER.sectionArray.count > 1) {
            [AD_MANAGER.sectionArray removeObjectAtIndex:1];
        }
        [AD_MANAGER.sectionArray addObject:@{NSIntegerToNSString(spModel.spid):mArr}];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ========== 选择按钮方法 ==========
- (IBAction)selectBtnAction:(id)sender {
    kWeakSelf(self);
    
    if ([self.selectBtn.titleLabel.text isEqualToString:@"取消"]) {
        [weakself.navigationController popViewControllerAnimated:YES];
    }else{
        [self commonAction];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    [self commonAction];
    return YES;
}
-(void)commonAction{
    kWeakSelf(self);
    if ([self getSpModel]) {
        weakself.selectFinshSpBlock([weakself getSpModel]);
        [weakself.navigationController popViewControllerAnimated:YES];
        
    }else{
        NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"sphh":self.searchTf.text}];
        [AD_MANAGER requestAutoAddSp:mDic1 success:^(id object) {
            JDSelectSpModel * newModel1 = [[JDSelectSpModel alloc]init];
            [newModel1 setValuesForKeysWithDictionary:object[@"data"]];
            weakself.selectFinshSpBlock(newModel1);
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }
}
-(JDSelectSpModel *)getSpModel{
    BOOL have = NO;
    JDSelectSpModel * sendModel;
    for (JDSelectSpModel * model in AD_MANAGER.selectSpPageArray) {
        //如果没有找到商品
        if ([model.sphh contains:self.searchTf.text]) {
            have = YES;
            sendModel = model;
            sendModel.have = have;
            break;
        }else{
            have = NO;
            sendModel.have = have;
        }
    }
    
    if (have) {
        return sendModel;
    }else{
        return nil;
    }
}

@end
