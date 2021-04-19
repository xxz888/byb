//
//  DVXAxisView.m
//  DVLineChart
//
//  Created by Fire on 15/10/16.
//  Copyright © 2015年 DuoLaiDian. All rights reserved.
//

#import "DVXAxisView.h"
#import "DVPlot.h"
#import "UIView+Extension.h"

@interface DVXAxisView ()
/**
 *  图表顶部留白区域
 */
@property (assign, nonatomic) CGFloat topMargin;
/**
 *  记录图表区域的高度
 */
@property (assign, nonatomic) CGFloat chartHeight;
/**
 *  记录坐标轴Label的高度
 */
@property (assign, nonatomic) CGFloat textHeight;
/**
 *  存放坐标轴的label（底部的）
 */
@property (strong, nonatomic) NSMutableArray *titleLabelArray;
/**
 *  记录坐标轴的第一个Label
 */
@property (strong, nonatomic) UILabel *firstLabel;
/**
 *  记录点按钮的集合
 */
@property (strong, nonatomic) NSMutableArray *buttonPointArray;
/**
 *  选中的点
 */
@property (strong, nonatomic) UIButton *selectedPoint;

@property (strong, nonatomic) NSMutableArray *pointButtonArray;
@end

@implementation DVXAxisView

- (NSMutableArray *)pointButtonArray {
    
    if (_pointButtonArray == nil) {
        _pointButtonArray = [NSMutableArray array];
    }
    return _pointButtonArray;
}

- (NSMutableArray *)titleLabelArray {
    if (_titleLabelArray == nil) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.textFont = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)setPointGap:(CGFloat)pointGap {
    _pointGap = pointGap;
    
    [self draw];
    
}

- (NSMutableArray *)buttonPointArray {
	
	if (_buttonPointArray == nil) {
		_buttonPointArray = [NSMutableArray array];
	}
	return _buttonPointArray;
}

- (void)draw {
    
    self.backgroundColor = self.backColor;
    
    // 移除先前存在的所有视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // 移除数组内所有的Label元素
    [self.titleLabelArray removeAllObjects];
    [self.pointButtonArray removeAllObjects];
    
    // 添加坐标轴Label
    for (int i = 0; i < self.xAxisTitleArray.count; i++) {
        NSString *title = self.xAxisTitleArray[i];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = self.textFont;
        label.textColor = self.textColor;
        
        NSDictionary *attr = @{NSFontAttributeName : self.textFont};
        CGSize labelSize = [title sizeWithAttributes:attr];
        
        label.x = (i + 1) * self.pointGap - labelSize.width / 2;
        label.y = self.height - labelSize.height;
        label.width = labelSize.width;
        label.height = labelSize.height;
        
        if (i == 0) {
            self.firstLabel = label;
        }
        
        [self.titleLabelArray addObject:label];
        [self addSubview:label];
    }
    
    // 添加坐标轴
    NSDictionary *attribute = @{NSFontAttributeName : self.textFont};
    CGSize textSize = [@"x" sizeWithAttributes:attribute];
    
    self.textHeight = textSize.height;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.axisColor;
    view.height = 1;
    view.width = self.width + 200;
    view.x = -200;
    view.y = self.height - textSize.height - self.xAxisTextGap;
    [self addSubview:view];
    
    // 计算横向分割线位置
    self.topMargin = 50;
    self.chartHeight = self.height - textSize.height - self.xAxisTextGap - self.topMargin;
    CGFloat separateHeight = 1;
    CGFloat separateMargin = (self.height - self.topMargin - textSize.height - self.xAxisTextGap - self.numberOfYAxisElements * separateHeight) / self.numberOfYAxisElements;
    
    // 画横向分割线
    if (self.isShowSeparate) {
        
        for (int i = 0; i < self.numberOfYAxisElements; i++) {
            
            UIView *separate = [[UIView alloc] init];
            
            separate.x = 0;
            separate.width = self.width;
            separate.height = separateHeight;
            separate.y = view.y - (i + 1) * (separateMargin + separate.height);
            separate.backgroundColor = self.separateColor;
            [self addSubview:separate];
        }
    }
    
    
    // 如果Label的文字有重叠，那么隐藏
    for (int i = 0; i < self.titleLabelArray.count; i++) {
        
        UILabel *label = self.titleLabelArray[i];
        
        CGFloat maxX = CGRectGetMaxX(self.firstLabel.frame);
        
        if (self.isShowTailAndHead == NO) {
            if (i != 0) {
                if ((maxX + 3) > label.x) {
                    label.hidden = YES;
                }else{
                    label.hidden = NO;
                    self.firstLabel = label;
                }
            }else {
                if (self.firstLabel.x < 0) {
                    self.firstLabel.x = 0;
                }
            }
        }else{
            
            if (i > 0 && i < self.titleLabelArray.count - 1) {
                
                label.hidden = YES;
                
            }else if(i == 0){
            
                if (self.firstLabel.x < 0) {
                    self.firstLabel.x = 0;
                }
            
            }else{
                
                if (CGRectGetMaxX(label.frame) > self.width) {
                    
                    label.x = self.width - label.width;
                }
            }
        }
    }
    
    
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect {

    for (DVPlot *plot in self.plots) {
		
		[self drawLineInRect:rect withPlot:plot isPoint:NO];
		
		if (plot.withPoint) {
			
			[self drawLineInRect:rect withPlot:plot isPoint:YES];
			
		}
    }
}

- (void)drawLineInRect:(CGRect)rect withPlot:(DVPlot *)plot isPoint:(BOOL)isPoint {
    
    
    if (isPoint) {  // 画点
        
        for (int i = 0; i < plot.pointArray.count; i++) {
            
            NSNumber *value = plot.pointArray[i];
            NSString *title = [self decimalwithFormat:@"0.00" floatV:value.floatValue];

			
			// 判断title的值，整数或者小数
			if (![self isPureFloat:title]) {
				title = [NSString stringWithFormat:@"%.0f", title.floatValue];
			}
			
			
			if (value.floatValue < 0) {
				value = @(0);
			}
			
            CGPoint center = CGPointMake((i+1)*self.pointGap, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
			
			if (self.yAxisMaxValue * self.chartHeight == 0) {
				center = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
			}
			
            // 添加point处的Label
            if (self.isShowPointLabel) {
                
                [self addLabelWithTitle:title atLocation:center andTag:i];
                
            }
            
//            UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:center radius:3 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//            
//            [plot.pointColor set];
//            
//            CGContextAddPath(context, path.CGPath);
//            
//            CGContextFillPath(context);
			
			UIButton *button = [[UIButton alloc] init];
			button.tag = i;
            [button setBackgroundImage:[self imageWithColor:plot.pointColor] forState:UIControlStateNormal];
			[button setBackgroundImage:[self imageWithColor:plot.pointSelectedColor] forState:UIControlStateSelected];
			button.size = CGSizeMake(6, 6);
			button.center = center;
			
			button.layer.cornerRadius = 3;
			button.layer.masksToBounds = YES;
			
			button.userInteractionEnabled = self.isPointUserInteractionEnabled;
			
			[button addTarget:self action:@selector(pointDidClicked:) forControlEvents:UIControlEventTouchUpInside];
			
            [self.pointButtonArray addObject:button];
            
			if (button.userInteractionEnabled) {
				if (i == 0) {
					[self pointDidClicked:button];
				}
			}
			
			[self addSubview:button];
        }
        
    }else{
        
        if (plot.isChartViewFill) { // 画线，空白处填充
            
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            UIBezierPath *path = [[UIBezierPath alloc] init];
            
            CGPoint start = CGPointMake(self.pointGap, self.height - self.xAxisTextGap - self.textHeight);
            
            [path moveToPoint:start];
            
            for (int i = 0; i < plot.pointArray.count; i++) {
                
                NSNumber *value = plot.pointArray[i];
				
				if (value.floatValue < 0) {
					value = @(0);
				}
				
                CGPoint center = CGPointMake((i+1)*self.pointGap, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
				
				if (self.yAxisMaxValue * self.chartHeight == 0) {
					center = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
				}
				
                [path addLineToPoint:center];
                
            }
            
            CGPoint end = CGPointMake(plot.pointArray.count*self.pointGap, self.height - self.xAxisTextGap - self.textHeight);
            
            [path addLineToPoint:end];
            CGContextSetLineWidth(ctx, 10.0);//线条宽度
            [[plot.lineColor colorWithAlphaComponent:0.08] set];
//            [plot.lineColor set];
            
            
            // 将路径添加到图形上下文
            CGContextAddPath(ctx, path.CGPath);
            // 渲染
            CGContextFillPath(ctx);
//
//
//            [path addLineToPoint:CGPointMake(end.x, self.frame.size.height - 20*2)];
//            [path addLineToPoint:CGPointMake(start.x, self.frame.size.height - 20*2)];
//            [path addLineToPoint:start];
//
//            [self addGradientLayer:path];
            
        }else{  // 画线，只有线，没有填充色
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            UIBezierPath *path = [[UIBezierPath alloc] init];
            
            NSNumber *startValue = plot.pointArray.firstObject;
            
            CGPoint start = CGPointMake(self.pointGap, self.chartHeight - startValue.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
            
            [path moveToPoint:start];
            
            for (int i = 0; i < plot.pointArray.count; i++) {
                
                if (i < plot.pointArray.count - 1) {
                    
                    NSNumber *value = plot.pointArray[i+1];
                    CGPoint center = CGPointMake((i+2)*self.pointGap, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
					
					if (self.yAxisMaxValue * self.chartHeight == 0) {
						center = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
					}
                    [path addLineToPoint:center];
                    
                }
                
            }
            CGContextSetLineWidth(ctx, 3.0);//线条宽度
            [[plot.lineColor colorWithAlphaComponent:1] set];
            // 将路径添加到图形上下文
            CGContextAddPath(ctx, path.CGPath);
            // 渲染
            CGContextStrokePath(ctx);
        }
    }
    
}

/**
 添加渐变图层
 */
- (void)addGradientLayer:(UIBezierPath *)bezier1
{
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.bounds.size.height-20);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[[UIColor blueColor] colorWithAlphaComponent:0.4].CGColor,(__bridge id)[[UIColor blueColor] colorWithAlphaComponent:0.0].CGColor];
    gradientLayer.locations = @[@(0.1f),@(1.0f)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [self.layer insertSublayer:baseLayer atIndex:0];
    
//    CABasicAnimation *anmi1 = [CABasicAnimation animation];
//    anmi1.keyPath = @"bounds";
//    anmi1.duration = _yLabels.count*0.4;
//    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*self.lastPoint.x, self.myScrollView.bounds.size.height-20)];
//    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anmi1.fillMode = kCAFillModeForwards;
//    anmi1.autoreverses = NO;
//    anmi1.removedOnCompletion = NO;
//
//    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
}
- (void)drawLinearGradient:(CGContextRef)context

                      path:(CGPathRef)path

                startColor:(CGColorRef)startColor

                  endColor:(CGColorRef)endColor

{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    
    CGContextAddPath(context, path);
    
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(colorSpace);
    
}

// 添加pointLabel的方法
- (void)addLabelWithTitle:(NSString *)title atLocation:(CGPoint)location andTag:(NSInteger)i {
    title = [title concate:@"¥"];
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundColor:JDRGBAColor(0, 163, 255)];
    ViewRadius(button, 3);
    
    if (self.isPercent) {
        [button setTitle:[NSString stringWithFormat:@"%@%%", title] forState:UIControlStateNormal];
    }else{
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setTitleColor:KWhiteColor forState:UIControlStateNormal];
    button.titleLabel.font = self.textFont;
//    label.font = self.textFont;
//    button.layer.backgroundColor = self.backColor.CGColor;
    button.tag = i;
    button.userInteractionEnabled = self.isPointUserInteractionEnabled;
    
    NSDictionary *attr = @{NSFontAttributeName : self.textFont};
    CGSize buttonSize = [button.currentTitle sizeWithAttributes:attr];
    
    button.width = buttonSize.width;
    button.height = buttonSize.height;
    button.x = location.x - button.width / 2;
    button.y = location.y - button.height - 3;
    [button addTarget:self action:@selector(pointDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

- (void)pointDidClicked:(UIButton *)button {
	
	self.selectedPoint.selected = NO;
    UIButton *pointButton = [self.pointButtonArray objectAtIndex:button.tag];
    pointButton.selected = YES;
    self.selectedPoint = pointButton;
	
	if ([self.delegate respondsToSelector:@selector(xAxisView:didClickButtonAtIndex:)]) {
		[self.delegate xAxisView:self didClickButtonAtIndex:button.tag];
	}
	
}

// 判断是小数还是整数
- (BOOL)isPureFloat:(NSString *)numStr
{
	//    NSScanner* scan = [NSScanner scannerWithString:string];
	//    float val;
	//    return [scan scanFloat:&val] && [scan isAtEnd];
	
	CGFloat num = [numStr floatValue];
	
	int i = num;
	
	CGFloat result = num - i;
	
	// 当不等于0时，是小数
	return result != 0;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



-(void)addBezierLine
{
    //取得起点
//    CGPoint p1 = [[self.pointCenterArr objectAtIndex:0] CGPointValue];
//    UIBezierPath *beizer = [UIBezierPath bezierPath];
//    [beizer moveToPoint:p1];
//    
//    //添加线
//    for (int i = 0;i<self.pointCenterArr.count;i++ )
//    {
//        if (i != 0)
//        {
//            CGPoint prePoint = [[self.pointCenterArr objectAtIndex:i-1] CGPointValue];
//            CGPoint nowPoint = [[self.pointCenterArr objectAtIndex:i] CGPointValue];
//            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
//        }
//    }
//    //显示线
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = beizer.CGPath;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.strokeColor = [UIColor colorWithRed:0/255.0 green:163/255.0  blue:255/255.0  alpha:1].CGColor;
//    shapeLayer.lineWidth = 2;
//    [_lineChartView.layer addSublayer:shapeLayer];
//    //设置动画
//    CABasicAnimation *anmi = [CABasicAnimation animation];
//    anmi.keyPath = @"strokeEnd";
//    anmi.fromValue = [NSNumber numberWithFloat:0];
//    anmi.toValue = [NSNumber numberWithFloat:1.0f];
//    anmi.duration =2.0f;
//    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anmi.autoreverses = NO;
//    [shapeLayer addAnimation:anmi forKey:@"stroke"];
//    
//    
//    //遮罩层相关
//    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
//    bezier1.lineCapStyle = kCGLineCapRound;
//    bezier1.lineJoinStyle = kCGLineJoinMiter;
//    [bezier1 moveToPoint:p1];
//    CGPoint lastPoint;
//    for (int i = 0;i<self.pointCenterArr.count;i++ )
//    {
//        if (i != 0)
//        {
//            CGPoint prePoint = [[self.pointCenterArr objectAtIndex:i-1] CGPointValue];
//            CGPoint nowPoint = [[self.pointCenterArr objectAtIndex:i] CGPointValue];
//            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
//            if (i == self.pointCenterArr.count-1)
//            {
//                lastPoint = nowPoint;
//            }
//        }
//    }
//    //获取最后一个点的X值
//    CGFloat lastPointX = lastPoint.x;
//    CGPoint lastPointX1 = CGPointMake(lastPointX,_lineChartView.bounds.size.height);
//    [bezier1 addLineToPoint:lastPointX1];
//    //回到原点
//    [bezier1 addLineToPoint:CGPointMake(p1.x, _lineChartView.bounds.size.height)];
//    [bezier1 addLineToPoint:p1];
//    
//    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
//    shadeLayer.path = bezier1.CGPath;
//    shadeLayer.fillColor = [UIColor colorWithRed:245/255.0 green:166/255.0  blue:35/255.0  alpha:1].CGColor;
//    [_lineChartView.layer addSublayer:shadeLayer];
//    
//    
//    //渐变图层
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = CGRectMake(0, 0, 0, _lineChartView.bounds.size.height);
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
//    gradientLayer.cornerRadius = 5;
//    gradientLayer.masksToBounds = YES;
//    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:163/255.0  blue:255/255.0  alpha:0.2].CGColor,
//                             (__bridge id)[UIColor colorWithRed:0/255.0 green:163/255.0  blue:255/255.0  alpha:0.05].CGColor];
//    gradientLayer.locations = @[@(0.5f)];
//    
//    CALayer *baseLayer = [CALayer layer];
//    [baseLayer addSublayer:gradientLayer];
//    [baseLayer setMask:shadeLayer];
//    [_lineChartView.layer addSublayer:baseLayer];
//    
//    CABasicAnimation *anmi1 = [CABasicAnimation animation];
//    anmi1.keyPath = @"bounds";
//    anmi1.duration = 2.0f;
//    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2*lastPoint.x, _lineChartView.bounds.size.height)];
//    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anmi1.fillMode = kCAFillModeBoth;
//    anmi1.autoreverses = NO;
//    anmi1.removedOnCompletion = NO;
//    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
}



@end
