//
//  HttpRequest.m
//  YMJFSC
//
//  Created by mazg on 16/1/11.
//  Copyright © 2016年 mazg. All rights reserved.
//

#import "HttpRequest.h"
#import "AFHTTPSessionManager.h"
#import "UIView+Extras.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MaskViewManager.h"
@implementation HttpRequest

+ (void)httpRequestPostPi:(NSString *)pi Parameters:(id)parmeters sucess:(SucessBlock)sucess failure:(FailureBlock)failure{
    kWeakSelf(self);
    // MaskViewManager 实例
    [MaskViewManager sharedMaskViewManager];
    // 显示进度条
    [MaskViewManager show];
    NSString * strURl = [API_ROOT_URL_HTTP_FORMAL stringByAppendingString:pi];
    [[self commonAction] POST:strURl  parameters:parmeters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        // MaskViewManager 实例
        [MaskViewManager sharedMaskViewManager];
        // 显示进度条
        [MaskViewManager hide];
        if ([pi isEqualToString:@"/note/spxs/PrintNotePreview"] ||
            [pi isEqualToString:@"/note/xsth/PrintNotePreview"] ||
            [pi isEqualToString:@"/note/ypxs/PrintNotePreview"] ||
            [pi isEqualToString:@"/note/sk/PrintNotePreview"] ||
            [pi isEqualToString:@"/note/xsdd/PrintNotePreview"] ||
            [pi isEqualToString:@"/note/spck/PrintNotePreview"] ||
            [pi isEqualToString:@"/archives/spda/Print_YsPreview"] ||
             [pi isEqualToString:@"/note/sprk/PrintNotePreview"] ||
             [pi isEqualToString:@"/note/rkth/PrintNotePreview"] ||
            [pi isEqualToString:@"/note/fk/PrintNotePreview"] ||
            [pi isEqualToString:@"/note/spzf/PrintNotePreview"] ||
            [pi isEqualToString:@"/query/Yszk_Zb/Execute_Spys_PrintNoteImage"]
            ) {
            
            UIImage *decodedImage = [UIImage imageWithData: responseObject];
            if (decodedImage) {
                sucess(@{@"img":decodedImage});
            }else{
                [UIView showToast:@"请选择打印模版"];

            }
        }else{
            // convert const
            
            //如果解析器是AFHTTPRequestSerializer类型，则要先把数据转换成字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"pi = 【%@】 result = 【%@】",pi,dic);
            
            if ([dic[@"code"] integerValue] < 0 && ![pi isEqualToString:@"/auth/Signout"]) {
                [UIView showToast:dic[@"msg"]];
                
                if ([dic[@"code"] integerValue] == -11 || [dic[@"code"] integerValue] == -2005 || [dic[@"code"] integerValue] == -2006) {
                    [AD_SHARE_MANAGER outLogin];
                }
                
            }else{
                sucess(dic);
                
            }
        }
        


        //这里判断rid
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        // MaskViewManager 实例
        [MaskViewManager sharedMaskViewManager];
        // 显示进度条
        [MaskViewManager hide];
        [UIView showToast:@"网络请求失败,请稍后重试!"];
        failure(error);
    }];
}

+(AFHTTPSessionManager *)commonAction{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    //允许非权威机构颁发的证书
    manager.securityPolicy.allowInvalidCertificates=YES;
    //也不验证域名一致性
    manager.securityPolicy.validatesDomainName=NO;
    //关闭缓存避免干扰测试
    manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    return manager;
}

#pragma mark ========== 设置公共请求参数 ==========
+(void)setCommonRequestParameters{
    
}



@end
