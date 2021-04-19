//
//  JDMiddleHistoryTableViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/5.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDMiddleHistoryTableViewController.h"
#import "JDAllOrderViewController.h"
@interface JDMiddleHistoryTableViewController ()

@end

@implementation JDMiddleHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"历史订单";
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (IBAction)clickBtn:(UIButton *)btn {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"ForthVC" bundle:nil];
    JDAllOrderViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDAllOrderViewController"];
    VC.selectTag1 = btn.tag -10;
    [self.navigationController pushViewController:VC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && !Quan_Xian_order(@"销售订单",@"1")) {
        return 0;
    }else  if (indexPath.row == 1 && !Quan_Xian_order(@"商品出库",@"1")) {
        return 0;
    }else  if (indexPath.row == 2 && !Quan_Xian_order(@"商品销售",@"1")) {
        return 0;
    }else  if (indexPath.row == 3 && !Quan_Xian_order(@"样品销售单",@"1")) {
        return 0;
    }else  if (indexPath.row == 4 && !Quan_Xian_order(@"销售退货",@"1")) {
        return 0;
    }else  if (indexPath.row == 5 && !Quan_Xian_order(@"收款单",@"1")) {
        return 0;
    }else  if (indexPath.row == 6 && !Quan_Xian_order(@"商品入库",@"1")) {
        return 0;
    }else  if (indexPath.row == 7 && !Quan_Xian_order(@"入库退货",@"1")) {
        return 0;
    }else  if (indexPath.row == 8 && !Quan_Xian_order(@"付款单",@"1")) {
        return 0;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
