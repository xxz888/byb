//
//  JDPersonCenterTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/26.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDPersonCenterTableViewController.h"
#import "ZZYPhotoHelper.h"
#import "JDChangeNameTableViewController.h"
#import "JDChangePhone1ViewController.h"
#import "JDChangePsdTableViewController.h"
@interface JDPersonCenterTableViewController (){
    NSString * _phone;
}

@end

@implementation JDPersonCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑资料";
    
    LoginModel * model = AD_USERDATAARRAY;
    //图片和名称赋值
    NSURL *url = [NSURL URLWithString:model.imgurl];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    self.titleImg.image = imagea;
    self.mdLbl.text = model.mdmc;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);

    [self requestData1];
}

-(void)requestData1{
    LoginModel * model = AD_USERDATAARRAY;
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"id":model.operatorid}];
    [AD_MANAGER requestAccTouXiangAction:mDic success:^(id object) {
        NSURL *url = [NSURL URLWithString:object[@"data"][@"tp"]];
        UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        weakself.titleImg.image = imagea;
        weakself.nameLbl.text = object[@"data"][@"ygmc"];
//        weakself.mobileLbl.text = object[@"data"][@"sjhm"];
        weakself.titleImg.layer.cornerRadius = weakself.titleImg.size.width *0.5;
        weakself.titleImg.layer.masksToBounds =YES;
        _phone =  object[@"data"][@"sjhm"];
        weakself.sjLbl.text = object[@"data"][@"sjhm"];
    }];
}
-(void)requestData:(UIImage *)image{
    
    kWeakSelf(self);
    NSString *strTopper = [NSString stringWithFormat:@"%@", [UIImageJPEGRepresentation(image, 0.1f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"value":strTopper}];
    [AD_MANAGER requestChangeImageAction:mDic success:^(id object) {
        weakself.titleImg.image = image;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    if (indexPath.row == 1) {//头像
        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
            [weakself requestData:(UIImage *)data];

        }];
    }else  if (indexPath.row == 3) {//姓名
        JDChangeNameTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDChangeNameTableViewController"];
        VC.block = ^(NSString * titleName) {
            weakself.nameLbl.text = titleName;
        };
        [self.navigationController pushViewController:VC animated:YES];
    }else  if (indexPath.row == 4) {
        
    }else  if (indexPath.row == 6) {
        JDChangePhone1ViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDChangePhone1ViewController"];
        VC.phone = _phone;
        [self.navigationController pushViewController:VC animated:YES];
    }else  if (indexPath.row == 7) {
        JDChangePsdTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDChangePsdTableViewController"];
        [self.navigationController pushViewController:VC animated:YES];

    }
}
@end
