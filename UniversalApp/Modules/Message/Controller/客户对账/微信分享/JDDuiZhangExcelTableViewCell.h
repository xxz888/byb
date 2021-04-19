//
//  JDDuiZhangExcelTableViewCell.h
//  excelDemo
//
//  Created by 小小醉 on 2020/3/12.
//  Copyright © 2020 xxz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDDuiZhangExcelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *outSideView;
@property (weak, nonatomic) IBOutlet UILabel *shangpinhuohao;
@property (weak, nonatomic) IBOutlet UILabel *shangpinmingcheng;
@property (weak, nonatomic) IBOutlet UILabel *shangpinyanse;
@property (weak, nonatomic) IBOutlet UILabel *shangpinzhaiyao;
@property (weak, nonatomic) IBOutlet UILabel *kaipiaoshuliang;
@property (weak, nonatomic) IBOutlet UILabel *kaipiaodanwei;
@property (weak, nonatomic) IBOutlet UILabel *kaipiaodanjia;
@property (weak, nonatomic) IBOutlet UILabel *kaipiaojine;
@property (weak, nonatomic) IBOutlet UILabel *xiaoshoupishu;
@property (weak, nonatomic) IBOutlet UILabel *xiaoshoushuliang;
@property (weak, nonatomic) IBOutlet UILabel *xiaoshoudanjia;
@property (weak, nonatomic) IBOutlet UILabel *jinezengjia;
@property (weak, nonatomic) IBOutlet UILabel *jinejianshao;
@property (weak, nonatomic) IBOutlet UILabel *jinedanjia;
@property (weak, nonatomic) IBOutlet UILabel *jinehuilv;
@property (weak, nonatomic) IBOutlet UILabel *jinbenbi;
@property (weak, nonatomic) IBOutlet UILabel *jinezhekou;
@property (weak, nonatomic) IBOutlet UILabel *jinejine;

@property (weak, nonatomic) IBOutlet UILabel *bianhao;
@property (weak, nonatomic) IBOutlet UILabel *danjuleixing;
@property (weak, nonatomic) IBOutlet UILabel *ruzhangriqi;
@property (weak, nonatomic) IBOutlet UILabel *kehumingcheng;
@property (weak, nonatomic) IBOutlet UILabel *danjuhaoma;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) UIView  *rightLine;
@property (nonatomic, strong) UIView  *bottomLine;
@end

NS_ASSUME_NONNULL_END
