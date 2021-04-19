//
//  WLCaptcheButton.m
//  WLButtonCountingDownDemo
//
//  Created by wayne on 16/1/14.
//  Copyright © 2016年 ZHWAYNE. All rights reserved.
//

#import "WLCaptcheButton.h"
#import "WLButtonCountdownManager.h"

@interface WLCaptcheButton ()

@property (nonatomic, strong) UILabel *overlayLabel;

@end

@implementation WLCaptcheButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"***> %s [%@]", __func__, _identifyKey);
}

- (void)initialize {
    self.clipsToBounds      = YES;
    self.layer.cornerRadius = 4;
    self.opaque             = NO;
    
    [self addSubview:self.overlayLabel];
}

- (UILabel *)overlayLabel {
    if (!_overlayLabel) {
        _overlayLabel                 = [UILabel new];
        _overlayLabel.textColor       = self.titleLabel.textColor;
        _overlayLabel.backgroundColor = self.backgroundColor;
        _overlayLabel.font            = [UIFont systemFontOfSize:12];
        _overlayLabel.textAlignment   = NSTextAlignmentCenter;
        _overlayLabel.alpha           = 0;
        _overlayLabel.opaque           = NO;
    }
    
    return _overlayLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.overlayLabel.frame = self.bounds;
    
    if ([[WLButtonCountdownManager defaultManager] countdownTaskExistWithKey:self.identifyKey task:nil]) {
        [self shouldCountDown];
    }
}


- (void)shouldCountDown {
    
    __weak __typeof(self) weakSelf = self;
    [[WLButtonCountdownManager defaultManager] scheduledCountDownWithKey:self.identifyKey timeInterval:60 countingDown:^(NSTimeInterval leftTimeInterval) {
        __strong __typeof(weakSelf) self = weakSelf;
        
        self.enabled             = NO;
        self.titleLabel.alpha    = 0;
        self.overlayLabel.alpha  = 1;
        [self.overlayLabel setBackgroundColor:self.disabledBackgroundColor ?: self.backgroundColor];
        [self.overlayLabel setTextColor:KWhiteColor];
        self.overlayLabel.text = [NSString stringWithFormat:@"%@ 秒后重试", @(leftTimeInterval)];
        
    } finished:^(NSTimeInterval finalTimeInterval) {
        
        __strong __typeof(weakSelf) self = weakSelf;
        self.enabled             = YES;
//        self.overlayLabel.alpha  = 0;
//        self.titleLabel.alpha    = 1;
//        [self.overlayLabel setBackgroundColor:self.backgroundColor];
        [self.overlayLabel setTextColor:JDRGBAColor(0, 163, 255)];
        self.overlayLabel.text = @"重新获取验证码";

        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.overlayLabel.text attributes:attribtDic]; //赋值
        [attribtStr addAttribute:NSForegroundColorAttributeName value:JDRGBAColor(0, 163, 255) range:NSMakeRange(0,self.overlayLabel.text.length)];

        self.overlayLabel.attributedText = attribtStr;


    }];
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (![[self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside] count]) {
        return;
    }
    
    [super sendAction:action to:target forEvent:event];
}

- (void)fire {
    [self shouldCountDown];
}

@end
