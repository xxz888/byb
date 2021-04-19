//
//  UIView+WZB.m
//  UniversalApp
//
//  Created by 小小醉 on 2020/3/13.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "UIView+WZB.h"


@implementation UIView (WZB)
- (void)addBorderClear:(WZBBorderDirectionType)direction{
        UIColor * color = KClearColor;
        CGFloat width = 0;
        CALayer * border = [CALayer layer];

        border.backgroundColor= color.CGColor;

        switch(direction) {

            case WZBBorderDirectionTop:

            {

                border.frame=CGRectMake(0.0f,0.0f,self.bounds.size.width, width);

            }

                break;

            case WZBBorderDirectionLeft:

            {

                border.frame=CGRectMake(0.0f,0.0f, width,self.bounds.size.height);

            }

                break;

            case WZBBorderDirectionBottom:

            {

                border.frame=CGRectMake(0.0f,self.bounds.size.height- width,self.bounds.size.width, width);

            }

                break;

            case WZBBorderDirectionRight:

            {

                border.frame=CGRectMake(self.bounds.size.width- width,0, width,self.bounds.size.height);

            }

                break;



            default:

                break;

        }

        [self.layer addSublayer:border];

    }
- (void)addBorder:(WZBBorderDirectionType)direction{
        UIColor * color = KBlackColor;
        CGFloat width = 1.0f;
        CALayer * border = [CALayer layer];

        border.backgroundColor= color.CGColor;

        switch(direction) {

            case WZBBorderDirectionTop:

            {

                border.frame=CGRectMake(0.0f,0.0f,self.bounds.size.width, width);

            }

                break;

            case WZBBorderDirectionLeft:

            {

                border.frame=CGRectMake(0.0f,0.0f, width,self.bounds.size.height);

            }

                break;

            case WZBBorderDirectionBottom:

            {

                border.frame=CGRectMake(0.0f,self.bounds.size.height- width,self.bounds.size.width, width);

            }

                break;

            case WZBBorderDirectionRight:

            {

                border.frame=CGRectMake(self.bounds.size.width- width,0, width,self.bounds.size.height);

            }

                break;



            default:

                break;

        }

        [self.layer addSublayer:border];

    }
@end
