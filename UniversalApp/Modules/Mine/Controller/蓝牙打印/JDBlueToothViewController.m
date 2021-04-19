//
//  JDBlueToothViewController.m
//  UniversalApp
//
//  Created by 尚虎 on 2018/7/18.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDBlueToothViewController.h"
#import "JDBlueToothSettingViewController.h"
#import "JDBluePreviewViewController.h"
#import "CoreBluetooth/CoreBluetooth.h"
#import "JWBluetoothManage.h"
#import "JDBlueToothTableViewCell.h"

#define WeakSelf __block __weak typeof(self)weakSelf = self;

@interface JDBlueToothViewController ()<UITableViewDelegate,UITableViewDataSource>{
    JWBluetoothManage * manage;
}

@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * connectDataSource; //设备列表

@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property (nonatomic,strong) UITableView * bottomTableView;



@end

@implementation JDBlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蓝牙打印";
    self.view.backgroundColor = self.bottomTableView.backgroundColor = JDRGBAColor(247, 249, 251);
    [self.bottomTableView registerNib:[UINib nibWithNibName:@"JDBlueToothTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDBlueToothTableViewCell"];
    self.dataSource = @[].mutableCopy;
    self.connectDataSource = @[].mutableCopy;
    [self.bottomTableView reloadData];
    manage = [JWBluetoothManage sharedInstance];
    kWeakSelf(self);
    [self blueConnect];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"正在刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshRightBtn:)];
}

-(void)refreshRightBtn:(UIBarButtonItem *)btn{
    if ([btn.title isEqualToString:@"正在刷新"]) {
        [manage stopScanPeripheral];
        [btn setTitle:@"刷新"];
    }else{
        [self blueConnect];
        [btn setTitle:@"正在刷新"];
    }
}
-(void)blueConnect{
    kWeakSelf(self);
    [manage beginScanPerpheralSuccess:^(NSArray<CBPeripheral *> *peripherals, NSArray<NSNumber *> *rssis) {
 
        [weakself getCommon:peripherals];
        [weakself.bottomTableView reloadData];
    } failure:^(CBManagerState status) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    WeakSelf
    [super viewWillAppear:animated];
    [manage autoConnectLastPeripheralCompletion:^(CBPeripheral *perpheral, NSError *error) {
        if (!error) {
            NSMutableArray * copyDataSource = [NSMutableArray arrayWithArray:weakSelf.dataSource];
            
            for (CBPeripheral * oidPerpheral  in copyDataSource) {
                if ([oidPerpheral.name isEqualToString:perpheral.name]) {
                    [weakSelf.dataSource removeObject:perpheral];
                }
            }
            
            
            NSMutableArray * copyConnectDataSource = [NSMutableArray arrayWithArray:weakSelf.connectDataSource];
            
            for (CBPeripheral * oidPerpheral  in copyConnectDataSource) {
                if ([oidPerpheral.name isEqualToString:perpheral.name]) {
                }else{
                    [weakSelf.connectDataSource addObject:perpheral];

                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.bottomTableView reloadData];
            });
        }else{

        }
    }];
}
-(void)getCommon:(NSArray *)peripherals{
    [self.dataSource removeAllObjects];
    [self.connectDataSource removeAllObjects];
    for (CBPeripheral * ral in peripherals) {
        if (ral.state == CBPeripheralStateConnected) {
            [self.connectDataSource addObject:ral];
        }else{
            [self.dataSource addObject:ral];
        }
    }
}
- (void)printe{
//    if (manage.stage != JWScanStageCharacteristics) {
//        [self showToast:@"打印机正在准备中..."];
//        return;
//    }
    [self requestData2];
}


//打印的公共方法
-(void)commonPrintAction:(id)object{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:object[@"data"][0] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    [[JWBluetoothManage sharedInstance] sendPrintData:data completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
        if (completion) {
            NSLog(@"打印成功");
        }else{
            NSLog(@"写入错误---:%@",error);
        }
    }];
}
#pragma mark lazy loading...
-(UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49 ) style:UITableViewStylePlain];
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        _bottomTableView.tableFooterView = [[UIView alloc]init];
        _bottomTableView.backgroundColor = JDRGBAColor(247, 249, 251);
        _bottomTableView.separatorStyle = 0;
        [self.bottomView addSubview:_bottomTableView];
    }
    return _bottomTableView;
}

#pragma tableView--delegate
#pragma tableView

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case 0:
            title = @"  以配对的设备(点击名称进行打印)";
            break;
        case 1:
            title = @"  未配对的设备(点击名称进行打印)";
            break;
        default:
            break;
    }
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 45)];
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    HeaderLabel.backgroundColor = JDRGBAColor(247, 249, 251);
    HeaderLabel.font = [UIFont boldSystemFontOfSize:13];
    HeaderLabel.textColor = JDRGBAColor(153, 153, 153);
    HeaderLabel.text = title;
    [view addSubview:HeaderLabel];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.connectDataSource.count : self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"JDBlueToothTableViewCell";
    JDBlueToothTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[JDBlueToothTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    CBPeripheral *peripherral ;
    if (indexPath.section == 0) {
        peripherral = [self.connectDataSource objectAtIndex:indexPath.row];
    }else{
        peripherral = [self.dataSource objectAtIndex:indexPath.row];
    }
    cell.titleLbl.text = [NSString stringWithFormat:@"%@",peripherral.name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf(self);
    [manage stopScanPeripheral];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshRightBtn:)];
    if (indexPath.section == 0) {

        CBPeripheral *peripheral = [self.connectDataSource objectAtIndex:indexPath.row];

        [manage connectPeripheral:peripheral completion:^(CBPeripheral *perpheral, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
                [weakself printe];
            }else{
                [weakself showToast:error.domain];
            }
        }];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        if (self.dataSource.count > indexPath.row) {
            [manage connectPeripheral:self.dataSource[indexPath.row] completion:^(CBPeripheral *perpheral, NSError *error) {
                [self.connectDataSource addObject:self.dataSource[indexPath.row]];
                [self.dataSource removeObjectAtIndex:indexPath.row];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
            }];
        
        }
   
     

    }


}
//打印设置
- (IBAction)printSettingAction:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"OtherVC" bundle:nil];
    JDBlueToothSettingViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"JDBlueToothSettingViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}




//打印预览
- (IBAction)printPreviewAction:(id)sender {
    [self requestData1];
}

//请求方式，预览
-(void)requestData1{
    [AD_SHARE_MANAGER pushPrintYuLan:self.navigationController];
}
//请求方式，打印
-(void)requestData2{
    kWeakSelf(self);
    if (ORDER_ISEQUAl(XiaoShouDan)) {
                [AD_MANAGER printXPXSNoteBytesAction:[AD_SHARE_MANAGER sameParamters]  success:^(id object) {
                    [weakself commonPrintAction:object];
                }];
    }else if (ORDER_ISEQUAl(YuDingDan)){
                [AD_MANAGER printYuDingDanNoteBytesAction:[AD_SHARE_MANAGER sameParamters]  success:^(id object) {
                    [weakself commonPrintAction:object];
                }];
    }else if (ORDER_ISEQUAl(TuiHuoDan)){
                [AD_MANAGER printTuiHuoDanNoteBytesAction:[AD_SHARE_MANAGER sameParamters]  success:^(id object) {
                    [weakself commonPrintAction:object];
                }];
    }else if (ORDER_ISEQUAl(YangPinDan)){
                [AD_MANAGER printYangPinDanNoteBytesAction:[AD_SHARE_MANAGER sameParamters]  success:^(id object) {
                    [weakself commonPrintAction:object];
                }];
    }else if (ORDER_ISEQUAl(ChuKuDan)){
                [AD_MANAGER printChuKuDanNoteBytesAction:[AD_SHARE_MANAGER sameParamters]  success:^(id object) {
                    [weakself commonPrintAction:object];
                }];
    }else if (ORDER_ISEQUAl(ShouKuanDan)){
                [AD_MANAGER printShouKuanDanNoteBytesAction:[AD_SHARE_MANAGER sameParamters]  success:^(id object) {
                    [weakself commonPrintAction:object];
                }];
    }else if (ORDER_ISEQUAl(FuKuanDan)){
            [AD_MANAGER printFuKuanDanNoteBytesAction:[AD_SHARE_MANAGER sameParamters]  success:^(id object) {
                [weakself commonPrintAction:object];
            }];
    }else if (ORDER_ISEQUAl(CaiGouRuKuDan)){
            [AD_MANAGER printCaiGouRuKuDanNoteBytesAction:[AD_SHARE_MANAGER sameParamters]  success:^(id object) {
                [weakself commonPrintAction:object];
            }];
    }else if (ORDER_ISEQUAl(CaiGouTuiHuoDan)){
            [AD_MANAGER printCaiGouTuiHuoNoteBytesAction:[AD_SHARE_MANAGER sameParamters]  success:^(id object) {
                [weakself commonPrintAction:object];
            }];
    }
}
@end
