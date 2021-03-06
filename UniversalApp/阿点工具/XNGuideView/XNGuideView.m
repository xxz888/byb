//
//  XNGuideView.m
//
//  Created by LuohanCC on 15/11/30.
//  Copyright © 2015年 罗函. All rights reserved.
//

#import "XNGuideView.h"
#import "BFKit.h"
#define     GUIDE_FLAGS    @"/guide"

@interface XNGuideView() <UIScrollViewDelegate> {
    int screen_width;
    int screen_height;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSArray *imageArray;
@end

@implementation XNGuideView

+ (void)showGudieView:(NSArray *)imageArray {
    if(imageArray && imageArray.count > 0) {
        NSFileManager *fmanager=[NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], GUIDE_FLAGS];
        BOOL isHasFile = [fmanager fileExistsAtPath:docDir];
        if(!isHasFile) {
            XNGuideView *xnGuideView = [[XNGuideView alloc] init:imageArray];
            [[UIApplication sharedApplication].delegate.window addSubview:xnGuideView];
            [fmanager createFileAtPath:docDir contents:nil attributes:nil];
        }
    }
}

+ (void)skipGuide {
    NSFileManager *fmanager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], GUIDE_FLAGS];
    [fmanager createFileAtPath:docDir contents:nil attributes:nil];
}
- (instancetype)init:(NSArray *)imageArray {
    self = [super init];
    if(self) [self initThisView:imageArray];
    return self;
}

- (void)initThisView:(NSArray *)imageArray {
    _imageArray = imageArray;
    screen_width  = [UIScreen mainScreen].bounds.size.width;
    screen_height = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, screen_width, screen_height);

    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    _scrollView.contentSize=CGSizeMake(screen_width * (_imageArray.count + 1), screen_height);
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.tag=7000;
    _scrollView.delegate = self;
    for (int i = 0; i < imageArray.count; i++) {
        CGRect frame = CGRectMake(i * screen_width, 0, screen_width, screen_height);
        UIImageView *img=[[UIImageView alloc] initWithFrame:frame];
        img.image=[UIImage imageNamed:imageArray[i]];
        [_scrollView addSubview:img];
        //skip
        CGRect skiprect = CGRectMake((i)*screen_width , KScreenHeight - 200, KScreenWidth, 200);
        UIButton *passbtn = [[UIButton alloc] initWithFrame:skiprect];
//        [passbtn createBordersWithColor:[UIColor whiteColor] withCornerRadius:7 andWidth:1];
        [passbtn addTarget:self action:@selector(dismissGuideView) forControlEvents:(UIControlEventTouchUpInside)];
        passbtn.backgroundColor = [UIColor clearColor];
        [passbtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [passbtn setTitleColor:[UIColor whiteColor]];
//        NSString *title = i == imageArray.count -1 ? @"进入" : @"跳过";
//        [passbtn setTitle:title forState:(UIControlStateNormal)];
        if (i == 0 || i ==1) {
            passbtn.userInteractionEnabled = NO;
        }
        [_scrollView addSubview:passbtn];
    }
    [self addSubview:_scrollView];
}

#pragma mark scrollView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= 3 * screen_width){
       [self dismissGuideView];
        self.scrollView.userInteractionEnabled = NO;
    }
}

-(void)dismissGuideView {
    [UIView animateWithDuration:0.6f animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0; //让scrollview 渐变消失
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];


}

@end
