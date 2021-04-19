//
//  JDSalesAffirmViewController.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDSelectClientModel.h"
#import "JDAddColorModel.h"
#import "JDSelectCkPageModel.h"
#import "JDSelectShrModel.h"
#import "JDSelectYgModel.h"


typedef void(^sendClientModelBlock)(JDSelectClientModel *);
@interface JDSalesAffirmViewController : RootViewController
@property (nonatomic,strong) JDAddColorModel * colorModel;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLbl;
@property (nonatomic,strong) NSString * allPrice;


@property (nonatomic,strong) NSMutableDictionary * caogaoDic;

//样品单的参数，并且传到下个页面的共同参数
-(void)allOrderCommonParamters;
-(NSMutableArray *)allOrderXiaoShouTuiHuoListCommonParamtersArray;
-(JDSelectClientModel *)getClientModel;
@end
