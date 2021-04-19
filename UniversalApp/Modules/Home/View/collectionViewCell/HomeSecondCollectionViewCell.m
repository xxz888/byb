//
//  HomeSecondCollectionViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "HomeSecondCollectionViewCell.h"


@implementation HomeSecondCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setItem:(NSInteger)row tag:(NSInteger)tag{
    NSArray * imgArr =
    tag == 1002 ? @[@"icon_xiadan",@"icon_yudingdan",@"icon_xiandanlishi",@"icon_yudingdanlishi",@"icon_tianjiashangpin",@"icon_tianjiakehu"] :
    tag == 1003 ? @[@"icon_kehu",@"icon_tianjiakehu",@"icon_qiankuanguanli",@"icon_tianjiakehu",@"icon_qiankuanguanli",@"icon_chaoqitixing"] :
       @[@"icon_xiadan",@"icon_yudingdan",@"icon_xiandanlishi",@"icon_yudingdanlishi"];
    
    NSArray * titleArr =
        tag == 1002 ? @[@"下现单",@"开预定单",@"销售单历史",@"预定单历史",@"添加商品",@"添加客户"] :
        tag == 1003 ? @[@"客户列表",@"添加客户",@"欠款管理",@"添加客户",@"欠款管理",@"超期提醒"] :      @[@"加工发货",@"加工收货",@"加工转厂",@"原料入库"];
    self.itemImg.image = [UIImage imageNamed:imgArr[row]];
    self.itemLbl.text = titleArr[row];
}
@end
