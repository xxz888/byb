//
//  JDAddColorTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/21.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddColorTableViewCell.h"
#import "JDAddCountCollectionViewCell.h"
#import "YBPopupMenu.h"
@interface JDAddColorTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,delCountDelegate,UITextFieldDelegate,YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *cellAddCountView;
@property(nonatomic,copy)UICollectionView * addCountCollectionView;
@property (nonatomic,assign) NSInteger count;

@property (nonatomic,strong) NSMutableArray * countArray;



@end
@implementation JDAddColorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.cellAddCountView addSubview:self.addCountCollectionView];
    _countArray = [[NSMutableArray alloc]init];
    _bzTf.delegate = self;
    _khkhTf.delegate = self;
    _sigPriceTf.delegate = self;
    _countTf.delegate = self;
    _kcTf.delegate = self;
    _fcountTf.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextTextField:) name:@"xxxx" object:nil];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)nextTextField:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    [self textFieldShouldReturn:infoDic[@"tag"]];
}
-(void)setCellValueData:(JDSelectSpModel *)spModel color:(JDAddColorModel *)colorModel{
    [self.countArray removeAllObjects];
    [self.countArray addObjectsFromArray:colorModel.psArray];
    self.addCountLbl.text = [NSString stringWithFormat:@"(%@)",NSIntegerToNSString(self.countArray.count)];
    self.spModel = spModel;
    self.colorModel = colorModel;
    self.colorLbl.text = colorModel.ys;
    colorModel.saveDanWei = spModel.jldw;
    colorModel.saveFuDanWei = spModel.fjldw;
    

    self.danWeiLbl.text = colorModel.saveZhuFuTag == 0 ? spModel.jldw : spModel.fjldw;
    self.fcountLbl.text = spModel.fjldw;
    self.countTag.text = spModel.jldw;
    if (self.spModel.fjldw && self.spModel.fjldw.length > 0) {
        self.fcountTf.hidden = NO;
    }else{
        self.fcountTf.hidden = YES;

    }
    self.stockLbl.text = [[@"库存 " append:kGet2fDouble(colorModel.kczsl)] append:spModel.jldw];
    NSURL *url = [NSURL URLWithString:colorModel.imgurl];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    self.colorImg.image = imagea;
    
    if ([colorModel.savePrice doubleValue] != 0) {
        self.sigPriceTf.text = colorModel.savePrice;
    }else{
        self.sigPriceTf.text = doubleToNSString(colorModel.xsdj);
    }
    if ([self.sigPriceTf.text doubleValue] == 0) {
        self.sigPriceTf.text = @"0.00";
    }
    
    self.kcTf.text = colorModel.savekongcha;
    self.khkhTf.text = colorModel.saveKhkh;
    self.bzTf.text = colorModel.saveBz;
    
    [self.addCountCollectionView reloadData];
}
//价格的tf改变完，失去焦点的时候
- (IBAction)priceTfDidEndAction:(UITextField *)tf{
    if (self.priceDelegate && [self.priceDelegate respondsToSelector:@selector(priceChangeAction:)]) {
        [self.priceDelegate priceChangeAction:tf];
    }
}
//删除已选商品
-(void)delCountDelegate:(NSInteger)tag{
 
    [self.countArray removeObjectAtIndex:tag-200];
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in self.countArray) {
        [array addObject:dic[@"xssl"]];
    }
    NSNumber * sum = [array valueForKeyPath:@"@sum.floatValue"];
    self.addCountLbl.text = [NSString stringWithFormat:@"(%@)",NSIntegerToNSString(self.countArray.count)];
    [self.addCountCollectionView reloadData];
    if (self.countDelegate && [self.countDelegate respondsToSelector:@selector(countMinusAction:tf:count:)]) {
        [self.countDelegate countMinusAction:kGetString(sum) tf:self.sigPriceTf count:tag - 200];
    }
    //置空输入框
    self.countTf.text = @"";
    
}

-(void)changeDanWeiAction{
    NSArray * arr;
    if (self.spModel.fjldw && ![self.spModel.fjldw isEqualToString:@""]) {
        arr = @[self.spModel.jldw,self.spModel.fjldw];
    }else{
        arr = @[self.spModel.jldw];
    }
    [YBPopupMenu showRelyOnView:self.selectBtn titles:arr icons:nil menuWidth:120 delegate:self];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    self.danWeiLbl.text = ybPopupMenu.titles[index];
    [self.priceDelegate zhuFuDanWeiTagAction:index label:self.danWeiLbl];
}
-(UICollectionView *)addCountCollectionView{
    if (!_addCountCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.cellAddCountView.frame.size.width/ 3, 45);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection =     UICollectionViewScrollDirectionVertical;

        _addCountCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.cellAddCountView.frame.size.width,1000) collectionViewLayout:layout];
        _addCountCollectionView.delegate = self;
        _addCountCollectionView.dataSource = self;
        _addCountCollectionView.backgroundColor = KClearColor;
        _addCountCollectionView.showsVerticalScrollIndicator = YES;
        [_addCountCollectionView registerNib:[UINib nibWithNibName:@"JDAddCountCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JDAddCountCollectionViewCell"];
        
    }
    return _addCountCollectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return  self.countArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JDAddCountCollectionViewCell *cell = [self.addCountCollectionView dequeueReusableCellWithReuseIdentifier:@"JDAddCountCollectionViewCell" forIndexPath: indexPath];
    cell.delBtn.tag = 200+indexPath.row;
    NSString * count1 = doubleToNSString([self.countArray[indexPath.row][@"xssl"] doubleValue]);

    NSString * str1 = [count1 append:self.spModel.jldw];
    NSString * str2 = @"";

    NSString * count2 = doubleToNSString([self.countArray[indexPath.row][@"xsfsl"] doubleValue]);
    if ([count2 doubleValue] == 0) {
        str2 = @"";
    }else{
        str2 = [count2 append:self.spModel.fjldw];
    }
    cell.countTitleLbl.text = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    cell.delegate = self;
    return cell;
}
//备注
- (IBAction)bzTfValueChange:(UITextField *)tf {
    [self.priceDelegate xcbeizhuChangeAction:tf];
}
//客户款号
- (IBAction)khkhTfValueChange:(UITextField *)tf{
    [self.priceDelegate saveKhkhChangeAction:tf];

}
//空差
- (IBAction)kcTfValueChange:(UITextField *)tf {
    [self.priceDelegate savekongchaChangeAction:tf];

}


- (IBAction)priceTfValueChange:(id)sender {
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.sigPriceTf) {
        [_sigPriceTf resignFirstResponder];
        if (_khkhTf.hidden) {
            if (_kcTf.hidden) {
                [_countTf becomeFirstResponder];
            }else{
                [_kcTf becomeFirstResponder];
            }
        }else{
            if (_kcView.hidden) {
                [_countTf becomeFirstResponder];

            }else{
                [_kcTf becomeFirstResponder];
            }
        }
    }else if (textField == self.khkhTf){
        [_khkhTf resignFirstResponder];
        if (_kcView.hidden) {
            [_countTf becomeFirstResponder];
        }else{
            [_kcTf becomeFirstResponder];
        }
    }else if (textField == self.kcTf){
        
        [_countTf becomeFirstResponder];
//
//        [_kcTf resignFirstResponder];
//
//        if (_bzTf.hidden) {
//            [_countTf becomeFirstResponder];
//        }else{
//            [_bzTf becomeFirstResponder];
//        }
//  
    }else if (textField == self.bzTf){
        [_countTf becomeFirstResponder];
    }
    else if (textField == self.countTf){
        
        
        if ([self.colorModel.saveFuDanWei isEqualToString:@""]) {
            if ([self.countTf.text doubleValue] == 0) {
                [self.countTf becomeFirstResponder];
            }else{
                [self textChangerAction:self.countTf];
                self.countTf.text = @"";
                self.fcountTf.text  = @"";
                [self.countTf becomeFirstResponder];
            }
        }else{
            if (_countTf.text.length == 0) {
                [_countTf becomeFirstResponder];
            }else{
                [_fcountTf becomeFirstResponder];
            }
        }
    }else if (textField == self.fcountTf){

       [_countTf becomeFirstResponder];
    }
    
    self.editFinfishBlock();

    return YES;
}
//选择单位
- (IBAction)selectDanWeiAction:(id)sender {
    [self changeDanWeiAction];
}
//副单位
- (IBAction)fcountDidEndAction:(UITextField *)tf {
    if ([self.countTf.text isEqualToString:@""] || [self.countTf.text doubleValue] == 0) {
        return;
    }
    if (self.countTf.text.length != 0) {
        [self.countArray addObject:@{@"xsfsl":self.fcountTf.text,@"xssl":self.countTf.text}];
        NSMutableArray * array = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in self.countArray) {
            [array addObject:dic[@"xssl"]];
        }
        NSNumber * sum = [array valueForKeyPath:@"@sum.floatValue"];
        self.addCountLbl.text = [NSString stringWithFormat:@"(%@)",NSIntegerToNSString(self.countArray.count)];
        [self.addCountCollectionView reloadData];
        if (self.countDelegate && [self.countDelegate respondsToSelector:@selector(fcountChangeAction:count:fcount:)]) {
            [self.countDelegate fcountChangeAction:kGetString(sum) count:self.countTf fcount:self.fcountTf];}
        //置空输入框
        self.countTf.text = @"";
        self.fcountTf.text = @"";
    }
   

}
//主单位
- (IBAction)textChangerAction:(UITextField *)tf{
    if (tf.text.length == 0) {
        return;
    }
    //如果比率不为0
    if (self.spModel.fslbl != 0 ) {
        self.fcountTf.text = doubleToNSString([tf.text doubleValue] / self.spModel.fslbl);
    }
    if (self.spModel.fjldw && self.spModel.fjldw.length > 0) {
        if (![self.fcountTf.text isEqualToString:@""]) {
            [self fcountDidEndAction:self.fcountTf];
        }
    }else{
        [self fcountDidEndAction:self.fcountTf];
    }
    
}

@end
