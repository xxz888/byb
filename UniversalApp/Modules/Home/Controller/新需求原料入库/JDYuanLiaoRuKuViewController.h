//
//  JDYuanLiaoRuKuViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectClientModel.h"
#import "JDAddColorModel.h"
#import "JDSelectCkPageModel.h"
#import "JDSelectShrModel.h"
#import "JDSelectYgModel.h"

typedef void(^sendClientModelBlock)(JDSelectClientModel *);

NS_ASSUME_NONNULL_BEGIN

@interface JDYuanLiaoRuKuViewController : RootViewController
@property (nonatomic,strong) JDAddColorModel * colorModel;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLbl;
@property (nonatomic,strong) NSString * allPrice;


@property (nonatomic,strong) NSMutableDictionary * caogaoDic;

//样品单的参数，并且传到下个页面的共同参数
-(void)allOrderCommonParamters;
-(NSMutableArray *)allOrderXiaoShouTuiHuoListCommonParamtersArray;
-(JDSelectClientModel *)getClientModel;
@end

NS_ASSUME_NONNULL_END
