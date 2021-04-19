//
//  JDDYManagerDetailTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
/**
 *  代理，用来传递点击的是第几行,当触CollectionView的时候
 */
@protocol  clickSelectBtn <NSObject>
-(void)clickSelectBtn1:(NSMutableArray *)array;
-(void)clickSelectBtn2:(NSMutableArray *)array;
-(void)clickSelectBtn3:(NSMutableArray *)array;
@end
@interface JDDYManagerDetailTableViewCell : BaseTableViewCell
/**
 *  数据源数组用来接受controller传过来的数据
 */
@property (strong, nonatomic) NSMutableArray *HomeArray;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *collectionSubView;
@property(nonatomic,copy)UICollectionView * addCountCollectionView;
@property (nonatomic,strong) NSString * whereComeCell;
@property (nonatomic,assign) BOOL whereCome;

@property (weak, nonatomic) id <clickSelectBtn> clickSelectBtnDelegate;


@end
