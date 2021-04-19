//
//  JDDayListViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDDayListViewController.h"
#import "NSDate+Helper.h"
#import "JDDayListModel.h"
#import "JDDayListTableViewCell.h"

@interface JDDayListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSDictionary * dateTimeDic;
@property(nonatomic,strong)UITableView * bottomTableView;

@end

@implementation JDDayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"经营概况";
    _dateTimeDic = @{@"date":[NSString currentDateStringyyyyMMdd]};
    self.bottomTableView.tableFooterView = [[UIView alloc]init];
    [self.bottomTableView registerNib:[UINib nibWithNibName:@"JDDayListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDDayListTableViewCell"];
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.bottomView.frame.size.height) style:UITableViewStylePlain];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        [self.bottomView addSubview:_bottomTableView];
    }
    return _bottomTableView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return AD_MANAGER.dayListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 630;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *identify = @"JDDayListTableViewCell";
    JDDayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    JDDayListModel * model = AD_MANAGER.dayListArray[indexPath.row];
    [cell setCellData:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:_dateTimeDic];
    [AD_MANAGER requestQueryxs_cwjyrb_list:mDic success:^(id object) {
        [weakself.bottomTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //2.将indexPath添加到数组
        NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
        //3.传入数组，对当前cell进行刷新
        [weakself.bottomTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];


    }];
}






#pragma mark ========== 个button的公用方法 今日 昨日 近7天 近30天 ==========
- (IBAction)allBtnAction:(UIButton *)btn {
    switch (btn.tag) {
        case 30001:{//今日
            
            
             _dateTimeDic = @{@"date":[NSString currentDateStringyyyyMMdd]};
            [self requestData];

            
            [self.btn1 setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
            [self.btn2 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn3 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn4 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            self.btn1Img.hidden = NO;
            self.btn2Img.hidden = self.btn3Img.hidden = self.btn4Img.hidden = YES;
        }
            break;
        case 30002:{//昨日

             _dateTimeDic = @{@"date": [[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:1 source:@"yyyy-MM-dd"]};
            [self requestData];

            [self.btn2 setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
            [self.btn1 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn3 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn4 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            self.btn2Img.hidden = NO;
            self.btn1Img.hidden = self.btn3Img.hidden = self.btn4Img.hidden = YES;
        }
            
            break;
        case 30003:{//近7天

            
            _dateTimeDic = @{@"date": [[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:2 source:@"yyyy-MM-dd"]};
            [self requestData];

            [self.btn3 setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
            [self.btn1 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn2 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn4 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            self.btn3Img.hidden = NO;
            self.btn2Img.hidden = self.btn1Img.hidden = self.btn4Img.hidden = YES;
        }
            
            break;
        case 30004:{//近30天

            
            
            [self dateClick];
            [self.btn4 setTitleColor:JDRGBAColor(0, 163, 255) forState:0];
            [self.btn1 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn3 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            [self.btn2 setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
            self.btn4Img.hidden = NO;
            self.btn2Img.hidden = self.btn3Img.hidden = self.btn1Img.hidden = YES;
        }
            
            break;
        default:
            break;
    }
}
- (void)dateClick{
    kWeakSelf(self);
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    
    picker.frame = CGRectMake(0, 40, KScreenWidth, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        ipad_alertController;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        _dateTimeDic = @{@"date":[date stringWithFormat:@"yyyy-MM-dd"]};
        [weakself.btn4 setTitle:[date stringWithFormat:@"yyyy-MM-dd"] forState:0];
        [weakself requestData];
        

    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
