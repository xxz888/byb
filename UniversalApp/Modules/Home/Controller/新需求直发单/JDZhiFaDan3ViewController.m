
//
//  JDZhiFaDan3ViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDZhiFaDan3ViewController.h"
#import "JDSelectOddCollectionViewCell.h"
#import "JDSelectSpModel.h"
#import "JDAddSpViewController.h"
#import "JDZhiFaDan4ViewController.h"
@interface JDZhiFaDan3ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property(nonatomic,copy)UICollectionView * bootomCollectionView;

@property (nonatomic,copy) JDSelectSpModel * spselectModel;
@end

@implementation JDZhiFaDan3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择货号";
    self.searchTf.delegate = self;
    [self.searchTf becomeFirstResponder];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"XinXuQiu" bundle:nil];
    JDZhiFaDan4ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDZhiFaDan4ViewController"];
    JDSelectSpModel * model = AD_MANAGER.selectSpPageArray[indexPath.row];
    [self commonAction:model VC:VC];
}
-(void)commonAction:(JDSelectSpModel *)spModel VC:(JDZhiFaDan4ViewController *)VC{
    //这一步判断如果添加过这个商品，就不往数组里面添加了
    //得到所有keys的数组
    NSMutableArray * keysArr = [[NSMutableArray alloc]init];
    //如果有值直接加，没值新创建
    if (NEW_AffrimDic_SectionArray && [NEW_AffrimDic_SectionArray count] > 0) {
        for (NSDictionary * dic in NEW_AffrimDic_SectionArray) {
            [keysArr addObject:[dic allKeys][0]];
        }
        
        //如果插入过，直接dismiss
        if ([keysArr containsObject:NSIntegerToNSString(spModel.spid)]) {
            
        }else{
            
            [NEW_AffrimDic_SectionArray addObject:@{NSIntegerToNSString(spModel.spid):@{@"sp":spModel,@"color":[[NSMutableArray alloc]init]}}];
        }
        
    }else{
         NEW_AffrimDic_SectionArray = [[NSMutableArray alloc]init];
        [NEW_AffrimDic_SectionArray addObject:@{NSIntegerToNSString(spModel.spid):@{@"sp":spModel,@"color":[[NSMutableArray alloc]init]}}];
    }
    
   
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark ========== 选择按钮方法 ==========
- (IBAction)selectBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
