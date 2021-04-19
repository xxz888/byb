//
//  JDZhiFaDan4TableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/21.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDAddColorModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^jinjiaDidEndActionBlock)();
typedef void(^xiaojiaDidEndActionBlock)();
typedef void(^countDidEndActionBlock)();

@interface JDZhiFaDan4TableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//添加数量，动态改变cell高度
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong) NSArray * dataArr;
@property (weak, nonatomic) IBOutlet UITextField *jinjiaTf;
@property (weak, nonatomic) IBOutlet UILabel *addCountLbl;
@property (weak, nonatomic) IBOutlet UIImageView *colorImg;
@property (weak, nonatomic) IBOutlet UILabel *colorLbl;
@property (weak, nonatomic) IBOutlet UILabel *stockLbl;
@property (weak, nonatomic) IBOutlet UILabel *jinjiaLbl;

@property (weak, nonatomic) IBOutlet UITextField *sigPriceTf;
@property (weak, nonatomic) IBOutlet UITextField *countTf;
@property (weak, nonatomic) IBOutlet UITextField *fcountTf;
@property (weak, nonatomic) IBOutlet UIView *spDetailView;
@property (weak, nonatomic) IBOutlet UILabel *countTag;
- (IBAction)selectDanWeiAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fcountLbl;
- (IBAction)fcountDidEndAction:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIView * cellAddCountView;
@property (weak, nonatomic) IBOutlet UICollectionView *yxCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionFatherViewHeight;
-(void)setCellData:(NSIndexPath *)indexPath;
- (IBAction)countTfDidEndAction:(UITextField *)sender;
- (IBAction)jinjiaDidEndAction:(UITextField *)sender;
- (IBAction)xiaojiaDidEndAction:(UITextField *)sender;

@property (weak, nonatomic) IBOutlet UILabel *danWeiLbl;
@property (nonatomic,copy) jinjiaDidEndActionBlock jinjiBlock;
@property (nonatomic,copy) xiaojiaDidEndActionBlock xiaojiaBlock;
@property (nonatomic,copy) countDidEndActionBlock countBlock;

@property (nonatomic,strong) JDSelectSpModel * spModel;
@property (nonatomic,strong) JDAddColorModel * colorModel;


@end

NS_ASSUME_NONNULL_END
