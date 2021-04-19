//
//  JDCollectionAccountViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/6/27.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDCollectionAccountViewController.h"
#import "JDCollectionAccountTableViewCell.h"

@interface JDCollectionAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSDictionary * dateTimeDic;
@property(nonatomic,strong)UITableView * bottomTableView;
@property(nonatomic,strong)NSDictionary * dataDic;

@end

@implementation JDCollectionAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.whereCome ? @"账户付款情况" : @"账户收款情况";
    _dateTimeDic = @{@"begindate":[NSString currentDateStringyyyyMMdd],@"enddate":[NSString currentDateStringyyyyMMdd]};
    self.bottomTableView.tableFooterView = [[UIView alloc]init];
    
    _dataDic = [[NSDictionary alloc]init];
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)requestData{
    
    kWeakSelf(self);
    NSMutableDictionary * mDic = [AD_SHARE_MANAGER requestSameParamtersDic:_dateTimeDic];

    if (self.whereCome) {
        [AD_MANAGER requestQueryxs_cwfkqk_list:mDic success:^(id object) {
            weakself.dataDic = object[@"data"];
            [weakself.bottomTableView reloadData];
            
            NSMutableArray * mArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in object[@"data"][@"fkqk_zhs"]) {
                [mArray addObject:@([dic[@"fkje"] doubleValue])];
            }
            
            NSNumber * sum = [mArray valueForKeyPath:@"@sum.floatValue"];
            weakself.lbl1.text = CCHANGE(sum);
            weakself.lbl2.text = CCHANGE(self.dataDic[@"yfzk"]);
            [weakself.bottomTableView reloadData];
        }];
    }else{
        [AD_MANAGER requestQueryxs_cwskqk_list:mDic success:^(id object) {
            weakself.dataDic = object[@"data"];
            [weakself.bottomTableView reloadData];
            
            NSMutableArray * mArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in object[@"data"][@"skqk_zhs"]) {
                [mArray addObject:@([dic[@"skje"] doubleValue])];
            }
            
            NSNumber * sum = [mArray valueForKeyPath:@"@sum.floatValue"];
            weakself.lbl1.text = CCHANGE(sum);
            weakself.lbl2.text = CCHANGE(self.dataDic[@"yszk"]);
            [weakself.bottomTableView reloadData];

        }];
    }
    

}

#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        [_bottomTableView registerNib:[UINib nibWithNibName:@"JDCollectionAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDCollectionAccountTableViewCell"];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        [self.bottomView addSubview:_bottomTableView];
    }
    return _bottomTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.whereCome ? [self.dataDic[@"fkqk_zhs"] count] :  [self.dataDic[@"skqk_zhs"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDCollectionAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDCollectionAccountTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    NSArray * imgArr =  @[@"icon_xianjin",@"icon_wangyin",@"icon_zhifubao",@"icon_weixinzhifu",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita",@"icon_qita"];
    
    if (self.whereCome) {
        NSArray * array = [NSArray arrayWithArray:self.dataDic[@"fkqk_zhs"]];
        NSDictionary * dic = array[indexPath.row];
        NSInteger index = [dic[@"zhlx"] integerValue];
        cell.ImgStyle.image = [UIImage imageNamed:imgArr[index]];
        cell.lblStyle.text = dic[@"zhmc"];
        cell.priceLbl.text =  CCHANGE(dic[@"fkje"]);
    }else{
        NSArray * array = [NSArray arrayWithArray:self.dataDic[@"skqk_zhs"]];
        NSDictionary * dic = array[indexPath.row];
        NSInteger index = [dic[@"zhlx"] integerValue];
        cell.ImgStyle.image = [UIImage imageNamed:imgArr[index]];
        cell.lblStyle.text = dic[@"zhmc"];
        cell.priceLbl.text =  CCHANGE(dic[@"skje"]);
    }

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark ========== 个button的公用方法 今日 昨日 近7天 近30天 ==========
- (IBAction)allBtnAction:(UIButton *)btn {
    switch (btn.tag) {
        case 30001:{//今日
            
            
            _dateTimeDic = @{@"begindate":[NSString currentDateStringyyyyMMdd],@"enddate":[NSString currentDateStringyyyyMMdd]};
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
            
            _dateTimeDic = @{@"begindate":[[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:1 source:@"yyyy-MM-dd"],
                             @"enddate":[[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:1 source:@"yyyy-MM-dd"]};
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
            
            
       _dateTimeDic = @{@"begindate":[[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:7 source:@"yyyy-MM-dd"],@"enddate":[NSString currentDateStringyyyyMMdd]};
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
            
            
            
            _dateTimeDic = @{@"begindate":[[NSString currentDateStringyyyyMMdd] dateWithDaysAgo:30 source:@"yyyy-MM-dd"],@"enddate":[NSString currentDateStringyyyyMMdd]};
            [self requestData];
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

@end
