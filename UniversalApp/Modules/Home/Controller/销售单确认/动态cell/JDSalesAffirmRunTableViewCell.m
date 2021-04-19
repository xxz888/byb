
//
//  JDSalesAffirmRunTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSalesAffirmRunTableViewCell.h"
#import "JDAddCountCollectionViewCell.h"
@interface JDSalesAffirmRunTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSMutableArray * _spDetailArray;//商品明细的数组
}
@property(nonatomic,copy)UICollectionView * addCountCollectionView;
@property (nonatomic,strong) NSMutableArray * countArray;
@end

@implementation JDSalesAffirmRunTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _spDetailArray = [[NSMutableArray alloc]init];
//    [self.collectSubView addSubview:self.addCountCollectionView];
    
    
}

-(void)setRunColorValue:(JDSelectClientModel *)clientModle colorModel:(JDAddColorModel *)colorModel{

    self.colorModel = colorModel;
    
    self.titleLbl.text = [AD_SHARE_MANAGER inShangPinIdOutName:colorModel.spid];
    //颜色
    self.colorLbl.text = self.colorModel.ys;
    //图片
    NSURL *url = [NSURL URLWithString:self.colorModel.imgurl];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    self.colorImg.image = imagea;
    
    if (ORDER_ISEQUAl(XiaoShouDan) || ORDER_ISEQUAl(TuiHuoDan) || ORDER_ISEQUAl(ChuKuDan) || CaiGouBOOL || ORDER_ISEQUAl(ZhiFaDan) ) {
        //价格
        self.priceLbl.text = self.colorModel.savePrice;
        //批数
        self.lbl1.text = [NSIntegerToNSString(self.colorModel.psArray.count) append:@" 匹"];
        //count
        double count = 0;
        NSString * danwei = @"";
        for (NSDictionary * dic in self.colorModel.psArray) {
            if (self.colorModel.saveZhuFuTag == 0) {
                count += [dic[@"xssl"] doubleValue];
                danwei = self.colorModel.saveDanWei;
            }else{
                count += [dic[@"xsfsl"] doubleValue];
                danwei = self.colorModel.saveFuDanWei;
            }
        }
        NSString * string1 = [doubleToNSString(count) append:danwei];

        self.lbl2.text = string1;

    }else if(ORDER_ISEQUAl(YuDingDan)  || ORDER_ISEQUAl(JiaGongFaHuo)  || ORDER_ISEQUAl(JiaGongShouHuo)){
        
        self.priceLbl.text = [self.colorModel.savePrice append:@"元"];
        self.lbl1.text = [self.colorModel.savePishu append:@"匹"];
        
        self.lbl2.text = [self.colorModel.saveCount append:self.colorModel.saveZhuFuTag == 0 ? self.colorModel.saveDanWei : self.colorModel.saveFuDanWei];
        self.upDownBtn.hidden = YES;
    }else if(ORDER_ISEQUAl(YangPinDan)){
        self.priceLbl.text = [self.colorModel.savePrice append:@"元"];
        self.lbl1.text =  [self.colorModel.saveCount append:self.colorModel.saveZhuFuTag == 0 ? self.colorModel.saveDanWei : self.colorModel.saveFuDanWei];
        self.lbl2.hidden = YES;
        self.upDownBtn.hidden = YES;
    }
    [self.addCountCollectionView reloadData];
}


- (IBAction)upDownBtnAction:(id)sender {
    self.colorModel.isShowMore = !self.colorModel.isShowMore;
    
    if (self.colorModel.isShowMore) {
        [self.upDownBtn setImage:[UIImage imageNamed:@"icon_up"] forState:0];
    }else{
        [self.upDownBtn setImage:[UIImage imageNamed:@"icon_down"] forState:0];
    }
    
    
    self.upDownBlock(self);
}
-(CGFloat)collectionHeight{
    NSInteger i = ([self.colorModel.psArray count] + 3 - 1) / 3 ;
    return 40 * (i == 0 ? 1 : i);
}

-(UICollectionView *)addCountCollectionView{
    if (!_addCountCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((KScreenWidth - 20) / 3, 40);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection =     UICollectionViewScrollDirectionVertical;
        
        _addCountCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 100, KScreenWidth - 20,[self collectionHeight]) collectionViewLayout:layout];
        _addCountCollectionView.delegate = self;
        _addCountCollectionView.dataSource = self;
        _addCountCollectionView.backgroundColor = KClearColor;
        _addCountCollectionView.showsVerticalScrollIndicator = YES;
        [_addCountCollectionView registerNib:[UINib nibWithNibName:@"JDAddCountCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JDAddCountCollectionViewCell"];
        [self addSubview:_addCountCollectionView];
        
    }
    return _addCountCollectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.colorModel.psArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JDAddCountCollectionViewCell *cell = [self.addCountCollectionView dequeueReusableCellWithReuseIdentifier:@"JDAddCountCollectionViewCell" forIndexPath: indexPath];
    cell.delBtn.hidden = YES;
    NSString * count = @"-";
    
    NSString * userDanWei = @"";
    //先看所选用的单位是多少
    if(self.colorModel.saveZhuFuTag == 0) {
        userDanWei = self.colorModel.saveDanWei;
        if (self.colorModel.psArray.count > indexPath.row) {
            NSDictionary *item = self.colorModel.psArray[indexPath.row];
            count = doubleToNSString([item[@"xssl"] doubleValue]);
        }
    }else if (self.colorModel.saveZhuFuTag == 1){
        userDanWei = self.colorModel.saveFuDanWei;
        if (self.colorModel.psArray.count > indexPath.row) {
            NSDictionary *item = self.colorModel.psArray[indexPath.row];
            count = doubleToNSString([item[@"xsfsl"] doubleValue]);
        }
    }

    cell.countTitleLbl.text = [NSString stringWithFormat:@"%@%@",count,userDanWei];
    return cell;
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.colorModel.isShowMore){ // 展开状态
        [self.addCountCollectionView setFrame:CGRectMake(10, 100, KScreenWidth - 20,[self collectionHeight])];
//        [self.contentView setFrame:CGRectMake(0, 0, KScreenWidth, 100 + [self collectionHeight])];

    } else { // 收缩状态
        [self.addCountCollectionView setFrame:CGRectMake(10, 100, KScreenWidth - 20,0)];
//        [self.contentView setFrame:CGRectMake(0, 0, KScreenWidth, 100 )];

    }
}
@end
