//
//  JDFooterView.h
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/4.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^btn1Block)(UIButton *);
typedef void(^btn2Block)();
@interface JDFooterView : UIView
- (IBAction)btn1Action:(id)sender;
- (IBAction)btn2Action:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;


@property (nonatomic,copy) btn1Block bt1Block;
@property (nonatomic,copy) btn2Block bt2Block;
@end
