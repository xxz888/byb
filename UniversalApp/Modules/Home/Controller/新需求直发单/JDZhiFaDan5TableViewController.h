//
//  JDZhiFaDan5TableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/22.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootTableViewController.h"
#import "JDSelectClientModel.h"
#import "JDButtom.h"
#import "JDAddColorModel.h"

typedef void(^SendValueToUpVC)(NSDictionary *);
NS_ASSUME_NONNULL_BEGIN

@interface JDZhiFaDan5TableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet JDButtom *btn1;//客户
@property (weak, nonatomic) IBOutlet JDButtom *btn2;//选择地址
@property (weak, nonatomic) IBOutlet UITextField *tf2;//手写地址
@property (weak, nonatomic) IBOutlet JDButtom *btn3;//仓库
@property (weak, nonatomic) IBOutlet UIButton *btn4Tag;//送货员tag
@property (weak, nonatomic) IBOutlet JDButtom *btn4;//送货员
@property (weak, nonatomic) IBOutlet JDButtom *btn5;//业务员
@property (weak, nonatomic) IBOutlet JDButtom *btn6;//店铺

- (IBAction)btn1Action:(id)sender;
- (IBAction)btn2Action:(id)sender;
- (IBAction)btn3Action:(id)sender;
- (IBAction)btn4Action:(id)sender;
- (IBAction)btn5Action:(id)sender;

@property (weak, nonatomic) IBOutlet UITableViewCell *dingjinCell;

- (IBAction)dingjinBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet JDButtom *dingjinBtn;

@property (weak, nonatomic) IBOutlet UITextView *bzTV;
@property (weak, nonatomic) IBOutlet JDButtom *btn0;


@property (nonatomic,strong) NSString * noteno;//草稿的单号
@property (nonatomic,strong) NSMutableDictionary * caogaoDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallTableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *smallTableView;

@end

NS_ASSUME_NONNULL_END
