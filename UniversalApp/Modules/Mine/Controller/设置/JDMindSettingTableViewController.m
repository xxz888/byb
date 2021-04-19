//
//  JDMindSettingTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/2.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDMindSettingTableViewController.h"
#import "LoginViewController.h"
#import "SZKCleanCache.h"

@interface JDMindSettingTableViewController ()

@end

@implementation JDMindSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    self.navigationController.navigationBar.tintColor = JDRGBAColor(0, 163, 255);

    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    //获取当前设备中应用的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString * currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    self.versionLbl.text = [currentVersion concate:@"V."];
    
    self.clearCacheLbl.text = [doubleToNSString([SZKCleanCache folderSizeAtPath]) append:@"M"];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [AD_SHARE_MANAGER updateApp];
        //获取当前设备中应用的版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString * currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        long updateVersionLong = [[AD_SHARE_MANAGER.appVersion stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
        long currentVersionLong = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
        if (currentVersionLong < updateVersionLong) {
            self.versionLbl.text = [AD_SHARE_MANAGER.appVersion concate:@"V."];
            [self.versionLbl setBackgroundColor:KRedColor];
            ViewRadius(self.versionLbl, 5);
            self.versionLbl.textColor = KWhiteColor;
        }else{
            [self showToast:@"已经是最新版本"];
        }
    }else
    if (indexPath.row == 1) {
        
        kWeakSelf(self);
        //清除成功缓存
        [SZKCleanCache cleanCache:^{
            [weakself showToast:@"清除成功"];
            weakself.clearCacheLbl.text = [doubleToNSString([SZKCleanCache folderSizeAtPath]) append:@"M"];
        }];
    }
}

- (IBAction)logoutAction:(id)sender {
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{}];
     [AD_MANAGER requestLogOutApp:mDic success:^(id object) {
         [AD_SHARE_MANAGER outLogin];
        
    }];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
