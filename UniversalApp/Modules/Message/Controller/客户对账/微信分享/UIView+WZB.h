//
//  UIView+WZB.h
//  UniversalApp
//
//  Created by 小小醉 on 2020/3/13.
//  Copyright © 2020 徐阳. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,WZBBorderDirectionType) {
WZBBorderDirectionTop =0,
WZBBorderDirectionLeft,
WZBBorderDirectionBottom,
WZBBorderDirectionRight
};
@interface UIView (WZB)
 - (void)addBorder:(WZBBorderDirectionType)direction;
- (void)addBorderClear:(WZBBorderDirectionType)direction;
@end

NS_ASSUME_NONNULL_END
