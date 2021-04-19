//
//  JDAddCWGLViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2018/7/22.
//  Copyright © 2018年 徐阳. All rights reserved.
//

#import "RootViewController.h"

@interface JDAddCWGLViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *mcTf;
@property (weak, nonatomic) IBOutlet UITextField *jcTf;
- (IBAction)zhlxAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *zhlxLbl;
@property (weak, nonatomic) IBOutlet UITextField *zhTf;
@property (weak, nonatomic) IBOutlet UITextView *bzTv;
@property (weak, nonatomic) IBOutlet UILabel *djLbl;
- (IBAction)djAction:(id)sender;

@property (nonatomic,assign) NSInteger cwuglId;
@property (nonatomic,assign) BOOL whereCome; // yes是 有数据  no是新增

@end
