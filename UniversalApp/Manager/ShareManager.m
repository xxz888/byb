//
//  ShareManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/1.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "ShareManager.h"
#import <UShareUI/UShareUI.h>
#import "JDAddColorModel.h"
#import "JDSalesAffirmViewController.h"
#import "JDBlueToothViewController.h"
#import "JDLongBlueToothTableViewController.h"
#import "LoginViewController.h"
#import "SELUpdateAlert.h"
#import "UIView+Extension.h"
#import "JDBluePreviewViewController.h"
#import "SYCLLocation.h"
#import "JDNewAddShouKuanTableViewController.h"
@interface ShareManager (){
    NSMutableDictionary * _shareDic;
}

@end
@implementation ShareManager

SINGLETON_FOR_CLASS(ShareManager);
-(void)setBtnImgRWithTitleL:(UIButton *)button{
    
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.size.width, 0, button.imageView.size.width)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
}
-(void)showShareView:(NSMutableDictionary *)dic{
    _shareDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    kWeakSelf(self);
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
      
        
        if (_shareDic[@"img"]) {
            [weakself shareImageToPlatformType:platformType];
        }else{
            // 根据获取的platformType确定所选平台进行下一步操作
           [weakself shareWebPageToPlatformType:platformType];
        }
    }];
}


- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"useIcon"];
    [shareObject setShareImage:_shareDic[@"img"]];

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    
    //包含img说明是分享单据
    
    if (_shareDic[@"img"] && [_shareDic[@"img"] length] != 0) {
        //创建网页内容对象
        UIImage  * image = [UIImage imageNamed:@"useIcon"];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareDic[@"order"] descr:@"布业宝,让天下没有难做的生意" thumImage:image];
        
          //  @"data:image/jpeg;base64,"
               //设置网页地址
               shareObject.webpageUrl =[@"http://lpszn.com/buyebaoShare.html?" append:_shareDic[@"img"]];
               //分享消息对象设置分享内容对象
               messageObject.shareObject = shareObject;
        
    }else{
           NSString *title = _shareDic[@"title"];
           //创建网页内容对象
           UIImage  * image = [UIImage imageNamed:@"useIcon"];
           LoginModel * model = AD_USERDATAARRAY;
           NSString * descr = _shareDic[@"subtitle"];
           UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
           //设置网页地址
           shareObject.webpageUrl =_shareDic[@"url"];
           //分享消息对象设置分享内容对象
           messageObject.shareObject = shareObject;
    }
   
    
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
        [UIView showToast:@"分享成功"];
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
// 读取本地JSON文件
-(NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
-(NSMutableDictionary *)requestSameParamtersDic:(NSDictionary *)jsonDataDic{
    LoginModel * model = AD_USERDATAARRAY;
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
    [mDic setValue:@"textilemobile" forKey:@"appid"];
    //当前时间
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    [mDic setValue:timeSp forKey:@"timestamp"];
    NSString * string = [ADTool dicConvertToNSString:jsonDataDic];
    [mDic setValue:string forKey:@"jsondata"];
    [mDic setValue:model.token forKey:@"token"];
    [mDic setValue:model.qybm forKey:@"qybm"];
    [mDic setValue:@"" forKey:@"hardwarekey"];
    
    
    //获取当前设备中应用的版本号  －－－> 工程build的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString * currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [mDic setValue:[currentVersion concate:@"iOS:"] forKey:@"version"];
    long currentVersionLong = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
    [mDic setValue:@(currentVersionLong) forKey:@"versioncode"];

    
    
    NSString *signStr = [ADTool encoingWithDic:mDic];
    [mDic setValue:signStr forKey:@"sign"];
    
    return mDic;
}
-(NSMutableDictionary *)requestUnLoginDic:(NSDictionary *)jsonDataDic{
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
    [mDic setValue:@"textilemobile" forKey:@"appid"];
    //当前时间
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    [mDic setValue:timeSp forKey:@"timestamp"];
    NSString * string = [ADTool dicConvertToNSString:jsonDataDic];
    [mDic setValue:string forKey:@"jsondata"];
    NSString *signStr = [ADTool encoingWithDic:mDic];
    [mDic setValue:signStr forKey:@"sign"];
    return mDic;
}

//传进商品id，out商品名字
-(NSString *)inShangPinIdOutName:(NSInteger )key{
    
    for (JDSelectSpModel * spModel in AD_MANAGER.selectSpPageArray) {
        if (spModel.spid == key) {
            return spModel.spmc;
        }
    }
    return @"";
}
//传进商品id，out商品model
-(JDSelectSpModel *)inShangPinIdOutModel:(NSInteger )key{
    
    for (JDSelectSpModel * spModel in AD_MANAGER.selectSpPageArray) {
        if (spModel.spid == key) {
            return spModel;
        }
    }
    return nil;
}
//传进仓库名字，out仓库ID
-(NSInteger)inCangkuNameOutCangkuId:(NSString *)name{
    
    for (JDSelectCkPageModel * ckModel in AD_MANAGER.selectCkPageArray) {
        if ([ckModel.ckmc isEqualToString:name]) {
            return ckModel.ckid;
        }
    }
    return 0;
}
//传进送货人名字，out送货人ID
-(NSInteger)inSongHuoRenNameOutSonghuoRenId:(NSString *)name{
    for (JDSelectShrModel * shrModel in AD_MANAGER.selectShrPageArray) {
        if ([shrModel.shrmc isEqualToString:name]) {
            return shrModel.shrid;
        }
    }
    return 0;
}
//传进送货人名字，out送货人ID
-(NSInteger)inYeWuYuanNameOutYeWuYuanId:(NSString *)name{
    for (JDSelectYgModel * ygModel in AD_MANAGER.selectYgPageArray) {
        if ([ygModel.ygmc isEqualToString:name]) {
            return ygModel.ygid;
        }
    }
    return 0;
}
//传客户名字,传出客户model
-(JDSelectClientModel *)inKeHuNameOutKeHuId:(NSString *)name{
    
    for (JDSelectClientModel * clientModel in AD_MANAGER.selectKhPageArray) {
        if (CaiGouBOOL || ORDER_ISEQUAl(JiaGongFaHuo)) {
            if ([clientModel.gysmc isEqualToString:name]) {
                return clientModel;
            }
        }else{
            if ([clientModel.khmc isEqualToString:name]) {
                return clientModel;
            }
        }
   
    }
    
    JDSelectClientModel * clientModel1 = [[JDSelectClientModel alloc]init];
    if (CaiGouBOOL) {
        [clientModel1 setValue:name forKey:@"gysmc"];
        [clientModel1 setValue:@(0) forKey:@"gysid"];
    }else{
        [clientModel1 setValue:name forKey:@"khmc"];
        [clientModel1 setValue:@(0) forKey:@"khid"];
    }

    return clientModel1;
}
-(void)getTuiHuo:(NSDictionary *)resultDic{
    NSMutableArray * colorArray = [[NSMutableArray alloc]init];
    //最后一步开始造最难的colorModel
    //第一步先拿到颜色model的数组
    NSMutableArray * spidArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in resultDic[@"tbnote_xsthcbs"]) {
        JDAddColorModel * colorModel = [[JDAddColorModel alloc]init];
        [colorModel setValuesForKeysWithDictionary:dic];
        [colorModel setValue:doubleToNSString([dic[@"xsdj"] doubleValue]) forKey:@"savePrice"];
        [colorModel setValue:NSIntegerToNSString([dic[@"xsps"] integerValue]) forKey:@"savePishu"];
        [colorModel setValue:dic[@"khkh"] forKey:@"saveKhkh"];
        [colorModel setValue:dic[@"bz"] forKey:@"saveBz"];
        [colorModel setValue:doubleToNSString([dic[@"spkc"] doubleValue])  forKey:@"savekongcha"];
        
        [colorModel setValue:dic[@"jldw"] forKey:@"saveDanWei"];
        [colorModel setValue:doubleToNSString([dic[@"xssl"] doubleValue]) forKey:@"saveCount"];
        
        [colorModel setValue:dic[@"fjldw"] forKey:@"saveFuDanWei"];
        [colorModel setValue:doubleToNSString([dic[@"xsfsl"] doubleValue]) forKey:@"saveFuCount"];
        [colorModel setValue:@([dic[@"jjfs"] integerValue]) forKey:@"saveZhuFuTag"];
        
        [colorArray addObject:colorModel];
        [spidArray addObject:NSIntegerToNSString([dic[@"spid"] integerValue])];
    }
    NSSet *set = [NSSet setWithArray:spidArray];
    [spidArray removeAllObjects];
    //得到去除重复颜色的数组
    spidArray = [NSMutableArray arrayWithArray:[set allObjects]];
    //拼接出来以spid为key的数组
    for (NSString * spidStr in spidArray) {
        [AD_MANAGER.sectionArray addObject:@{spidStr:[[NSMutableArray alloc]init]}];
    }
    for (JDAddColorModel * colorModel in colorArray) {
        for (NSInteger i = 0; i < spidArray.count; i++) {
            if (colorModel.spid == [spidArray[i] integerValue]) {
                [AD_MANAGER.sectionArray[i][spidArray[i]] addObject:colorModel];
            }
        }
    }
    //销售单需要另外加一步，合并相同颜色的米数
    //算出相同颜色共有多少匹 多少米 然后再遍历数组，
    NSMutableArray * secCopyArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.sectionArray];
    for (NSInteger i = 0; i<secCopyArray.count; i++) {
        NSDictionary * dic2 = secCopyArray[i];
        //得到key后所有value
        NSArray * arr2 = dic2[[dic2 allKeys][0]];
        //先得到相同颜色的key
        NSMutableArray * ysArray = [[NSMutableArray alloc]init];
        for (JDAddColorModel * colorModel in arr2) {
            [ysArray addObject:colorModel.ys];
        }
        NSSet *set = [NSSet setWithArray:ysArray];
        [ysArray removeAllObjects];
        //得到去除重复颜色的数组
        ysArray = [NSMutableArray arrayWithArray:[set allObjects]];
        
        NSMutableDictionary * dic3 = [[NSMutableDictionary alloc]init];
        for (NSString * ysStr in ysArray) {
            NSMutableArray * psArray = [[NSMutableArray alloc]init];
            for (JDAddColorModel * colorModel in arr2) {
                if ([colorModel.ys isEqualToString:ysStr]) {
                    [psArray addObject:@{@"xssl":colorModel.saveCount,@"xsfsl":colorModel.saveFuCount}];
                }
            }
            [dic3 setValue:psArray forKey:ysStr];
            
        }
        // 去除数组中model重复
        //保留第一个元素，增加psarray
        NSMutableArray * arr4 = [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] copy];
        for (NSInteger k = 0; k < arr4.count; k++) {
            for (NSInteger j = k+1;j < arr4.count; j++) {
                JDAddColorModel  *tempModel = arr4[k];
                JDAddColorModel  *model = arr4[j];
                if ([tempModel.ys isEqualToString:model.ys]) {
                    [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] removeObject:model];
                }
            }
        }
        NSMutableArray * arr3 = AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]];
        
        for ( JDAddColorModel * colorModel3 in arr3) {
            colorModel3.psArray = dic3[colorModel3.ys];
            NSMutableArray * newArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in colorModel3.psArray) {
                [newArray addObject:dic[@"xssl"]];
            }
            
        }
        
        
    }
}
-(void)getCaiGouTuiHuoDan:(NSDictionary *)resultDic{
    NSMutableArray * colorArray = [[NSMutableArray alloc]init];
    //最后一步开始造最难的colorModel
    //第一步先拿到颜色model的数组
    NSMutableArray * spidArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in  resultDic[@"tbnote_rkthcbs"]) {
        JDAddColorModel * colorModel = [[JDAddColorModel alloc]init];
        [colorModel setValuesForKeysWithDictionary:dic];
        [colorModel setValue:doubleToNSString([dic[@"spdj"] doubleValue]) forKey:@"savePrice"];
        [colorModel setValue:NSIntegerToNSString([dic[@"spps"] integerValue]) forKey:@"savePishu"];
        [colorModel setValue:dic[@"bz"] forKey:@"saveBz"];
        [colorModel setValue:doubleToNSString([dic[@"spkc"] doubleValue]) forKey:@"savekongcha"];
        
        [colorModel setValue:dic[@"jldw"] forKey:@"saveDanWei"];
        [colorModel setValue:doubleToNSString([dic[@"spsl"] doubleValue]) forKey:@"saveCount"];
        
        [colorModel setValue:dic[@"fjldw"] forKey:@"saveFuDanWei"];
        [colorModel setValue:doubleToNSString([dic[@"spfsl"] doubleValue]) forKey:@"saveFuCount"];
        
        [colorArray addObject:colorModel];
        [spidArray addObject:NSIntegerToNSString([dic[@"spid"] integerValue])];
    }
    NSSet *set = [NSSet setWithArray:spidArray];
    [spidArray removeAllObjects];
    //得到去除重复颜色的数组
    spidArray = [NSMutableArray arrayWithArray:[set allObjects]];
    //拼接出来以spid为key的数组
    for (NSString * spidStr in spidArray) {
        [AD_MANAGER.sectionArray addObject:@{spidStr:[[NSMutableArray alloc]init]}];
    }
    for (JDAddColorModel * colorModel in colorArray) {
        for (NSInteger i = 0; i < spidArray.count; i++) {
            if (colorModel.spid == [spidArray[i] integerValue]) {
                [AD_MANAGER.sectionArray[i][spidArray[i]] addObject:colorModel];
            }
        }
    }
    //销售单需要另外加一步，合并相同颜色的米数
    //算出相同颜色共有多少匹 多少米 然后再遍历数组，
    NSMutableArray * secCopyArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.sectionArray];
    for (NSInteger i = 0; i<secCopyArray.count; i++) {
        NSDictionary * dic2 = secCopyArray[i];
        //得到key后所有value
        NSArray * arr2 = dic2[[dic2 allKeys][0]];
        //先得到相同颜色的key
        NSMutableArray * ysArray = [[NSMutableArray alloc]init];
        for (JDAddColorModel * colorModel in arr2) {
            [ysArray addObject:colorModel.ys];
        }
        NSSet *set = [NSSet setWithArray:ysArray];
        [ysArray removeAllObjects];
        //得到去除重复颜色的数组
        ysArray = [NSMutableArray arrayWithArray:[set allObjects]];
        
        NSMutableDictionary * dic3 = [[NSMutableDictionary alloc]init];
        for (NSString * ysStr in ysArray) {
            NSMutableArray * psArray = [[NSMutableArray alloc]init];
            for (JDAddColorModel * colorModel in arr2) {
                if ([colorModel.ys isEqualToString:ysStr]) {
                    [psArray addObject:@{@"xssl":colorModel.saveCount,@"xsfsl":colorModel.saveFuCount}];
                }
            }
            [dic3 setValue:psArray forKey:ysStr];
            
        }
        // 去除数组中model重复
        //保留第一个元素，增加psarray
        NSMutableArray * arr4 = [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] copy];
        for (NSInteger k = 0; k < arr4.count; k++) {
            for (NSInteger j = k+1;j < arr4.count; j++) {
                JDAddColorModel  *tempModel = arr4[k];
                JDAddColorModel  *model = arr4[j];
                if ([tempModel.ys isEqualToString:model.ys]) {
                    [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] removeObject:model];
                }
            }
        }
        NSMutableArray * arr3 = AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]];
        
        for ( JDAddColorModel * colorModel3 in arr3) {
            colorModel3.psArray = dic3[colorModel3.ys];
            NSMutableArray * newArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in colorModel3.psArray) {
                [newArray addObject:dic[@"xssl"]];
            }
            
        }
        
        
    }
}
//退货单进到草稿的通用方法
-(void)commonTuiHuoDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController{
    //如果是草稿，就要造数据   造3个数据 1、clientModel 2 、coloModel 3、钱数
    kWeakSelf(self);
    REMOVE_ALL_CACHE;
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":dic[@"djhm"]}];
    [AD_MANAGER requestTuiHuoCaoGaoDetail:mDic1 success:^(id object) {//草稿请求
        NSDictionary * resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
        [AD_MANAGER requestSelectSpPage:mDic2 success:^(id str) {//商品信息数组请求
            [AD_MANAGER requestSelectKhPage:mDic success:^(id str) {//客户信息请求
                [weakself getTuiHuo:resultDic];
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
                JDSalesAffirmViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesAffirmViewController"];
                [AD_MANAGER.affrimDic removeAllObjects];
                [AD_MANAGER.affrimDic setValue:resultDic[@"khmc"] forKey:@"khmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"shdz"] forKey:@"shdz"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ckmc"] forKey:@"ckmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"shrmc"] forKey:@"shrmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ywymc"] forKey:@"ywymc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"djbz"] forKey:@"djbz"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"rzrq"] forKey:@"rzrq"];
                double allPrice = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_xsthcbs"]) {
                    allPrice += [dic[@"xsje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(allPrice) forKey:@"allPrice"];
 
                [AD_MANAGER.affrimDic setValue:@"YES" forKey:@"where"];
                AD_MANAGER.caoGaoDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
                VC.hidesBottomBarWhenPushed = YES;
                [navigationController pushViewController:VC animated:YES];
            }];
        }];
    }];
}
//样品单进到草稿的通用方法
-(void)commonYangPinDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController{
    //如果是草稿，就要造数据   造3个数据 1、clientModel 2 、coloModel 3、钱数
    REMOVE_ALL_CACHE;
    AD_MANAGER.orderType = YangPinDan;
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":dic[@"djhm"]}];
    [AD_MANAGER requestYangPinDanDetail:mDic1 success:^(id object) {//草稿请求
        NSDictionary * resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
        [AD_MANAGER requestSelectSpPage:mDic2 success:^(id str) {//商品信息数组请求
            [AD_MANAGER requestSelectKhPage:mDic success:^(id str) {//客户信息请求
                NSMutableArray * colorArray = [[NSMutableArray alloc]init];
                //最后一步开始造最难的colorModel
                //第一步先拿到颜色model的数组
                NSMutableArray * spidArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in resultDic[@"tbnote_ypxscbs"]) {
                    JDAddColorModel * colorModel = [[JDAddColorModel alloc]init];
                    [colorModel setValuesForKeysWithDictionary:dic];
                    [colorModel setValue:doubleToNSString([dic[@"xsdj"] doubleValue]) forKey:@"savePrice"];
                    [colorModel setValue:NSIntegerToNSString([dic[@"xsdj"] integerValue]) forKey:@"savePishu"];
                    [colorModel setValue:doubleToNSString([dic[@"xssl"] doubleValue]) forKey:@"saveCount"];
                    [colorModel setValue:dic[@"khkh"] forKey:@"saveKhkh"];
                    [colorModel setValue:dic[@"bz"] forKey:@"saveBz"];
                    [colorModel setValue:doubleToNSString([dic[@"mpkc"] doubleValue])  forKey:@"savekongcha"];
                    [colorModel setValue:dic[@"jldw"] forKey:@"saveDanWei"];
                    [colorModel setValue:dic[@"fjldw"] forKey:@"saveFuDanWei"];
                    [colorModel setValue:@([dic[@"jjfs"] integerValue]) forKey:@"saveZhuFuTag"];

                    [colorArray addObject:colorModel];
                    [spidArray addObject:NSIntegerToNSString([dic[@"spid"] integerValue])];
                }
                NSSet *set = [NSSet setWithArray:spidArray];
                [spidArray removeAllObjects];
                //得到去除重复颜色的数组
                spidArray = [NSMutableArray arrayWithArray:[set allObjects]];
                //拼接出来以spid为key的数组
                for (NSString * spidStr in spidArray) {
                    [AD_MANAGER.sectionArray addObject:@{spidStr:[[NSMutableArray alloc]init]}];
                }
                for (JDAddColorModel * colorModel in colorArray) {
                    for (NSInteger i = 0; i < spidArray.count; i++) {
                        if (colorModel.spid == [spidArray[i] integerValue]) {
                            [AD_MANAGER.sectionArray[i][spidArray[i]] addObject:colorModel];
                        }
                    }
                }
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
                JDSalesAffirmViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesAffirmViewController"];
                [AD_MANAGER.affrimDic removeAllObjects];
                [AD_MANAGER.affrimDic setValue:resultDic[@"khmc"] forKey:@"khmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"shdz"] forKey:@"shdz"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ckmc"] forKey:@"ckmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"shrmc"] forKey:@"shrmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ywymc"] forKey:@"ywymc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"djbz"] forKey:@"djbz"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"rzrq"] forKey:@"rzrq"];
                double allPrice = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_ypxscbs"]) {
                    allPrice += [dic[@"xsje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(allPrice) forKey:@"allPrice"];
                double dingjin = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_ypxscb_sks"]) {
                    dingjin += [dic[@"skje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(dingjin) forKey:@"dingjin"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"tbnote_ypxscb_sks"] forKey:@"dingjinArray"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"tbnote_ypxscb_zks"] forKey:@"zhekouArray"];
                [AD_MANAGER.affrimDic setValue:@"YES" forKey:@"where"];
                AD_MANAGER.caoGaoDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
                VC.hidesBottomBarWhenPushed = YES;
                [navigationController pushViewController:VC animated:YES];
            }];
        }];
    }];
}
//预订单进到草稿的通用方法
-(void)commonYuDingDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController{
    //如果是草稿，就要造数据   造3个数据 1、clientModel 2 、coloModel 3、钱数
    REMOVE_ALL_CACHE;
    AD_MANAGER.orderType = YuDingDan;
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":dic[@"djhm"]}];
    [AD_MANAGER requestxsddShowNote:mDic1 success:^(id object) {//草稿请求
        NSDictionary * resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
        [AD_MANAGER requestSelectSpPage:mDic2 success:^(id str) {//商品信息数组请求
            [AD_MANAGER requestSelectKhPage:mDic success:^(id str) {//客户信息请求
                
                
                NSMutableArray * colorArray = [[NSMutableArray alloc]init];
                //最后一步开始造最难的colorModel
                //第一步先拿到颜色model的数组
                NSMutableArray * spidArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in resultDic[@"tbnote_xsddcbs"]) {
                    JDAddColorModel * colorModel = [[JDAddColorModel alloc]init];
                    [colorModel setValuesForKeysWithDictionary:dic];
                    [colorModel setValue:doubleToNSString([dic[@"xsdj"] doubleValue]) forKey:@"savePrice"];
                    [colorModel setValue:NSIntegerToNSString([dic[@"xsps"] integerValue]) forKey:@"savePishu"];
                    [colorModel setValue:doubleToNSString([dic[@"xssl"] doubleValue]) forKey:@"saveCount"];
                    [colorModel setValue:dic[@"khkh"] forKey:@"saveKhkh"];
                    [colorModel setValue:dic[@"bz"] forKey:@"saveBz"];
                    [colorModel setValue:doubleToNSString([dic[@"mpkc"] doubleValue]) forKey:@"savekongcha"];
                    [colorModel setValue:dic[@"jldw"] forKey:@"saveDanWei"];
                    [colorModel setValue:dic[@"fjldw"] forKey:@"saveFuDanWei"];
                    [colorModel setValue:@([dic[@"jjfs"] integerValue]) forKey:@"saveZhuFuTag"];

                    [colorArray addObject:colorModel];
                    [spidArray addObject:NSIntegerToNSString([dic[@"spid"] integerValue])];
                }
                NSSet *set = [NSSet setWithArray:spidArray];
                [spidArray removeAllObjects];
                //得到去除重复颜色的数组
                spidArray = [NSMutableArray arrayWithArray:[set allObjects]];
                //拼接出来以spid为key的数组
                for (NSString * spidStr in spidArray) {
                    [AD_MANAGER.sectionArray addObject:@{spidStr:[[NSMutableArray alloc]init]}];
                }
                for (JDAddColorModel * colorModel in colorArray) {
                    for (NSInteger i = 0; i < spidArray.count; i++) {
                        if (colorModel.spid == [spidArray[i] integerValue]) {
                            [AD_MANAGER.sectionArray[i][spidArray[i]] addObject:colorModel];
                        }
                    }
                }
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
                JDSalesAffirmViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesAffirmViewController"];
                
                [AD_MANAGER.affrimDic removeAllObjects];
                
                [AD_MANAGER.affrimDic setValue:resultDic[@"khmc"] forKey:@"khmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"shdz"] forKey:@"shdz"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ckmc"] forKey:@"ckmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"shrmc"] forKey:@"shrmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ywymc"] forKey:@"ywymc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"djbz"] forKey:@"djbz"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"rzrq"] forKey:@"rzrq"];
                
                
                double allPrice = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_xsddcbs"]) {
                    allPrice += [dic[@"xsje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(allPrice) forKey:@"allPrice"];
                
                double dingjin = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_xsddcb_sks"]) {
                    dingjin += [dic[@"skje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(dingjin) forKey:@"dingjin"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"tbnote_xsddcb_sks"] forKey:@"dingjinArray"];
                [AD_MANAGER.affrimDic setValue:@"YES" forKey:@"where"];

                AD_MANAGER.caoGaoDic =[NSMutableDictionary dictionaryWithDictionary:resultDic];
                VC.hidesBottomBarWhenPushed = YES;
                [navigationController pushViewController:VC animated:YES];
            }];
        }];
    }];
}
//销售单进到草稿的通用方法
-(void)commonXiaoShouDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController{
    //如果是草稿，就要造数据   造3个数据 1、clientModel 2 、coloModel 3、钱数
    REMOVE_ALL_CACHE;
    AD_MANAGER.orderType = XiaoShouDan;
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":dic[@"djhm"]}];
    [AD_MANAGER requestXiaoShouDanCaoGaoDetail:mDic1 success:^(id object) {//草稿请求
        NSDictionary * resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
        NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
        [AD_MANAGER requestSelectSpPage:mDic2 success:^(id str) {//商品信息数组请求
            [AD_MANAGER requestSelectKhPage:mDic success:^(id str) {//客户信息请求
                
                
                NSMutableArray * colorArray = [[NSMutableArray alloc]init];
                //最后一步开始造最难的colorModel
                //第一步先拿到颜色model的数组
                NSMutableArray * spidArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in resultDic[@"tbnote_spxscbs"]) {
                    JDAddColorModel * colorModel = [[JDAddColorModel alloc]init];
                    [colorModel setValuesForKeysWithDictionary:dic];
                    [colorModel setValue:doubleToNSString([dic[@"xsdj"] doubleValue]) forKey:@"savePrice"];
                    [colorModel setValue:NSIntegerToNSString([dic[@"xsps"] integerValue]) forKey:@"savePishu"];
                    [colorModel setValue:dic[@"khkh"] forKey:@"saveKhkh"];
                    [colorModel setValue:dic[@"bz"] forKey:@"saveBz"];
                    [colorModel setValue:doubleToNSString([dic[@"spkc"] doubleValue]) forKey:@"savekongcha"];
                    
                    [colorModel setValue:dic[@"jldw"] forKey:@"saveDanWei"];
                    [colorModel setValue:doubleToNSString([dic[@"xssl"] doubleValue]) forKey:@"saveCount"];
                    
                    [colorModel setValue:dic[@"fjldw"] forKey:@"saveFuDanWei"];
                    [colorModel setValue:doubleToNSString([dic[@"xsfsl"] doubleValue]) forKey:@"saveFuCount"];
                    
                    [colorArray addObject:colorModel];
                    [spidArray addObject:NSIntegerToNSString([dic[@"spid"] integerValue])];
                }
                NSSet *set = [NSSet setWithArray:spidArray];
                [spidArray removeAllObjects];
                //得到去除重复颜色的数组
                spidArray = [NSMutableArray arrayWithArray:[set allObjects]];
                //拼接出来以spid为key的数组
                for (NSString * spidStr in spidArray) {
                    [AD_MANAGER.sectionArray addObject:@{spidStr:[[NSMutableArray alloc]init]}];
                }
                for (JDAddColorModel * colorModel in colorArray) {
                    for (NSInteger i = 0; i < spidArray.count; i++) {
                        if (colorModel.spid == [spidArray[i] integerValue]) {
                            [AD_MANAGER.sectionArray[i][spidArray[i]] addObject:colorModel];
                        }
                    }
                }
                //销售单需要另外加一步，合并相同颜色的米数
                //算出相同颜色共有多少匹 多少米 然后再遍历数组，
                NSMutableArray * secCopyArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.sectionArray];
                for (NSInteger i = 0; i<secCopyArray.count; i++) {
                    NSDictionary * dic2 = secCopyArray[i];
                    //得到key后所有value
                    NSArray * arr2 = dic2[[dic2 allKeys][0]];
                    //先得到相同颜色的key
                    NSMutableArray * ysArray = [[NSMutableArray alloc]init];
                    for (JDAddColorModel * colorModel in arr2) {
                        [ysArray addObject:colorModel.ys];
                    }
                    NSSet *set = [NSSet setWithArray:ysArray];
                    [ysArray removeAllObjects];
                    //得到去除重复颜色的数组
                    ysArray = [NSMutableArray arrayWithArray:[set allObjects]];
                    
                    NSMutableDictionary * dic3 = [[NSMutableDictionary alloc]init];
                    for (NSString * ysStr in ysArray) {
                        NSMutableArray * psArray = [[NSMutableArray alloc]init];
                        for (JDAddColorModel * colorModel in arr2) {
                            if ([colorModel.ys isEqualToString:ysStr]) {
                                [psArray addObject:@{@"xssl":colorModel.saveCount,@"xsfsl":colorModel.saveFuCount}];
                            }
                        }
                        [dic3 setValue:psArray forKey:ysStr];
                        
                    }
                    // 去除数组中model重复
                    //保留第一个元素，增加psarray
                    NSMutableArray * arr4 = [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] copy];
                    for (NSInteger k = 0; k < arr4.count; k++) {
                        for (NSInteger j = k+1;j < arr4.count; j++) {
                            JDAddColorModel  *tempModel = arr4[k];
                            JDAddColorModel  *model = arr4[j];
                            if ([tempModel.ys isEqualToString:model.ys]) {
                                [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] removeObject:model];
                            }
                        }
                    }
                    NSMutableArray * arr3 = AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]];
                    
                    for ( JDAddColorModel * colorModel3 in arr3) {
                        colorModel3.psArray = dic3[colorModel3.ys];
                        NSMutableArray * newArray = [[NSMutableArray alloc]init];
                        for (NSDictionary * dic in colorModel3.psArray) {
                            [newArray addObject:dic[@"xssl"]];
                        }
        
                    }
                    
                    
                }
                
                
                
                
                
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
                JDSalesAffirmViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesAffirmViewController"];
                [AD_MANAGER.affrimDic removeAllObjects];
                
                [AD_MANAGER.affrimDic setValue:resultDic[@"khmc"] forKey:@"khmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"shdz"] forKey:@"shdz"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ckmc"] forKey:@"ckmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"shrmc"] forKey:@"shrmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ywymc"] forKey:@"ywymc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"djbz"] forKey:@"djbz"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"rzrq"] forKey:@"rzrq"];
                double allPrice = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_spxscbs"]) {
                    allPrice += [dic[@"xsje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(allPrice) forKey:@"allPrice"];
                double dingjin = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_spxscb_sks"]) {
                    dingjin += [dic[@"skje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(dingjin) forKey:@"dingjin"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"tbnote_spxscb_sks"] forKey:@"dingjinArray"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"tbnote_spxscb_zks"] forKey:@"zhekouArray"];
                [AD_MANAGER.affrimDic setValue:@"YES" forKey:@"where"];
                AD_MANAGER.caoGaoDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
                VC.hidesBottomBarWhenPushed = YES;
                [navigationController pushViewController:VC animated:YES];
            }];
        }];    }];
   
}
//采购入库单进到草稿的通用方法
-(void)commonCaiGouRuKuDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController{
    //如果是草稿，就要造数据   造3个数据 1、clientModel 2 、coloModel 3、钱数
    REMOVE_ALL_CACHE;
    AD_MANAGER.orderType = CaiGouRuKuDan;
    kWeakSelf(self);
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":dic[@"djhm"]}];
    [AD_MANAGER requestCaiGouRuKuShowAction:mDic1 success:^(id object) {//草稿请求
        NSDictionary * resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
        NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
        NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
        [AD_MANAGER requestGongYingShangListAction:mDic2 success:^(id str) {//商品信息数组请求
            [AD_MANAGER requestSelectKhPage:mDic success:^(id str) {//客户信息请求
                [weakself getCaiGouRuKuList:resultDic];
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
                JDSalesAffirmViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesAffirmViewController"];
                [AD_MANAGER.affrimDic removeAllObjects];
                
                [AD_MANAGER.affrimDic setValue:resultDic[@"gysmc"] forKey:@"gysmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ckmc"] forKey:@"ckmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"jsrmc"] forKey:@"jsrmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"djbz"] forKey:@"djbz"];
                double allPrice = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_sprkcbs"]) {
                    allPrice += [dic[@"spje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(allPrice) forKey:@"allPrice"];
                double dingjin = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_sprkcb_fks"]) {
                    dingjin += [dic[@"fkje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(dingjin) forKey:@"dingjin"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"tbnote_sprkcb_fks"] forKey:@"dingjinArray"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"tbnote_sprkcb_zks"] forKey:@"zhekouArray"];
                [AD_MANAGER.affrimDic setValue:@"YES" forKey:@"where"];
                AD_MANAGER.caoGaoDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
                VC.hidesBottomBarWhenPushed = YES;
                [navigationController pushViewController:VC animated:YES];
            }];
        }];    }];
    
}
//采购退货单进到草稿的通用方法
-(void)commonCaiGouTuiHuoDanTiaozhuan:(NSDictionary *)dic nav:(UINavigationController *)navigationController{
    //如果是草稿，就要造数据   造3个数据 1、clientModel 2 、coloModel 3、钱数
    REMOVE_ALL_CACHE;
    AD_MANAGER.orderType = CaiGouTuiHuoDan;
    kWeakSelf(self);
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"noteno":dic[@"djhm"]}];
    [AD_MANAGER requestCaiGouTuiHuoShowAction:mDic1 success:^(id object) {//草稿请求
        NSDictionary * resultDic = [ADTool parseJSONStringToNSDictionary:object[@"data"]];
        NSMutableDictionary * mDic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@"1",@"pagesize":@"500"}];
        [AD_MANAGER requestGongYingShangListAction:mDic2 success:^(id str) {//商品信息数组请求
                [weakself getCaiGouTuiHuoDan:resultDic];
                UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"FirstVC" bundle:nil];
                JDSalesAffirmViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDSalesAffirmViewController"];
                [AD_MANAGER.affrimDic removeAllObjects];
                
                [AD_MANAGER.affrimDic setValue:resultDic[@"gysmc"] forKey:@"gysmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"ckmc"] forKey:@"ckmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"jsrmc"] forKey:@"jsrmc"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"djbz"] forKey:@"djbz"];
                double allPrice = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_sprkcbs"]) {
                    allPrice += [dic[@"spje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(allPrice) forKey:@"allPrice"];
                double dingjin = 0;
                for (NSDictionary * dic in resultDic[@"tbnote_sprkcb_fks"]) {
                    dingjin += [dic[@"fkje"] doubleValue];
                }
                [AD_MANAGER.affrimDic setValue:doubleToNSString(dingjin) forKey:@"dingjin"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"tbnote_sprkcb_fks"] forKey:@"dingjinArray"];
                [AD_MANAGER.affrimDic setValue:resultDic[@"tbnote_sprkcb_zks"] forKey:@"zhekouArray"];
                [AD_MANAGER.affrimDic setValue:@"YES" forKey:@"where"];
                AD_MANAGER.caoGaoDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
                VC.hidesBottomBarWhenPushed = YES;
                [navigationController pushViewController:VC animated:YES];
        }];    }];
    
}

-(void)getCaiGouRuKuList:(NSDictionary *)resultDic{

    
    
    
    NSMutableArray * colorArray = [[NSMutableArray alloc]init];
    //最后一步开始造最难的colorModel
    //第一步先拿到颜色model的数组
    NSMutableArray * spidArray = [[NSMutableArray alloc]init];
    NSMutableArray * tbnote_sprkcb_mxs = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in resultDic[@"tbnote_sprkcbs"]) {
        for (NSDictionary * xsslDic in dic[@"tbnote_sprkcb_mxs"]) {
            JDAddColorModel * colorModel = [[JDAddColorModel alloc]init];
            [colorModel setValuesForKeysWithDictionary:dic];
            [colorModel setValue:doubleToNSString([dic[@"spdj"] doubleValue]) forKey:@"savePrice"];
            [colorModel setValue:NSIntegerToNSString([dic[@"spps"] integerValue]) forKey:@"savePishu"];
            [colorModel setValue:dic[@"bz"] forKey:@"saveBz"];
            [colorModel setValue:doubleToNSString([dic[@"spkc"] doubleValue]) forKey:@"savekongcha"];
            
            [colorModel setValue:dic[@"jldw"] forKey:@"saveDanWei"];
            
            [colorModel setValue:dic[@"fjldw"] forKey:@"saveFuDanWei"];
            
            
            
            [colorModel setValue:doubleToNSString([xsslDic[@"spsl"] doubleValue]) forKey:@"saveCount"];
            [colorModel setValue:doubleToNSString([xsslDic[@"spfsl"] doubleValue]) forKey:@"saveFuCount"];
            
            
            [colorArray addObject:colorModel];
            [spidArray addObject:NSIntegerToNSString([dic[@"spid"] integerValue])];
        }
 
    }
    NSSet *set = [NSSet setWithArray:spidArray];
    [spidArray removeAllObjects];
    //得到去除重复颜色的数组
    spidArray = [NSMutableArray arrayWithArray:[set allObjects]];
    //拼接出来以spid为key的数组
    for (NSString * spidStr in spidArray) {
        [AD_MANAGER.sectionArray addObject:@{spidStr:[[NSMutableArray alloc]init]}];
    }
    for (JDAddColorModel * colorModel in colorArray) {
        for (NSInteger i = 0; i < spidArray.count; i++) {
            if (colorModel.spid == [spidArray[i] integerValue]) {
                [AD_MANAGER.sectionArray[i][spidArray[i]] addObject:colorModel];
            }
        }
    }
    //销售单需要另外加一步，合并相同颜色的米数
    //算出相同颜色共有多少匹 多少米 然后再遍历数组，
    NSMutableArray * secCopyArray = [[NSMutableArray alloc]initWithArray:AD_MANAGER.sectionArray];
    for (NSInteger i = 0; i<secCopyArray.count; i++) {
        NSDictionary * dic2 = secCopyArray[i];
        //得到key后所有value
        NSArray * arr2 = dic2[[dic2 allKeys][0]];
        //先得到相同颜色的key
        NSMutableArray * ysArray = [[NSMutableArray alloc]init];
        for (JDAddColorModel * colorModel in arr2) {
            [ysArray addObject:colorModel.ys];
        }
        NSSet *set = [NSSet setWithArray:ysArray];
        [ysArray removeAllObjects];
        //得到去除重复颜色的数组
        ysArray = [NSMutableArray arrayWithArray:[set allObjects]];
        
        NSMutableDictionary * dic3 = [[NSMutableDictionary alloc]init];
        for (NSString * ysStr in ysArray) {
            NSMutableArray * psArray = [[NSMutableArray alloc]init];
            for (JDAddColorModel * colorModel in arr2) {
                if ([colorModel.ys isEqualToString:ysStr]) {
                    [psArray addObject:@{@"xssl":colorModel.saveCount,@"xsfsl":colorModel.saveFuCount}];
                }
            }
            [dic3 setValue:psArray forKey:ysStr];
            
        }
        // 去除数组中model重复
        //保留第一个元素，增加psarray
        NSMutableArray * arr4 = [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] copy];
        for (NSInteger k = 0; k < arr4.count; k++) {
            for (NSInteger j = k+1;j < arr4.count; j++) {
                JDAddColorModel  *tempModel = arr4[k];
                JDAddColorModel  *model = arr4[j];
                if ([tempModel.ys isEqualToString:model.ys]) {
                    [AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]] removeObject:model];
                }
            }
        }
        NSMutableArray * arr3 = AD_MANAGER.sectionArray[i][[AD_MANAGER.sectionArray[i] allKeys][0]];
        
        for ( JDAddColorModel * colorModel3 in arr3) {
            colorModel3.psArray = dic3[colorModel3.ys];
            NSMutableArray * newArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in colorModel3.psArray) {
                [newArray addObject:dic[@"xssl"]];
            }
            
        }
        
        
    }
}

-(NSMutableArray *)getSectionAndRowCount{
    NSMutableArray * allColorModelArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0 ; i < AD_MANAGER.sectionArray.count; i++) {
        NSString * key = [AD_MANAGER.sectionArray[i] allKeys][0];
        NSArray * countArr = AD_MANAGER.sectionArray[i][key];
        for (JDAddColorModel * colorModel in countArr) {
            [allColorModelArray addObject:colorModel];
        }
    }
    return allColorModelArray;
}

//组头的方法
-(NSMutableArray *)getSectionTitleArray{
    //先得到所有的头，去除相同的文字
    NSMutableArray * titleArray = [[NSMutableArray alloc]init];
    for (JDAddColorModel * colorModel in [AD_SHARE_MANAGER getSectionAndRowCount]) {
        [titleArray addObject:@(colorModel.spid)];
    }
    
    
    NSMutableArray * sameIndexArray = [[NSMutableArray alloc]init];
    NSSet *set = [NSSet setWithArray:titleArray];
    [sameIndexArray addObjectsFromArray:[set allObjects]];
    
    //重新遍历数组，求的相同的坐标
    NSMutableArray * removeSameIndexArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i< titleArray.count; i++) {
        for (NSInteger k = 0; k < sameIndexArray.count; k++) {
            
            BOOL have = NO;
            for (NSDictionary * dic in removeSameIndexArray) {
                if ([[dic allKeys] containsObject:titleArray[i]]) {
                    have = YES;
                    continue;
                }else{
                    have = NO;
                }
            }
            if (!have) {
                if ([titleArray[i] integerValue] == [sameIndexArray[k] integerValue]) {
                    [removeSameIndexArray addObject:@{titleArray[i]:@(i)}];
                }
            }
            
        }
    }
    
    //得到index
    NSMutableArray * indexArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in removeSameIndexArray) {
        for (NSString * string in [dic allKeys]) {
            [indexArray addObject:dic[string]];
        }
    }
    return indexArray;
}
//蓝牙打印公用方法
-(void)blueToothCommonActionNav:(UINavigationController *)navigationController{
    if (!AD_MANAGER.noteno) {
        return;
    }
    [AD_MANAGER.printWay removeAllObjects];
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"OtherVC" bundle:nil];
    JDBlueToothViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDBlueToothViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:VC animated:YES];
}

//远程蓝牙打印公用方法
-(void)longBlueToothCommonActionNav:(UINavigationController *)navigationController{
    if (!AD_MANAGER.noteno) {
        return;
    }
    [AD_MANAGER.printWay removeAllObjects];
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"OtherVC" bundle:nil];
    JDLongBlueToothTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDLongBlueToothTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:VC animated:YES];
}
//退出登录
-(void)outLogin{
    [kUserDefaults removeObjectForKey:AUTO_LOGIN];
    REMOVE_ALL_CACHE;
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"LoginViewController" bundle:nil];
    LoginViewController * loginVC = [stroryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginNavi;
}
-(void)MLShadow:(UIView *)shadowView;
{
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    shadowView.layer.shadowOffset = CGSizeMake(5, 5);
    
    shadowView.layer.shadowOpacity = 0.2;
    
    shadowView.layer.shadowRadius = 8.0;
    
    shadowView.layer.cornerRadius = 8.0;
    
    shadowView.clipsToBounds = NO;
    
}
- (void)updateApp{
    kWeakSelf(self);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", UPDATE_APP_URL, UPDATE_App_ID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                NSLog(@"%@", error.description);
                return;
            }
            NSArray *resultArray = [appInfoDict objectForKey:@"results"];
            if (![resultArray count]) {
                NSLog(@"error : resultArray == nil");
                return;
            }
            NSDictionary *infoDict = [resultArray objectAtIndex:0];
            //获取服务器上应用的最新版本号－－－> connect获得的appstore版本号
            NSString * updateVersion = infoDict[@"version"];
            long updateVersionLong = [[updateVersion stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
            weakself.appVersion = updateVersion;
            //获取当前设备中应用的版本号  －－－> 工程build的版本号
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString * currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            long currentVersionLong = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
            //判断两个版本是否相同
            if (currentVersionLong  < updateVersionLong) {
                NSString * onlyString = @"优化用户体验";
                [SELUpdateAlert showUpdateAlertWithVersion:updateVersion Description:onlyString focTag:YES];
            }
        }
    }];
    [dataTask resume];
}
-(void)pushPrintYuLan:(UINavigationController *)navigationController{
    kWeakSelf(self);
    if (ORDER_ISEQUAl(XiaoShouDan)) {
        [AD_MANAGER printXiaoShouPreviewAction:[weakself sameParamters] success:^(id object) {
            [weakself pushYuLanAction:object nv:navigationController];
        }];
    }else if (ORDER_ISEQUAl(YuDingDan)){
        [AD_MANAGER printYuDingDanPreviewAction:[weakself sameParamters]  success:^(id object) {
            [weakself pushYuLanAction:object nv:navigationController];
        }];
    }else if (ORDER_ISEQUAl(TuiHuoDan)){
        [AD_MANAGER printTuiHuoDanPreviewAction:[weakself sameParamters]  success:^(id object) {
            [weakself pushYuLanAction:object nv:navigationController];
        }];
    }else if (ORDER_ISEQUAl(YangPinDan)){
        [AD_MANAGER printYangPinDanPreviewAction:[weakself sameParamters]  success:^(id object) {
            [weakself pushYuLanAction:object nv:navigationController];
        }];
    }else if (ORDER_ISEQUAl(ChuKuDan)){
        [AD_MANAGER printChuKuDanPreviewAction:[weakself sameParamters]  success:^(id object) {
            [weakself pushYuLanAction:object nv:navigationController];
        }];
    }else if (ORDER_ISEQUAl(ShouKuanDan)){
        [AD_MANAGER printShouKuanDanPreviewAction:[weakself sameParamters]  success:^(id object) {
            [weakself pushYuLanAction:object nv:navigationController];
        }];
    }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
        [AD_MANAGER printCaiGouRuKuDanPreviewAction:[weakself sameParamters]  success:^(id object) {
            [weakself pushYuLanAction:object nv:navigationController];
        }];
    }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
        [AD_MANAGER printCaiGouTuiHuoDanPreviewAction:[weakself sameParamters]  success:^(id object) {
            [weakself pushYuLanAction:object nv:navigationController];
        }];
    }else if (ORDER_ISEQUAl(FuKuanDan)){
        [AD_MANAGER printFuKuanDanPreviewAction:[weakself sameParamters]  success:^(id object) {
            [weakself pushYuLanAction:object nv:navigationController];
        }];
    }
}

-(NSMutableDictionary *)sameParamters{
    
    NSString * wayname = [AD_MANAGER.printWay[@"wayname"] replaceAll:@"[定制]" target:@""];
    NSInteger cloud = [AD_MANAGER.printWay[@"cloud"] integerValue];
    
    if (wayname) {
        NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"DpiX":@180,
                                                                                  @"cloud":@(cloud),
                                                                                  @"wayname":wayname,
                                                                                  @"DpiY":@180,
                                                                                  @"noteno":AD_MANAGER.noteno,
                                                                                  }];
        return mDic1;
    }else{
        return @{};
    }
}


-(void)pushYuLanAction:(id)object nv:(UINavigationController *)navigationController{
    JDBluePreviewViewController * VC = [[JDBluePreviewViewController alloc]init];
    
    VC.orderImage = object[@"img"];
    [navigationController pushViewController:VC animated:YES];
}
- (void)dingweiAction:(UIView *)view tf:(UITextField *)tf tv:(UIView *)tv{
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[view viewWithTag:1000];
    [activityView startAnimating];
    kWeakSelf(self);
    // 封装方法 开启定位
    [[SYCLLocation shareLocation] locationStart:^(CLLocation *location, CLPlacemark *placemark) {
        [activityView stopAnimating];
        NSString *subAdministrativeArea = placemark.administrativeArea;
        // 获取城市
        NSString *city = placemark.locality;
        NSString *subLocality = placemark.subLocality;
        if (!city){
            // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
            city = placemark.administrativeArea;
        }
        if ([tv isKindOfClass:[UITextView class]]) {
            ((UITextView *)tv).text = placemark.addressDictionary[@"Street"];
        }else{
            ((UITextField *)tv).text = placemark.addressDictionary[@"Street"];

        }
        tf.text = [NSString stringWithFormat:@"%@ %@ %@",subAdministrativeArea,city,subLocality];
    } faile:^(NSError *error) {
        [activityView stopAnimating];
        if (error)
        {
            if (([error code] == kCLErrorDenied))
            {
                [UIView showToast:@"定位未打开,请打开定位服务"];
            }
            else
            {
                [UIView showToast:[NSString stringWithFormat:@"An error occurred = %@", error]];
            }
        }
    }];
    
}
//传入权限名称，传出是否有权限
-(BOOL)inNameOutQuanXian:(NSString *)name{
    NSDictionary * resuleDic = [AD_SHARE_MANAGER readLocalFileWithName:@"BybMenuConstant"];
    //value为数字
    NSString * value = [resuleDic[name] stringValue];
    NSArray * menusArray = AD_MANAGER.quanXianDic[@"menus"];
    return [menusArray containsObject:value];
}
//单子传入权限名称和下标，传出是否有权限
-(BOOL)inOrderNameOutQuanXian:(NSString *)name subIndex:(NSString *)index{
    NSDictionary * resuleDic = [AD_SHARE_MANAGER readLocalFileWithName:@"BybMenuConstant"];
    NSArray * sub_Array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",];
    //value为数字
    NSString * value = [resuleDic[name] stringValue];
    NSArray * menusArray = AD_MANAGER.quanXianDic[@"menus"];
    //如果有权限，然后再判断下标
    if ([menusArray containsObject:value] && [sub_Array containsObject:index]) {
        return YES;
    }else{
        return NO;
    }
}

-(void)moneyAction:(MainTabBarController * )tabbar{
    REMOVE_ALL_CACHE;
    RootNavigationController * nav = tabbar.childViewControllers[tabbar.selectedIndex];
    UIViewController * homeVC =  nav.childViewControllers[0];
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"SecondVC" bundle:nil];
    JDNewAddShouKuanTableViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDNewAddShouKuanTableViewController"];
    VC.noteno = @"";
    VC.hidesBottomBarWhenPushed = YES;
    [homeVC.navigationController pushViewController:VC animated:YES];
}
//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}
@end
