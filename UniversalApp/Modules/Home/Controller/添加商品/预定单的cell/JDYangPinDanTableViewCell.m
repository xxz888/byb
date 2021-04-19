//
//  JDYangPinDanTableViewCell.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDYangPinDanTableViewCell.h"
#import "HLPopTableView.h"
#import "UIView+HLExtension.h"
#import "YBPopupMenu.h"

@interface JDYangPinDanTableViewCell ()<YBPopupMenuDelegate>
@property (nonatomic,strong) JDSelectSpModel * spModel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation JDYangPinDanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tf1.delegate = self;
    self.tf2.delegate = self;
    self.tf3.delegate = self;
    self.tf4.delegate = self;
    self.tf5.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextTextField:) name:@"xxxx" object:nil];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)nextTextField:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    [self textFieldShouldReturn:infoDic[@"tag"]];
}
-(void) setCellValueData:(JDSelectSpModel *)spModel color:(JDAddColorModel *)colorModel{
    self.spModel = spModel;
    self.colorLbl.text = colorModel.ys;
//    colorModel.saveDanWei = spModel.jldw;
    self.lbl3.text = colorModel.saveZhuFuTag == 0 ? colorModel.saveDanWei :colorModel.saveFuDanWei;
    self.stockLbl.text = [[@"库存 " append:kGet2fDouble(colorModel.kczsl)] append: spModel.jldw];
    NSURL *url = [NSURL URLWithString:colorModel.imgurl];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    self.colorImg.image = imagea;
    
    
    if ([colorModel.savePrice doubleValue] == 0 || !colorModel.savePrice) {
        if (colorModel.xsdj == 0) {
            self.tf1.text = @"";
        }else{
            self.tf1.text =doubleToNSString(colorModel.xsdj);
        }
    }else{
        self.tf1.text = colorModel.savePrice;
    }
    
    self.
    
    self.tf2.text = colorModel.savePishu;
    self.tf3.text = colorModel.saveCount;
    self.tf4.text = colorModel.saveKhkh;
    self.tf5.text = colorModel.savekongcha;
    self.view3.text = colorModel.saveBz;
    
    
//    colorModel.saveFuDanWei =spModel.jldw;
    
    
    
//    if ([self.tf2.text doubleValue] == 0) {
//        self.tf2.text = @"";
//    }
//    if ([self.tf3.text doubleValue] == 0) {
//        self.tf3.text = @"";
//    }
//    if ([self.tf5.text doubleValue] == 0) {
//        self.tf5.text = @"";
//    }
}
//元
- (IBAction)tf1Change:(UITextField *)tf {
    [self.yangpinDelegate priceYpChangeAction:tf];
}
//匹
- (IBAction)tf2Change:(UITextField *)tf {
    [self.yangpinDelegate piShuChangeAction:tf];
}
//长度
- (IBAction)tf3Change:(UITextField *)tf {
    [self.yangpinDelegate ChangDuChangeAction:tf];
}
//客户款号
- (IBAction)tf4Change:(UITextField *)tf {
    [self.yangpinDelegate khkhChangeAction:tf];
}
//空差
- (IBAction)tf5Change:(UITextField *)tf {
    [self.yangpinDelegate kongchaChangeAction:tf];
}
//备注
- (IBAction)tf6Change:(UITextField *)tf {
    [self.yangpinDelegate beizhuChangeAction:tf];
}




- (IBAction)btn1Action:(id)sender{
    NSArray * arr;
    if (self.spModel.fjldw && ![self.spModel.fjldw isEqualToString:@""]) {
        arr = @[self.spModel.jldw,self.spModel.fjldw];
    }else{
        arr = @[self.spModel.jldw];

    }
    
        [YBPopupMenu showRelyOnView:self.btn1 titles:arr icons:nil menuWidth:120 delegate:self];
//    kWeakSelf(self);
//    HLPopTableView * hlPopView = [HLPopTableView initWithFrame:CGRectMake(self.btn1.frame.size.width, 0, 70, [arr count] * 45) dependView:sender textArr:arr block:^(NSString *region_name, NSInteger index) {
//
//    }];
//    [self addSubview:hlPopView];
}
#pragma mark - YBPopupMenuDelegate

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    
    self.lbl3.text = ybPopupMenu.titles[index];
    [self.yangpinDelegate danweiChangeAction:self.lbl3];
    [self.yangpinDelegate zhuFuDanWeiTag:index label:self.lbl3];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (ORDER_ISEQUAl(YangPinDan)) {
        if (textField == _tf1) {
            [_tf1 resignFirstResponder];
            [_tf3 becomeFirstResponder];
        }else if (textField == _tf3){
            [_tf3 resignFirstResponder];
        }
//            [_tf4 becomeFirstResponder];
//        }else if (textField == _tf4){
//            [_tf4 resignFirstResponder];
//            [_tf5 becomeFirstResponder];
//        }else if (textField == _tf5){
//            [_tf5 resignFirstResponder];
//            [_view3 becomeFirstResponder];
//        }else if (textField == _view3){
//            [_view3 resignFirstResponder];
//        }
        self.editFinfishBlock();
        return YES;
    }else{
        if (textField == _tf1) {
            [_tf1 resignFirstResponder];
            [_tf2 becomeFirstResponder];
        }else if (textField == _tf2){
            [_tf2 resignFirstResponder];
            [_tf3 becomeFirstResponder];
        }else if (textField == _tf3){
            [_tf3 resignFirstResponder];
//            if (_tf4.hidden) {
//                if (_tf5.hidden) {
//                    if (_view3.hidden) {
//
//                    }else{
//                        [_view3 becomeFirstResponder];
//                    }
//                }else{
//                    [_tf5 becomeFirstResponder];
//                }
//
//            }else{
//                [_tf4 becomeFirstResponder];
//            }
        }else if (textField == _tf4){
            [_tf4 resignFirstResponder];
            [_tf5 becomeFirstResponder];
        }else if (textField == _tf5){
            [_tf5 resignFirstResponder];
            if (_view3.hidden) {
                
            }else{
                [_view3 becomeFirstResponder];
            }
        }else if (textField == _view3){
            [_view3 resignFirstResponder];
        }
        if (self.editFinfishBlock) {
            self.editFinfishBlock();

        }
        return YES;
    }

}
@end
