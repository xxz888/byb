//
//  JDSeKaWebViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/24.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDSeKaWebViewController.h"
#import "JDEditCompanyTableViewController.h"
#import "JDErWeiMaViewController.h"
#import "WLWebProgressLayer.h"
#import "JDNewAddSpTableViewController.h"
#import "JDAddColorTableViewController.h"
#import <UShareUI/UShareUI.h>
@interface JDSeKaWebViewController ()<UIWebViewDelegate>{
    WLWebProgressLayer *_progressLayer; ///< 网页加载进度条
    NSString * _currentUrl;
}
@property(nonatomic,strong)UIWebView * uuView;

@end

@implementation JDSeKaWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子色卡";
    LoginModel * model = AD_USERDATAARRAY;
    
    _uuView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _uuView.delegate = self;
    _uuView.scalesPageToFit = NO;//自动对页面进行缩放以适应屏幕
    _uuView.scrollView.scrollEnabled = YES;
    _uuView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    _uuView.backgroundColor = self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    NSString * string = [NSString stringWithFormat:@"%@%@/%@",BASEWEB_URL,model.entercode,@"colorcard"];
    _currentUrl = string;
    NSURL * url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_uuView loadRequest:request];
    [self.view addSubview:_uuView];
    _progressLayer = [WLWebProgressLayer new];
    _progressLayer.frame =  CGRectMake(0, 44, self.view.bounds.size.width, 3.0);
    
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
    [self addNavigationItemWithTitles:@[@"分享",@"二维码"] isLeft:NO target:self action:@selector(rightButtonsAction:) tags:@[@9000,@9001]];
}
-(void)rightButtonsAction:(UIButton *)btn{
    if (btn.tag == 9000) {//分享
//        [self showToast:KAIFAING];
        [self UmengWeXinShare];
    }else if (btn.tag == 9001){//二维码
        JDErWeiMaViewController * VC = [[JDErWeiMaViewController alloc]init];
        LoginModel * model = AD_USERDATAARRAY;
        NSString * string = [NSString stringWithFormat:@"%@%@/%@",BASEWEB_URL,model.entercode,@"colorcard"];
        VC.URLString = string;
        [self presentViewController:VC animated:YES completion:nil];
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    NSURL * url = [NSURL URLWithString:_currentUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_uuView loadRequest:request];
    
}
-(void)backBtnClicked{
    if ([self.uuView canGoBack])
    { [self.uuView goBack];
        
    }else{ [self.view resignFirstResponder]; [self.navigationController popViewControllerAnimated:YES]; }
}
//准备加载内容时调用的方法，通过返回值来进行是否加载的设置
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    return [self editParamters:requestString];
//    return YES;
}
-(BOOL)editParamters:(NSString *)requestString{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    
    NSString * getString = [requestString stringByRemovingPercentEncoding];
    if ([requestString containsString:@"fun=qyedit"]) {
        JDEditCompanyTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDEditCompanyTableViewController"];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        return NO;
    }else if ([requestString containsString:@"fun=spedit"]){
        NSString * paramters = [getString componentsSeparatedByString:@"params="][1];
        NSDictionary * paramtersDic = [ADTool parseJSONStringToNSDictionary:paramters];
        [self editSpDetail:paramtersDic];
        return NO;
    }else if ([requestString containsString:@"fun=spysedit"]){
        NSString * paramters = [getString componentsSeparatedByString:@"params="][1];
        NSDictionary * paramtersDic = [ADTool parseJSONStringToNSDictionary:paramters];
        [self editSeKa:paramtersDic];
        return NO;
    }else if ([requestString containsString:@"fun=spysadd"]){
        NSString * paramters = [getString componentsSeparatedByString:@"params="][1];
        NSDictionary * paramtersDic = [ADTool parseJSONStringToNSDictionary:paramters];
        [self addColor:paramtersDic];
        return NO;
    }else if ([requestString containsString:@"fun=pageclose"]){
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }else{
        return YES;
    }
}

//编辑商品
-(void)editSpDetail:(NSDictionary *)dic{
    
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":@([dic[@"spid"] integerValue])}];
    [AD_MANAGER requestShangPinDetailAction:mDic success:^(id object) {
        UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
        JDNewAddSpTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDNewAddSpTableViewController"];
        VC.resultDic  = object[@"data"];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }];
 
}
//编辑色卡
-(void)editSeKa:(NSDictionary *)dic{
    UIStoryboard * stroryBoard2 = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDAddColorTableViewController * VC = [stroryBoard2 instantiateViewControllerWithIdentifier:@"JDAddColorTableViewController"];
    VC.spModel = [AD_SHARE_MANAGER inShangPinIdOutModel:[dic[@"spid"] integerValue]];
    VC.whereCome = YES;
    VC.sh = dic[@"sh"];
    [self.navigationController pushViewController:VC animated:YES];
}
//添加颜色
-(void)addColor:(NSDictionary *)dic{
    UIStoryboard * stroryBoard2 = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDAddColorTableViewController * VC = [stroryBoard2 instantiateViewControllerWithIdentifier:@"JDAddColorTableViewController"];
    VC.spModel = [AD_SHARE_MANAGER inShangPinIdOutModel:[dic[@"spid"] integerValue]];
    [self.navigationController pushViewController:VC animated:YES];
}
//结束加载时调用的方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString * jsString = [NSString stringWithFormat:@"clientCallJS('setClient','1');clientCallJS('setNav','0')"] ;
    [self.uuView stringByEvaluatingJavaScriptFromString:jsString];
    [_progressLayer finishedLoad];
    _currentUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];

}
//友盟微信分享
-(void)UmengWeXinShare{
    [self showShareView];
}
-(void)showShareView{
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        NSString *title = [self.uuView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //创建网页内容对象
    UIImage  * image = [UIImage imageNamed:@"useIcon"];
    
    LoginModel * model = AD_USERDATAARRAY;
    NSString * descr = model.qymc;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
    //设置网页地址
    shareObject.webpageUrl =_currentUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
//                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
        [self showToast:@"分享成功"];
    }
    else{
//        NSMutableString *str = [NSMutableString string];
//        if (error.userInfo) {
//            for (NSString *key in error.userInfo) {
//                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
//            }
//        }
//        if (error) {
//            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
//        }
//        else{
//            result = [NSString stringWithFormat:@"Share fail"];
//        }
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
//                                                    message:result
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
//                                          otherButtonTitles:nil];
//    [alert show];
}
@end
