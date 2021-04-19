//
//  JDOrder1FaHuoTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDOrder1FaHuoTableViewCell.h"
#import "JDAddCountCollectionViewCell.h"

@interface JDOrder1FaHuoTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,delCountDelegate,UITextFieldDelegate>
@property(nonatomic,copy)UICollectionView * addCountCollectionView;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSDictionary * resultDic;


@end
@implementation JDOrder1FaHuoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countArray = [[NSMutableArray alloc]init];
    self.msTf.delegate = self;
    self.fuMsTf.delegate = self;
    [self.addCountCollectionView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextTextField:) name:@"xxxx" object:nil];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)setCellDic:(NSDictionary * )dic{
    self.resultDic = [NSDictionary dictionaryWithDictionary:dic];
}
- (void)nextTextField:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    [self textFieldShouldReturn:infoDic[@"tag"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)msTfAction:(UITextField *)tf {
    if (_msTf.text.doubleValue == 0) {
        return;
    }
}
- (IBAction)fMsAction:(id)sender {
    [self.countArray addObject:@{@"xssl":self.msTf.text,@"xsfsl":self.fuMsTf.text}];
}
- (IBAction)btnAction:(id)sender {
    if (self.msTf.text.length == 0) {
        return;
    }
    [self setCellOtherData];
    if (self.countDelegate) {
        [self.countDelegate countChangeAction:self.msTf array:self.countArray];
    }
    //置空输入框
    self.msTf.text = @"";
    self.fuMsTf.text = @"";
    self.subHeight.constant = [self collectionHeight1];
    kWeakSelf(self);
    [UIView performWithoutAnimation:^{
        [weakself.addCountCollectionView reloadData];
        [weakself.addCountCollectionView setFrame:CGRectMake(0, 0, KScreenWidth - 30,[self collectionHeight1])];
    }];
    [self.msTf becomeFirstResponder];
}
-(void)setCellOtherData{
    self.Blbl1.text = NSIntegerToNSString(self.countArray.count);
        NSMutableArray * arr1 = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in self.countArray) {
            [arr1 addObject:dic[@"xssl"]];
        }
        NSNumber * sum1 = [arr1 valueForKeyPath:@"@sum.floatValue"];
        self.Blbl2.text = CCHANGE_DOUBLE([sum1 doubleValue]);
        self.Blbl3.text = CCHANGE_DOUBLE([sum1 doubleValue] * _price);
}
- (void)delCountDelegate:(NSInteger)tag{
    [self.countArray removeObjectAtIndex:tag-200];
    [self setCellOtherData];
    if (self.countDelegate) {
        [self.countDelegate delChangeAction:self.msTf array:self.countArray];
    }
    //置空输入框
    self.msTf.text = @"";
    self.subHeight.constant = [self collectionHeight1];
    kWeakSelf(self);
    [UIView performWithoutAnimation:^{
        [weakself.addCountCollectionView reloadData];
        [weakself.addCountCollectionView setFrame:CGRectMake(0, 0, KScreenWidth - 30,[self collectionHeight1])];
    }];
}
-(UICollectionView *)addCountCollectionView{
    if (!_addCountCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((KScreenWidth - 30) /3, 40);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection =     UICollectionViewScrollDirectionVertical;
        _addCountCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 30,[self collectionHeight1]) collectionViewLayout:layout];
        _addCountCollectionView.delegate = self;
        _addCountCollectionView.dataSource = self;
        _addCountCollectionView.backgroundColor = KClearColor;
        _addCountCollectionView.showsVerticalScrollIndicator = YES;
        [_addCountCollectionView registerNib:[UINib nibWithNibName:@"JDAddCountCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JDAddCountCollectionViewCell"];
        [self.collectSubView addSubview:_addCountCollectionView];
    }
    return _addCountCollectionView;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.countArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JDAddCountCollectionViewCell *cell = [self.addCountCollectionView dequeueReusableCellWithReuseIdentifier:@"JDAddCountCollectionViewCell" forIndexPath: indexPath];
    NSString * str1 = @"";
    NSString * str2 = @"";
    cell.delBtn.tag = 200 + indexPath.row;
    NSString * count1 = doubleToNSString([self.countArray[indexPath.row][@"xssl"] doubleValue]);
    NSString * count2 = doubleToNSString([self.countArray[indexPath.row][@"xsfsl"] doubleValue]);
    NSString * danwei1 = self.resultDic[@"jldw"];
    NSString * danwei2 = self.resultDic[@"fjldw"];
    if ([self.resultDic[@"jjfs"] integerValue] == 0) {
        str1 = [count1 append:danwei1];
        str2 = [count2 append:danwei2];
    }else{
        if (danwei2.length != 0) {
            str1 = [count1 append:danwei2];
            str2 = [count2 append:danwei1];
        }
    }
    if (str2.length != 0 ) {
        cell.countTitleLbl.text = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    }else{
        cell.countTitleLbl.text = [NSString stringWithFormat:@"%@",str1];
    }
    cell.delegate = self;
    return cell;
}
-(CGFloat)collectionHeight1{
    NSInteger i = ([self.countArray count] + 3 - 1) / 3 ;
    return 40 *  (i == 0 ? 1 : i);
}
- (void)layoutSubviews{
   [super layoutSubviews];
   [self.addCountCollectionView setFrame:CGRectMake(0, 0, KScreenWidth - 30,[self collectionHeight1])];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.msTf) {
        if (self.msTf.text.doubleValue == 0) {
            [self.msTf becomeFirstResponder];
        }else{
//            [self.msTf resignFirstResponder];
            [self.fuMsTf becomeFirstResponder];
        }
    }else if(textField == self.fuMsTf){
        [self.msTf becomeFirstResponder];
        [self btnAction:self.addMsBtn];
    }
    
    return YES;
}

@end
