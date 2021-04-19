
//
//  JDBluePreviewViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/18.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDBluePreviewViewController.h"

@interface JDBluePreviewViewController ()<UIScrollViewDelegate>
//底部srollView
@property (nonatomic, strong) UIScrollView                    *imgScroll;
//显示图片
@property (nonatomic, strong) UIImageView                     *myImageView;
@end

@implementation JDBluePreviewViewController
-(UIScrollView *)imgScroll {
    if (!_imgScroll) {
        _imgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, KScreenHeight - 64 - 49 )];
        _imgScroll.delegate = self;
        //底部不要透明，否则图片缩小的时候会看到被遮住的界面
        _imgScroll.backgroundColor = JDRGBAColor(247, 249, 251);
        //最大级别
        _imgScroll.maximumZoomScale = 5;
        //初始化缩放级别
        self.imgScroll.zoomScale = 1;
        [self.view addSubview:_imgScroll];
    }
    return _imgScroll;
}
-(UIImageView *)myImageView {
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] init];
        _myImageView.backgroundColor = [UIColor clearColor];
        _myImageView.image = self.orderImage;
        [self.imgScroll addSubview:_myImageView];
    }
    return _myImageView;
}
- (void)openImage:(UIImage *)image {
    if (image) {
        // 重置UIImageView的Frame，让图片居中显示
        self.myImageView.frame = CGRectMake(0,0, self.imgScroll.width, self.imgScroll.width * image.size.height/image.size.width);
        [self scrollViewDidZoom:self.imgScroll];
        //设置scrollView的缩小比例
        CGSize maxSize = self.imgScroll.frame.size;
        
        
        
        CGFloat fixelW = CGImageGetWidth(self.orderImage.CGImage);
        
        CGFloat fixelH = CGImageGetHeight(self.orderImage.CGImage);
        
        CGFloat widthRatio = maxSize.width/fixelW;
        CGFloat heightRatio = maxSize.height/fixelH;
        CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
        self.imgScroll.minimumZoomScale = initialZoom;
    }

    
}

// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.myImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                          scrollView.contentSize.height * 0.5 + offsetY);
}



// 设置UIScrollView中要缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.myImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  JDRGBAColor(247, 249, 251);

    self.title = @"打印预览";
    [self openImage:self.orderImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
