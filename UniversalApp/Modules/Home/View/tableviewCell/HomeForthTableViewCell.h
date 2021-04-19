//
//  HomeForthTableViewCell.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/20.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeForthTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Albl1;
@property (weak, nonatomic) IBOutlet UILabel *Albl2;
@property (weak, nonatomic) IBOutlet UILabel *Albl3;
@property (weak, nonatomic) IBOutlet UIImageView *Aimg;
@property (weak, nonatomic) IBOutlet UILabel *Blbl1;
@property (weak, nonatomic) IBOutlet UILabel *Blbl2;
@property (weak, nonatomic) IBOutlet UILabel *Blbl3;
@property (weak, nonatomic) IBOutlet UIImageView *Bimv;

-(void)setCellData:(NSDictionary *)dic;
@end
