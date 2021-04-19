//
//  JDEditCompanyTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/24.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDEditCompanyTableViewController.h"
#import "ZZYPhotoHelper.h"

@interface JDEditCompanyTableViewController ()

@end

@implementation JDEditCompanyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commanyImg.layer.cornerRadius = self.commanyImg.size.width *0.5;
    self.commanyImg.layer.masksToBounds =YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.title = @"编辑公司详情";
    
    [self requestData];
    
    [self addNavigationItemWithTitles:@[@"保存"] isLeft:NO target:self action:@selector(saveAction:) tags:@[@9001]];
}
-(void)saveAction:(UIButton *)btn{
    kWeakSelf(self);
    //图片
    NSString *strTopper = [NSString stringWithFormat:@"%@", [UIImageJPEGRepresentation(self.commanyImg.image, 0.1f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"dW_DWMC":self.nameTf.text,
                                                                             @"dW_LXDH":self.phoneTf.text,
                                                                             @"dW_LXWX":self.wxTf.text,
                                                                             @"dW_TP":strTopper
                                                                             }];
    [AD_MANAGER requestSaveCommanyInfoAction:mDic success:^(id object) {
        [weakself showToast:@"保存成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
        
    }];
}
-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"":@""}];
    [AD_MANAGER requestCommanyInfoAction:mDic success:^(id object) {
        NSURL *url = [NSURL URLWithString:object[@"data"][@"dW_TP"]];
        UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        weakself.commanyImg.image = imagea;
        
        weakself.nameTf.text = object[@"data"][@"dW_DWMC"];
        weakself.phoneTf.text = object[@"data"][@"dW_LXDH"];
        weakself.wxTf.text = object[@"data"][@"dW_LXWX"];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


- (IBAction)imgAction:(id)sender {
    [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        self.commanyImg.image = (UIImage *)data;
    }];
}
@end
