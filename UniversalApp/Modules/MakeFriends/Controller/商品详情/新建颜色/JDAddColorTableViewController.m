//
//  JDAddColorTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/23.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "JDAddColorTableViewController.h"
#import "JDAddColorDetailTableViewCell.h"
#import "ZZYPhotoHelper.h"
#import "YBPopupMenu.h"

@interface JDAddColorTableViewController ()<YBPopupMenuDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray * dataSource;

@property(nonatomic,strong)NSMutableArray * ckData;

@end

@implementation JDAddColorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =self.whereCome ? @"颜色详情": @"新增颜色";
    [self.tableView registerNib:[UINib nibWithNibName:@"JDAddColorDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDAddColorDetailTableViewCell"];
    

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgBtnAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.colorImg addGestureRecognizer:tapGesture];
    self.price1Tf.delegate = self;
    self.lowTf.delegate = self;
    self.cbTf.delegate = self;
    self.zdkcTf.delegate = self;
    self.zdpsTf.delegate = self;

    
    _dataSource = [[NSMutableArray alloc]init];
    _ckData = [[NSMutableArray alloc]init];

    //如果是编辑页面进来的，就直接show，展示
    kWeakSelf(self);
    if (self.whereCome) {
        [self addNavigationItemWithTitles:@[@"更多"] isLeft:NO target:self action:@selector(moreAction:) tags:@[@9001]];
        [self.imgBtn setTitle:@"点击修改图片" forState:0];
        [self.imgBtn setTitleColor:KWhiteColor forState:0];
        [self.imgBtn setBackgroundImage:nil forState:0];
//        self.imgBtn.hidden = YES;
//        self.colorImg.userInteractionEnabled = YES;
        NSMutableDictionary * dic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"sh":self.sh,@"spid":@(self.spModel.spid)}];
        [AD_MANAGER requestShowColorPiShuAction:dic1 success:^(id object) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:object[@"data"]];
            [weakself.tableView reloadData];
            
            NSMutableDictionary * dic2 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"sh":self.sh,@"id":@(self.spModel.spid)}];
            [AD_MANAGER requestShowColorQiTaAction:dic2 success:^(id object) {
                
                weakself.colorTf.text =object[@"data"][@"ys"];
                weakself.cdColorTf.text = object[@"data"][@"cdys"];
                weakself.price1Tf.text = doubleToNSString([object[@"data"][@"bzsj"]doubleValue]);
                weakself.lowTf.text = doubleToNSString([object[@"data"][@"zdsj"]doubleValue]);
                weakself.cbTf.text = Quan_Xian(@"查看成本权限") ? doubleToNSString([object[@"data"][@"cbdj"]doubleValue]) : @"***";
                weakself.cbTf.userInteractionEnabled = Quan_Xian(@"查看成本权限") ? YES : NO;
                weakself.zdkcTf.text = doubleToNSString([object[@"data"][@"zdkc"]doubleValue]);
                weakself.zdpsTf.text = NSIntegerToNSString([object[@"data"][@"zdkcps"]doubleValue]);
                weakself.danweiLbl.text = weakself.spModel.jldw;
                NSURL *url = [NSURL URLWithString:object[@"data"][@"tpurl"]];
                UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];

                if (imagea) {
                    weakself.colorImg.image = imagea;
                }else{
                    [weakself.imgBtn setBackgroundImage:[UIImage imageNamed:@"rectangle"] forState:0];
                    [weakself.imgBtn setTitleColor:JDRGBAColor(153, 153, 153) forState:0];
                }
                
            }];
            
        }];
        
    }else{
//        self.colorImg.userInteractionEnabled = NO;
//        self.imgBtn.hidden = NO;

        [self requestData];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextTextField:) name:@"xxxx" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)nextTextField:(NSNotification *)notification{
    [self.view endEditing:YES];
}
#define TITLES @[@"删除"]
-(void)moreAction:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:TITLES icons:nil menuWidth:120 delegate:self];
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (index == 0) {
        

        
        [LEEAlert alert].config
        .LeeTitle(@"你确定要删除吗?")
        .LeeContent(@"")
        .LeeCancelAction(@"取消", ^{
            
            // 取消点击事件Block
        })
        .LeeAction(@"确认", ^{
            
            kWeakSelf(self);
            NSMutableDictionary * dic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"sh":self.sh,@"id":@(self.spModel.spid)}];
            [AD_MANAGER requestDelNewColorImageAction:dic1 success:^(id object) {
                [weakself showToast:@"删除成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
            
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        
    }
}
-(void)requestData{
    kWeakSelf(self);
    NSMutableDictionary * qitaDic = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"pageno":@(1),@"pagesize":@(1000)}];
    [AD_MANAGER requestCKListAction:qitaDic success:^(id object) {
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:object[@"data"][@"list"]];
        [weakself.tableView reloadData];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _dataSource.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return  50;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//爱好 （动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        JDAddColorDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDAddColorDetailTableViewCell" forIndexPath:indexPath];
        NSDictionary * dic = _dataSource[indexPath.row];

        cell.ckLbl.text = dic[@"ckmc"];
        cell.psTf.text = doubleToNSString([dic[@"spps"] doubleValue]);
        cell.msTf.text = doubleToNSString([dic[@"spsl"] doubleValue]);
        cell.danweiLbl.text = self.spModel.jldw;;
        if ([cell.psTf.text doubleValue] == 0) {
            cell.psTf.text = @"0";
        }
        
        if ([cell.msTf.text doubleValue] == 0) {
            cell.msTf.text = @"0";
        }
        [cell.psTf addTarget:self action:@selector(textPsDidFieldEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [cell.msTf addTarget:self action:@selector(textCountDidFieldEnd:) forControlEvents:UIControlEventEditingDidEnd];
        cell.psTf.delegate = self;
        cell.msTf.delegate = self;
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
//匹数
-(void)textPsDidFieldEnd:(UITextField *)tf{

    [self sameAction:tf];
}
//数量
-(void)textCountDidFieldEnd:(UITextField *)tf{
 
    [self sameAction:tf];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.text.doubleValue == 0) {
        textField.text = @"";
    }
    return YES;
}
-(void)sameAction:(UITextField*)tf{
    JDAddColorDetailTableViewCell * cell = (JDAddColorDetailTableViewCell *)tf.superview.superview.superview.superview;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary * mDic = [NSMutableDictionary dictionaryWithDictionary:_dataSource[indexPath.row]];
    [mDic setValue:@([cell.psTf.text doubleValue]) forKey:@"spps"];
    [mDic setValue:@([cell.msTf.text doubleValue]) forKey:@"spsl"];
    [_dataSource replaceObjectAtIndex:indexPath.row withObject:mDic];
}
- (IBAction)saveAddNewColor:(id)sender {
    
    [self requestDataAddColor];
}
- (NSString *)arrayToJSONString:(NSArray *)array

{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
-(void)requestDataAddColor{

    
    //图片
    NSString *strTopper = [NSString stringWithFormat:@"%@", [UIImageJPEGRepresentation(self.colorImg.image, 0.1f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    //其他参数
    NSDictionary * dic1 ;
    if (self.whereCome) {
        dic1  = @{@"bzsj":@([self.price1Tf.text doubleValue]),
                  @"cbdj":@([self.cbTf.text doubleValue]),
                  @"zdsj":@([self.lowTf.text doubleValue]),
                  @"cdys":self.cdColorTf.text,
                  @"zdkc":@([self.zdkcTf.text doubleValue]),
                  @"ys":self.colorTf.text,
                  @"spid":@(self.spModel.spid),
                  @"sh":self.sh,
                  @"zdkcps":@([self.zdpsTf.text integerValue]),
                  };
    }else{
        dic1  = @{@"bzsj":@([self.price1Tf.text doubleValue]),
                  @"cbdj":@([self.cbTf.text doubleValue]),
                  @"zdsj":@([self.lowTf.text doubleValue]),
                  @"cdys":self.cdColorTf.text,
                  @"zdkc":@([self.zdkcTf.text doubleValue]),
                  @"ys":self.colorTf.text,
                  @"spid":@(self.spModel.spid),
                  @"zdkcps":@([self.zdpsTf.text integerValue])
                  };
    }

    NSString * string1 = [ADTool dicConvertToNSString:dic1];

    kWeakSelf(self);
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string1}];//其他参数

    
    if (self.whereCome) {
        [AD_MANAGER requestEditNewColorImageAction:mDic1 success:^(id object) {
            [weakself editColor:object tp:strTopper];
        }];
    }else{
        [AD_MANAGER requestAddnewColorQiTaAction:mDic1 success:^(id object) {
            if ([strTopper isEqualToString:@"(null)"] || !strTopper) {
                [weakself editCangKu:object];
            }else{
                [weakself editColor:object  tp:strTopper];
            }
            
            
        }];
    }
        

  
}
//图片请求
-(void)editColor:(id)object tp:(NSString*)strTopper{
    kWeakSelf(self);
    NSString * sh = object[@"data"][@"sh"];
    NSMutableDictionary * mDic3 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"sh":sh,@"id":@(self.spModel.spid),@"tp":strTopper}];//图片
    [AD_MANAGER requestAddNewColorImageAction:mDic3 success:^(id object1) {
        [weakself editCangKu:object];
    }];
}
//仓库请求
-(void)editCangKu:(id)object{
    kWeakSelf(self);
    NSString * sh = object[@"data"][@"sh"];
    NSString * string1 = [ADTool arrayConvertToNSString:_dataSource];
    NSMutableDictionary * mDic1 = [AD_SHARE_MANAGER requestSameParamtersDic:@{@"data":string1,@"sh":sh,@"spid":@(_spModel.spid)}];//其他参数
    [AD_MANAGER requestAddnewColorCangKuAction:mDic1 success:^(id object) {
        [weakself commonAction];
    }];
}
-(void)commonAction{
    kWeakSelf(self);
    if (weakself.whereCome) {
        [weakself showToast:@"修改成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
        
    }else{
        [LEEAlert alert].config
        .LeeTitle(@"添加成功")
        .LeeContent(@"")
        .LeeCancelAction(@"返回列表", ^{
            [weakself.navigationController popViewControllerAnimated:YES];
            // 取消点击事件Block
        })
        .LeeAction(@"继续添加", ^{
            weakself.colorTf.text = @"";
            weakself.cdColorTf.text = @"";
            weakself.price1Tf.text = @"";
            weakself.lowTf.text = @"";
            weakself.cbTf.text = @"";
            weakself.zdkcTf.text = @"";
            weakself.cbTf.text = @"";
            weakself.cbTf.text = @"";
            [weakself requestData];
            
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        
    }
}

- (IBAction)imgBtnAction:(id)sender {
    [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        [self.imgBtn setTitle:@"点击修改图片" forState:0];
        [self.imgBtn setTitleColor:KWhiteColor forState:0];
        [self.imgBtn setBackgroundImage:nil forState:0];
        self.colorImg.image = (UIImage *)data;
    }];
}
@end
