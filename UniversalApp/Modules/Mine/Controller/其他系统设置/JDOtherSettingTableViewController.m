//
//  JDOtherSettingTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/24.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDOtherSettingTableViewController.h"
#import "JDTestPrintTableViewController.h"

@interface JDOtherSettingTableViewController ()

@end

@implementation JDOtherSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统设置";
    self.view.backgroundColor = JDRGBAColor(247, 249, 251);
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
        JDTestPrintTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDTestPrintTableViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}


@end
