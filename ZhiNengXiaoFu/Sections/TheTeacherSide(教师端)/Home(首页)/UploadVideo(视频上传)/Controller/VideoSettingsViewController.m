//
//  VideoSettingsViewController.m
//  ZhiNengXiaoFu
//
//  Created by duxiu on 2018/7/30.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "VideoSettingsViewController.h"

@interface VideoSettingsViewController ()<UITextFieldDelegate>

//视频标题
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UITextField  *titleField;
//视频描述
@property (nonatomic, strong) UILabel     *describeLabel;
@property (nonatomic, strong) WTextView   *describeTextView;
//公开
@property (nonatomic, strong) UIButton    *publicBtn;
@property (nonatomic, assign) NSInteger   publicChooseState;
//收费
@property (nonatomic, strong) UIButton    *chargeBtn;
@property (nonatomic, assign) NSInteger   chargeChooseState;

//收费view
@property (nonatomic, strong) UIView      *costView;
@property (nonatomic, strong) UILabel     *costLabel;
@property (nonatomic, strong) UITextField *costTextField;
@property (nonatomic, strong) UILabel     *yuanLabel;

@property (nonatomic, strong) NSString  *is_chargeStr;//收费0否1是
//保存
@property (nonatomic, strong) UIButton    *saveBtn;

@end

@implementation VideoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.is_chargeStr = @"0";
    [self makeVideoSettingsViewControllerUI];
}

- (void)makeVideoSettingsViewControllerUI {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setTitle:@"删除" forState:UIControlStateNormal];
    button.titleLabel.font = titFont;
    [button addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, APP_WIDTH - 20, 30)];
    self.titleLabel.text = @"视频标题";
    self.titleLabel.font = titFont;
    self.titleLabel.textColor = titlColor;
    [self.view addSubview:self.titleLabel];
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.size.height + 10, APP_WIDTH - 20, 40)];
    self.titleField.backgroundColor = [UIColor whiteColor];
    self.titleField.layer.masksToBounds = YES;
    self.titleField.layer.cornerRadius = 5;
    self.titleField.layer.borderColor = fengeLineColor.CGColor;
    self.titleField.layer.borderWidth = 1.0f;
    self.titleField.font = contentFont;
    self.titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择视频标题" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]}];
    self.titleField.delegate = self;
    self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.titleField];
    

    
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.size.height + self.titleField.frame.size.height  + 30, APP_WIDTH - 20, 30)];
    self.describeLabel.text = @"视频描述";
    self.describeLabel.font = titFont;
    self.describeLabel.textColor = titlColor;
    [self.view addSubview:self.describeLabel];
    
    self.describeTextView = [[WTextView alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.size.height + self.titleField.frame.size.height +  self.describeLabel.frame.size.height + 30, APP_WIDTH - 20, 100)];
    self.describeTextView.backgroundColor = [UIColor whiteColor];
    self.describeTextView.layer.masksToBounds = YES;
    self.describeTextView.layer.cornerRadius = 5;
    self.describeTextView.layer.borderColor = fengeLineColor.CGColor;
    self.describeTextView.layer.borderWidth = 1.0f;
    self.describeTextView.font = contentFont;
    self.describeTextView.placeholder = @"请输入活动内容...";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.describeTextView];
    
    self.publicBtn = [[UIButton alloc] initWithFrame:CGRectMake((APP_WIDTH - 160) / 3, self.titleLabel.frame.size.height + self.titleField.frame.size.height + self.describeLabel.frame.size.height + self.describeTextView.frame.size.height + 40, 20, 20)];
    [self.publicBtn setBackgroundImage:[UIImage imageNamed:@"对勾"] forState:UIControlStateNormal];
    [self.publicBtn addTarget:self action:@selector(publicBtn:) forControlEvents:UIControlEventTouchDown];
    self.publicBtn.userInteractionEnabled = YES;
    [self.view addSubview:self.publicBtn];
    UILabel *publicLabel = [[UILabel alloc] initWithFrame:CGRectMake((APP_WIDTH - 160) / 3 + self.publicBtn.frame.size.width, self.titleLabel.frame.size.height + self.titleField.frame.size.height  + self.describeLabel.frame.size.height + self.describeTextView.frame.size.height + 40, 60, 20)];
    publicLabel.textColor = titlColor;
    publicLabel.text = @"公开";
    publicLabel.font = titFont;
    [self.view addSubview:publicLabel];
    
    self.chargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(APP_WIDTH - (APP_WIDTH - 160) / 3 - 60, self.titleLabel.frame.size.height + self.titleField.frame.size.height  + self.describeLabel.frame.size.height + self.describeTextView.frame.size.height + 40, 20, 20)];
    [self.chargeBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
    [self.chargeBtn addTarget:self action:@selector(chargeBtn:) forControlEvents:UIControlEventTouchDown];
    self.chargeBtn.userInteractionEnabled = YES;
    [self.view addSubview:self.chargeBtn];
    UILabel *chargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(APP_WIDTH - (APP_WIDTH - 160) / 3 - self.chargeBtn.frame.size.width * 2, self.titleLabel.frame.size.height + self.titleField.frame.size.height + self.describeLabel.frame.size.height + self.describeTextView.frame.size.height + 40, 60, 20)];
    chargeLabel.textColor = titlColor;
    chargeLabel.text = @"收费";
    chargeLabel.font = titFont;
    [self.view addSubview:chargeLabel];
    
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.size.height + self.titleField.frame.size.height  + self.describeLabel.frame.size.height + self.describeTextView.frame.size.height + self.publicBtn.frame.size.height + 70, APP_WIDTH - 20, 40)];
    self.saveBtn.backgroundColor = THEMECOLOR;
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.layer.borderColor = fengeLineColor.CGColor;
    self.saveBtn.layer.borderWidth = 1.0f;
    self.saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    
   
    
}

- (void)makeCostView {
    
    self.saveBtn.hidden = YES;
    
    self.costView = [[UIView alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.size.height + self.titleField.frame.size.height + self.describeLabel.frame.size.height + self.describeTextView.frame.size.height + self.publicBtn.frame.size.height + 60, APP_WIDTH - 20, 50)];
    [self.view addSubview:self.costView];
    self.costView.backgroundColor = [UIColor whiteColor];
    
    self.costLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 30)];
    self.costLabel.text = @"费用";
    self.costLabel.textColor = RGB(155, 155, 155);
    self.costLabel.font = contentFont;
    [self.costView addSubview:self.costLabel];
    
    self.yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.costView.frame.size.width - 40, 10, 30, 30)];
    self.yuanLabel.text = @"元";
    self.yuanLabel.textColor = RGB(155, 155, 155);
    self.yuanLabel.font = contentFont;
    [self.costView addSubview:self.yuanLabel];
    
    self.costTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.costView.frame.size.width - self.yuanLabel.frame.size.width - 20 - APP_WIDTH * 0.4, 10, APP_WIDTH * 0.4, 30)];
    self.costTextField.backgroundColor = [UIColor whiteColor];
    self.costTextField.font = contentFont;
    self.costTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入金额" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]}];
    self.costTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.costTextField.delegate = self;
    self.costTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.costView addSubview:self.costTextField];
    
    self.costView.hidden = NO;
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.size.height + self.titleField.frame.size.height  + self.describeLabel.frame.size.height + self.describeTextView.frame.size.height + self.publicBtn.frame.size.height + self.costView.frame.size.height + 90, APP_WIDTH - 20, 40)];
    self.saveBtn.backgroundColor = THEMECOLOR;
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.layer.borderColor = fengeLineColor.CGColor;
    self.saveBtn.layer.borderWidth = 1.0f;
    self.saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    
}

- (void)makePublicView {
    self.costView.hidden = YES;
    self.saveBtn.hidden  = YES;
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.size.height + self.titleField.frame.size.height  + self.describeLabel.frame.size.height + self.describeTextView.frame.size.height + self.publicBtn.frame.size.height + 70, APP_WIDTH - 20, 40)];
    self.saveBtn.backgroundColor = THEMECOLOR;
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.layer.borderColor = fengeLineColor.CGColor;
    self.saveBtn.layer.borderWidth = 1.0f;
    self.saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
}

- (void)saveBtn : (UIButton *)sender {
    NSLog(@"点击发布");
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"]) {
        [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionary];
    if ([self.is_chargeStr isEqualToString:@"0"]) {
        dic = @{@"key":[UserManager key],@"id":self.ID,@"title":self.titleField.text,@"introduce":self.describeTextView.text,@"is_charge":self.is_chargeStr};
    } else {
        dic = @{@"key":[UserManager key],@"id":self.ID,@"title":self.titleField.text,@"introduce":self.describeTextView.text,@"is_charge":self.is_chargeStr,@"price":self.costTextField.text};
    }
    
    
    [[HttpRequestManager sharedSingleton] POST:toUpdateURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            [WProgressHUD showSuccessfulAnimatedText:[responseObject objectForKey:@"msg"]];
            
        } else {
            if ([[responseObject objectForKey:@"status"] integerValue] == 401 || [[responseObject objectForKey:@"status"] integerValue] == 402) {
                [UserManager logoOut];
            } else {
                
            }
            [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

- (void)chargeBtn : (UIButton *)sender {
    NSLog(@"点击收费");
    self.is_chargeStr = @"1";
    self.chargeChooseState = 1;
    self.publicChooseState = 0;
    [self.chargeBtn setBackgroundImage:[UIImage imageNamed:@"对勾"] forState:UIControlStateNormal];
    [self.publicBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
    [self makeCostView];
}

- (void)publicBtn : (UIButton *)sender {
    NSLog(@"点击公开");
    self.is_chargeStr = @"0";
    self.publicChooseState = 1;
    self.chargeChooseState = 0;
    [self.publicBtn setBackgroundImage:[UIImage imageNamed:@"对勾"] forState:UIControlStateNormal];
    [self.chargeBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
    [self makePublicView];
}

- (void)rightBtn : (UIButton *)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"]) {
        [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
        return;
    }
    
    NSLog(@"点击删除");
    NSDictionary *dic = @{@"key":[UserManager key],@"id":self.ID};
    [[HttpRequestManager sharedSingleton] POST:toDeleteURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            [WProgressHUD showSuccessfulAnimatedText:[responseObject objectForKey:@"msg"]];
            
        } else {
            if ([[responseObject objectForKey:@"status"] integerValue] == 401 || [[responseObject objectForKey:@"status"] integerValue] == 402) {
                [UserManager logoOut];
            } else {
                
            }
            [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

@end
