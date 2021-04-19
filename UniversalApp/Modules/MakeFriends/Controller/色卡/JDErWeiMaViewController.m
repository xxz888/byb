//
//  JDErWeiMaViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/24.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDErWeiMaViewController.h"

@interface JDErWeiMaViewController ()

@end

@implementation JDErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self erweimaAction];
}
-(void)erweimaAction{
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData //
    NSString *urlStr = self.URLString;
    NSData * data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码) //
    UIImage *codeImage = [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
    self.erweimaImg.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];//重绘二维码,使其显示清晰
    
    
    
    
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longP)];
    
    self.erweimaImg.userInteractionEnabled = YES; // 打开交互
    
    [ self.erweimaImg addGestureRecognizer:longP];
    

}


- (void)longP{
    
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存图片" preferredStyle:1];
    ipad_alertController;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        UIImageWriteToSavedPhotosAlbum(self.erweimaImg.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),NULL); // 写入相册
        
    }];
    
    //  此处的image1为对应image的imageView 请自行修改
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
    
    
    
    [alertController addAction:action];
    
    [alertController addAction:action1];
    
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}


// 完善回调

-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    
    if(!error){
    
        [self showToast:@"图片保存成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    
        
    }else{
        
        NSLog(@"savefailed");
        
    }
    
}
/** * 根据CIImage生成指定大小的UIImage * * @param image CIImage * @param size 图片宽度 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent); CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale; size_t height = CGRectGetHeight(extent) * scale; CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray(); CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone); CIContext *context = [CIContext contextWithOptions:nil]; CGImageRef bitmapImage = [context createCGImage:image fromRect:extent]; CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone); CGContextScaleCTM(bitmapRef, scale, scale); CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef); CGContextRelease(bitmapRef); CGImageRelease(bitmapImage); return [UIImage imageWithCGImage:scaledImage]; }
    
- (IBAction)chaAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
