//
//  GTVerifyCodeView.h
//  codeView
//
//  Created by Thinkive on 2017/11/19.
//  Copyright © 2017年 Thinkive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnFinishedEnterCode)(NSString *code);

@interface GTVerifyCodeView : UIView

- (instancetype)initWithFrame:(CGRect)frame onFinishedEnterCode:(OnFinishedEnterCode)onFinishedEnterCode;

- (void)resetDefaultStatus;

- (void)codeBecomeFirstResponder;

@end
