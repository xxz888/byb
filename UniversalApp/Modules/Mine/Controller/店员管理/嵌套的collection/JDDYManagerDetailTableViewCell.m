//
//  JDDYManagerDetailTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDDYManagerDetailTableViewCell.h"
#import "JDDYManagerCollectionViewCell.h"
#import "JDQXModel.h"
#import "JDMDModel.h"
#import "JDCKModel.h"
@interface JDDYManagerDetailTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}
@end

@implementation JDDYManagerDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UICollectionView *)addCountCollectionView{
    if (!_addCountCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((self.frame.size.width - 30 )/ 3, self.collectionSubView.frame.size.height/2);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection =     UICollectionViewScrollDirectionVertical;
        
        _addCountCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width - 30,self.collectionSubView.frame.size.height) collectionViewLayout:layout];
        _addCountCollectionView.delegate = self;
        _addCountCollectionView.dataSource = self;
        _addCountCollectionView.backgroundColor = KClearColor;
        _addCountCollectionView.showsVerticalScrollIndicator = YES;
        [_addCountCollectionView registerNib:[UINib nibWithNibName:@"JDDYManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JDDYManagerCollectionViewCell"];
        [self.collectionSubView addSubview:_addCountCollectionView];
        
    }
    return _addCountCollectionView;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.HomeArray.count;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        JDDYManagerCollectionViewCell *collcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDDYManagerCollectionViewCell" forIndexPath:indexPath];
    UIImage * un_image = [UIImage imageNamed:@"icon_weiduoxuan"];
    UIImage * an_image = [UIImage imageNamed:@"icon_duoxuan"];

    if ([self.whereComeCell isEqualToString:@"1"]) {
        JDMDModel * model = [self.HomeArray objectAtIndex:indexPath.row];
        [collcell.collectBtn setTitle:model.mdmc forState:0];
        [collcell.collectBtn setImage:model.select ? an_image:un_image forState:0];
        collcell.collectBtn.tag = 100 + indexPath.row;
        [collcell.collectBtn addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([self.whereComeCell isEqualToString:@"2"]){
        JDCKModel * model = [self.HomeArray objectAtIndex:indexPath.row];
        [collcell.collectBtn setTitle:model.ckmc forState:0];
        [collcell.collectBtn setImage:model.select ? an_image:un_image forState:0];
        collcell.collectBtn.tag = 100 + indexPath.row;
        [collcell.collectBtn addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        JDQXModel * model = [self.HomeArray objectAtIndex:indexPath.row];
        [collcell.collectBtn setTitle:model.jsmc forState:0];
        [collcell.collectBtn setImage:model.select ? an_image:un_image forState:0];
        collcell.collectBtn.tag = 100 + indexPath.row;
        [collcell.collectBtn addTarget:self action:@selector(clickBtn3:) forControlEvents:UIControlEventTouchUpInside];
    }
    return collcell;
}
-(void)clickBtn1:(UIButton *)btn{
    ((JDMDModel *)self.HomeArray[btn.tag-100]).select = [self clickReturnBOOL:btn];
    [self.clickSelectBtnDelegate clickSelectBtn1:self.HomeArray];
}
-(void)clickBtn2:(UIButton *)btn{
    ((JDCKModel *)self.HomeArray[btn.tag-100]).select = [self clickReturnBOOL:btn];
    [self.clickSelectBtnDelegate clickSelectBtn2:self.HomeArray];

}
-(void)clickBtn3:(UIButton *)btn{
    ((JDQXModel *)self.HomeArray[btn.tag-100]).select = [self clickReturnBOOL:btn];
    [self.clickSelectBtnDelegate clickSelectBtn3:self.HomeArray];

}
-(BOOL)clickReturnBOOL:(UIButton *)btn{
    UIImage * un_image = [UIImage imageNamed:@"icon_weiduoxuan"];
    UIImage * an_image = [UIImage imageNamed:@"icon_duoxuan"];
    NSData *data1 = UIImagePNGRepresentation(un_image);
    NSData *data = UIImagePNGRepresentation(btn.imageView.image);
    BOOL select = NO;
    if ([data isEqual:data1]) {
        [btn setImage:an_image forState:0];
        select = YES;
    }else{
        [btn setImage:un_image forState:0];
        select = NO;
    }
    return select;
}

@end
