//
//  JDSalesView.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/6/24.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDButtom.h"

@interface JDSalesView : UIView

typedef  void(^tfChangeBlock)(UITextField *);
typedef  void(^btnChangeBlock)(UIButton *);

typedef void(^payWayActionBlock)(JDSalesView *);

@property (weak, nonatomic) IBOutlet JDButtom *saleswayBtn;
- (IBAction)saleswayAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *wayTitltLbl;
@property (weak, nonatomic) IBOutlet UITextField *priceTf;
@property (nonatomic,copy) payWayActionBlock block;
@property (nonatomic,copy) tfChangeBlock tfblock;
@property (nonatomic,copy) btnChangeBlock btnblock;

@property (nonatomic,assign) NSInteger sid;
@end
