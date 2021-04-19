//
//  JDZhiFaDan6ViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/23.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "JDSelectClientModel.h"
#import "JDSelectCkPageModel.h"
#import "JDSelectShrModel.h"
#import "JDSelectYgModel.h"
#import "JDSalesAffirmViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JDZhiFaDan6ViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (nonatomic,strong) JDSelectClientModel * clientModel;


@property (nonatomic,strong) NSString * allPrice;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLbl;
@property (nonatomic,strong) NSMutableDictionary * allOrderCommonParamtersDic;//所有共同的方法
@property (nonatomic,strong) NSMutableArray * allOrderXiaoShouTuiHuoListCommonParamtersArray;//商品列表。退货和销售单的公用方法 =
@property (nonatomic,strong) NSMutableArray * allOrderYangPinYuDingListCommonParamtersArray;//样品单和预定单公用的商品列表方法
@property (nonatomic,strong) NSMutableArray * allOrderCaiGouRuKuListCommonParamtersArray;//入库单公用的商品列表方法
@property (nonatomic,strong) NSMutableDictionary * caogaoDic;

@end

NS_ASSUME_NONNULL_END
