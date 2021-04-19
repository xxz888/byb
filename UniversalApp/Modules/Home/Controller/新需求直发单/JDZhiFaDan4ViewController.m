//
//  JDZhiFaDan4ViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/21.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "JDZhiFaDan4ViewController.h"
#import "JDZhiFaDan4TableViewCell.h"
#import "JDZhiFaDan4ColorViewController.h"
#import "JDZhiFaDan5ViewController.h"
@interface JDZhiFaDan4ViewController ()<UITableViewDelegate,UITableViewDataSource,DissmissVCDelegateNew>

@end

@implementation JDZhiFaDan4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
}
-(void)initTableView{
    self.addCount.text = [NSString stringWithFormat:@"%ld",[NEW_AffrimDic_SectionArray count]];
    self.title = @"选择商品";
    [self.yxTableView registerNib:[UINib nibWithNibName:@"JDZhiFaDan4TableViewCell" bundle:nil] forCellReuseIdentifier:@"JDZhiFaDan4TableViewCell"];
    [self addNavigationItemWithTitles:@[@"新增商品"] isLeft:NO target:self action:@selector(addSp) tags:nil];
}
-(void)addSp{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [NEW_AffrimDic_SectionArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * spid = [NEW_AffrimDic_SectionArray[section] allKeys][0];
    return [NEW_AffrimDic_SectionArray[section][spid][@"color"] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDZhiFaDan4TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDZhiFaDan4TableViewCell" forIndexPath:indexPath];
    [cell setCellData:indexPath];
    
    kWeakSelf(self);
    cell.jinjiBlock = ^() {
        [weakself jisuanAllPrice];
    };
    
    cell.xiaojiaBlock = ^() {
        [weakself jisuanAllPrice];
    };
    
    cell.countBlock = ^() {
        [weakself jisuanAllPrice];
    };
    return cell;
}


-(void)jisuanAllPrice{
        double allPrice  = 0;
        double jinjiaAllPrice  = 0;
        NSInteger allCount = 0;
        //键盘消失的时候，开始计算总计价格
        for (NSInteger i = 0 ; i < [NEW_AffrimDic_SectionArray count]; i++) {
            NSString * key = [NEW_AffrimDic_SectionArray[i] allKeys][0];
            NSArray * countArr = NEW_AffrimDic_SectionArray[i][key][@"color"];
            for (NSInteger k = 0; k < countArr.count; k++) {
                NSDictionary * dic = countArr[k];
                JDAddColorModel * colorModel = dic[@"model"];
                double colorArrayAllCount = 0.00;
                //计算数组所有count的之和
                    for (NSString * countString in dic[@"colArray"]) {
                        colorArrayAllCount += [countString doubleValue];
                    }
                    double xiaojiaPrice = [colorModel.saveXiaoJiaPrice doubleValue] ? [colorModel.saveXiaoJiaPrice doubleValue] : colorModel.xsdj;
                
                    allPrice = allPrice + colorArrayAllCount * xiaojiaPrice;
                    jinjiaAllPrice = jinjiaAllPrice + colorArrayAllCount * colorModel.cbdj;
                }
        }
        self.xiaojiaTotalLbl.text = [[NSString stringWithFormat:@"%.2f",allPrice] concate:@"¥"];
      self.jinjiaTotalLbl.text = [[NSString stringWithFormat:@"%.2f",jinjiaAllPrice] concate:@"¥"];    
    self.addCount.text = [NSString stringWithFormat:@"%ld",[NEW_AffrimDic_SectionArray count]];
}
-(double)inZhuFuTagOutAllCount:(NSInteger)tag colorModel:(JDAddColorModel *)colorModel{
    //判断用的主单位还是副单位
    double sumCount = 0;
    for (NSDictionary * dic in colorModel.psArray) {
        if (colorModel.saveZhuFuTag == 0) {
            double smallCount1 = [dic[@"xssl"] doubleValue] +  [colorModel.savekongcha doubleValue] == 0 ? 0 : [dic[@"xssl"] doubleValue] +  [colorModel.savekongcha doubleValue];
            sumCount += smallCount1;
        }else{
            double smallCount2 = [dic[@"xsfsl"] doubleValue] +  [colorModel.savekongcha doubleValue] == 0 ? 0 : [dic[@"xsfsl"] doubleValue] +  [colorModel.savekongcha doubleValue];
            sumCount += smallCount2;
        }
    }
    return sumCount;
}

#pragma mark ==========  头视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    for (JDSelectSpModel * spModle in AD_MANAGER.selectSpPageArray) {
        if ([[NEW_AffrimDic_SectionArray[section] allKeys][0] intValue] == spModle.spid) {
            title = spModle.spmc;
        }
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 40)];
    view.backgroundColor = KWhiteColor;
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, KScreenWidth, 40)];
    HeaderLabel.font = [UIFont boldSystemFontOfSize:16];
    HeaderLabel.textColor = JDRGBAColor(25, 25, 25);
    HeaderLabel.text = title;
    [view addSubview:HeaderLabel];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = JDRGBAColor(235, 235, 235);
    imageView.frame = CGRectMake(0, 39, KScreenWidth,0.5);
    [view addSubview:imageView];
    
    
//#pragma mark--button create
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(KScreenWidth - 100, 0, 100, 40);
//    btn.backgroundColor = [UIColor redColor];
//    [btn setTitle:@"删除" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(clickedDelete:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:btn];
    
    return view;
}
-(void)clickedDelete:(UIButton *)btn{
    
}
//头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
#pragma mark ========== 尾视图 ==========
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    //    view.backgroundColor = KClearColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 113, 30);
    btn.center = view.center;
    [btn setTitle:@"+ 添加颜色" forState:UIControlStateNormal];
    [btn setTitleColor:JDRGBAColor(0, 163, 255) forState:UIControlStateNormal];
    ViewBorderRadius(btn, 5, 0.5, JDRGBAColor(0, 163, 255));
    btn.font = [UIFont systemFontOfSize:13];
    btn.tag = section+100;
    [btn addTarget:self action:@selector(addColorBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
#pragma mark ========== 添加颜色的present方法 ==========
-(void)addColorBtnclicked:(UIButton *)btn{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"XinXuQiu" bundle:nil];
    JDZhiFaDan4ColorViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDZhiFaDan4ColorViewController"];
    VC.delegate = self;
    //获取到点击的哪一个组，在颜色界面做逻辑处理
    NSInteger index = btn.tag - 100;
    VC.index = index;
    [self presentViewController:VC animated:YES completion:nil];
}
//颜色界面消失后
-(void)dissmissValue:(NSInteger)index{
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index];
    [self.yxTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
- (IBAction)nextAction:(id)sender{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"XinXuQiu" bundle:nil];
    JDZhiFaDan5ViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"JDZhiFaDan5ViewController"];
    VC.jinjia = self.jinjiaTotalLbl.text;
    VC.xiaojia = self.xiaojiaTotalLbl.text;
    VC.totalcount = self.addCount.text;
    [self.navigationController pushViewController:VC animated:YES];
}
- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //1、
        if (NEW_AffrimDic_SectionArray <= 0) {
            return;
        }
        NSMutableArray * changeStartArray = [[NSMutableArray alloc]initWithArray:NEW_AffrimDic_SectionArray];
        //2、要删除的组，是一个字典
        NSDictionary * sectionDic = changeStartArray[indexPath.section];
        //3、得到字典里面,color的数组,并且删除那一行
        NSString * sectionKey = [sectionDic allKeys][0];
        NSMutableArray * colorArray = sectionDic[sectionKey][@"color"];
        //4、删除要删除的那一行
        [colorArray removeObjectAtIndex:indexPath.row];
        //5、判断是颜色数组里面是否还有值，没值的话，删除整个组
        if (colorArray.count == 0) {
            [NEW_AffrimDic_SectionArray removeObjectAtIndex:indexPath.section];
        }
        //刷新
        completionHandler (YES);
        [self.yxTableView reloadData];
    }];
    deleteRowAction.image = [UIImage imageNamed:@"删除"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

@end
