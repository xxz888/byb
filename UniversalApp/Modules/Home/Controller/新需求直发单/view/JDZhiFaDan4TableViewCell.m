//
//  JDZhiFaDan4TableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/21.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDZhiFaDan4TableViewCell.h"
#import "JDZhiFaDan4CollectionViewCell.h"

@implementation JDZhiFaDan4TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self baseCellConfig];
}
// Config
- (void)baseCellConfig{
    self.yxCollectionView.delegate = self;
    self.yxCollectionView.dataSource = self;
    self.yxCollectionView.showsHorizontalScrollIndicator = YES;
    [self.yxCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JDZhiFaDan4CollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"JDZhiFaDan4CollectionViewCell"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextTextField:) name:@"xxxx" object:nil];
}
-(void)setCellData:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    NSString * spid = [NEW_AffrimDic_SectionArray[section] allKeys][0];
    self.spModel = NEW_AffrimDic_SectionArray[section][spid][@"sp"];
    self.colorModel = NEW_AffrimDic_SectionArray[section][spid][@"color"][row][@"model"];
    //颜色头像
    NSURL *url = [NSURL URLWithString:self.colorModel.imgurl];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    self.colorImg.image = imagea;
    //颜色名字
    self.colorLbl.text = self.colorModel.ys;
    //库存
    self.stockLbl.text = [[@"库存: " append:kGet2fDouble(self.colorModel.kczsl)] append:self.spModel.jldw];
    //单位
    self.danWeiLbl.text =  self.spModel.jldw;
    //添加时候的单位
    self.countTag.text = self.spModel.jldw;
    //销价
    BOOL xiaoshouJia =
    [self.colorModel.saveXiaoJiaPrice isEqualToString:@""] || !self.colorModel.saveXiaoJiaPrice;
    self.sigPriceTf.text = xiaoshouJia ?  doubleToNSString(self.colorModel.xsdj) : self.colorModel.saveXiaoJiaPrice ;
    self.sigPriceTf.text = self.sigPriceTf.text.integerValue == 0 ?  @"" : self.sigPriceTf.text ;
    //进价
    self.jinjiaLbl.text = [@"进价: " append:kGet2fDouble(self.colorModel.cbdj)];
    //添加多少数量
    [self collectionViewAddCount];
    //刷新下面collection
    [self.yxCollectionView reloadData];
}
//输入完明细加入到下边collection框里边
- (IBAction)countTfDidEndAction:(UITextField *)tf{
    if ([tf.text isEqualToString:@""]) {
        return;
    }
    NSString * spid = [NEW_AffrimDic_SectionArray[self.indexPath.section] allKeys][0];
    [NEW_AffrimDic_SectionArray[self.indexPath.section][spid][@"color"][self.indexPath.row][@"colArray"] addObject:tf.text];
    [self.yxCollectionView reloadData];
    self.countTf.text = @"";
    NSInteger addCount = [NEW_AffrimDic_SectionArray[self.indexPath.section][spid][@"color"][self.indexPath.row][@"colArray"] count];
    self.addCountLbl.text = NSIntegerToNSString(addCount);
    self.countBlock();
}
//销价
- (IBAction)xiaojiaDidEndAction:(UITextField *)sender{
    NSInteger section = self.indexPath.section;
    NSInteger row = self.indexPath.row;
    NSString * spid = [NEW_AffrimDic_SectionArray[section] allKeys][0];
    JDAddColorModel * colorModel = NEW_AffrimDic_SectionArray[section][spid][@"color"][row][@"model"];
    colorModel.saveXiaoJiaPrice = sender.text;
    self.xiaojiaBlock();
}
//点击collectionitem删除
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - Collection Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSString * spid = [NEW_AffrimDic_SectionArray[self.indexPath.section] allKeys][0];
    return [NEW_AffrimDic_SectionArray[self.indexPath.section][spid][@"color"][self.indexPath.row][@"colArray"] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JDZhiFaDan4CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDZhiFaDan4CollectionViewCell" forIndexPath:indexPath];
    cell.delBtn.tag = indexPath.row;

    NSString * spid = [NEW_AffrimDic_SectionArray[self.indexPath.section] allKeys][0];
    NSString * string = NEW_AffrimDic_SectionArray[self.indexPath.section][spid][@"color"][self.indexPath.row][@"colArray"][indexPath.row];
    cell.title.text = [string append:self.spModel.jldw];
    kWeakSelf(self);
    cell.delBlock = ^(NSInteger index) {
        NSString * spid = [NEW_AffrimDic_SectionArray[self.indexPath.section] allKeys][0];
        [NEW_AffrimDic_SectionArray[self.indexPath.section][spid][@"color"][self.indexPath.row][@"colArray"] removeObjectAtIndex:indexPath.row];
        [weakself.yxCollectionView reloadData];
        [weakself collectionViewAddCount];
        weakself.countBlock();
    };
    return cell;
}
//已经添加了多少collitem
-(void)collectionViewAddCount{
    NSString * spid = [NEW_AffrimDic_SectionArray[self.indexPath.section] allKeys][0];
    NSInteger addCount = [NEW_AffrimDic_SectionArray[self.indexPath.section][spid][@"color"][self.indexPath.row][@"colArray"] count];
    self.addCountLbl.text = NSIntegerToNSString(addCount);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight = CGRectGetHeight(self.yxCollectionView.frame);
    return CGSizeMake(80 , cellHeight);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeZero;
}

- (void)nextTextField:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    [self textFieldShouldReturn:infoDic[@"tag"]];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.sigPriceTf) {
        [_sigPriceTf resignFirstResponder];
        [_countTf becomeFirstResponder];
    }else if (textField == _countTf){
        [_countTf becomeFirstResponder];
        [self countTfDidEndAction:_countTf];
    }
    return YES;
}
- (IBAction)nextAction:(id)sender {
}


@end
