//
//  MineViewController.m
//  ZhiNengXiaoFu
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "MineViewController.h"
#import "ClassHomePageItemCell.h"
#import "TuiChuLoginCell.h"
#import "MinePersonXiXinCell.h"
#import "PersonInfomationViewController.h"
#import "HelperCenterViewController.h"
#import "LeaveListViewController.h"
#import "SystemInfomationViewController.h"
#import "PersonInformationModel.h"
#import "PrefixHeader.pch"
#import "LoginHomePageViewController.h"
#import "ChangePasswordViewController.h"
#import "JiuQinGuanLiViewController.h"
#import "ExitCell.h"
#import "BindMobilePhoneViewController.h"
#import "HelperCenterModel.h"
#import "AdviceFeedbackViewController.h"
@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

//@property (nonatomic, strong) UITableView * mineTabelView;
@property (nonatomic, strong) NSMutableArray * mineAry;
@property (nonatomic, strong) PersonInformationModel * personInfo;

@property (nonatomic, assign) NSInteger bangdingState;

@property (nonatomic, strong) UIWebView * webView;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * iconImg;
@property (nonatomic, strong)  UIImageView * touxiangIcon;

@property (nonatomic, strong) NSMutableArray * iconAry;
@property (nonatomic, strong) NSMutableArray * titleAry;
@property (nonatomic, strong)  UIView * bottom;

@property (nonatomic, strong) HelperCenterModel * helperCenterModel;
@property (nonatomic, strong) UIView * back;
@end

@implementation MineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 226 / 375)];
    header.image = [UIImage imageNamed:@"背景图我的"];
    [self.view addSubview:header];
    
    UIImageView * whiteImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 118, kScreenWidth - 30, (kScreenWidth - 30) * 109 / 345 + 10)];
    whiteImg.image = [UIImage imageNamed:@"头像底"];
    [self.view addSubview:whiteImg];
    
    UIButton * person = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 7.5 - 25, APP_NAVH - 30 - 5, 15, 18)];
    [person setBackgroundImage:[UIImage imageNamed:@"个人信息"] forState:UIControlStateNormal];
    [person addTarget:self action:@selector(person:) forControlEvents:UIControlEventTouchDown];
    person.userInteractionEnabled = YES;
    [self.view addSubview:person];
    
    UILabel * my = [[UILabel alloc] initWithFrame:CGRectMake(21, APP_NAVH - 30, 60, 22)];
    my.text = @"我的";
    my.textColor = [UIColor whiteColor];
    my.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
    [self.view addSubview:my];
    
    
   self.touxiangIcon  = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 62, 73, 124, 124)];
    self.touxiangIcon.image = [UIImage imageNamed:@"头像"];
    [self.view addSubview:self.touxiangIcon];
    
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, 12 + 73, 100, 100)];
    self.iconImg.layer.cornerRadius = 50;
    self.iconImg.layer.masksToBounds = YES;
    [self.view addSubview:self.iconImg];
    
   
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 10,self.touxiangIcon.frame.size.height + self.touxiangIcon.frame.origin.y + 10, 20, 16)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = RGB(51, 51, 51);
    self.nameLabel.font = [UIFont systemFontOfSize:16];

    [self.view addSubview:self.nameLabel];
    
    self.bottom = [[UIView alloc] initWithFrame:CGRectMake(0, whiteImg.frame.origin.y + whiteImg.frame.size.height + 10, kScreenWidth, 249)];
    [self.view addSubview:self.bottom];
   
    
    NSInteger width = (kScreenWidth - 60) / 3;
    UIView * hengOneView = [[UIView alloc] initWithFrame:CGRectMake(30 + width, 0, 1, 248)];
    hengOneView.backgroundColor = RGB(230, 230, 230);
    [self.bottom addSubview:hengOneView];
    
    UIView * hengTwoView = [[UIView alloc] initWithFrame:CGRectMake(30 + width * 2, 0, 1, 248)];
    hengTwoView.backgroundColor = RGB(230, 230, 230);
    [self.bottom addSubview:hengTwoView];
    
    UIView * shuOneView = [[UIView alloc] initWithFrame:CGRectMake(30, 83, self.bottom.frame.size.width - 60, 1)];
    shuOneView.backgroundColor = RGB(230, 230, 230);
    [self.bottom addSubview:shuOneView];
    
    UIView * shuTwoView = [[UIView alloc] initWithFrame:CGRectMake(30, 83 * 2, self.bottom.frame.size.width- 60, 1)];
    shuTwoView.backgroundColor = RGB(230, 230, 230);
    [self.bottom addSubview:shuTwoView];
    
    
    self.navigationController.navigationBar.translucent = YES;
    [self setNetWorkNew];
}

- (void)setNetWorkNew
{
    NSDictionary * dic = @{@"key":[UserManager key]};
    [[HttpRequestManager sharedSingleton] POST:userContactUs parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            self.helperCenterModel = [HelperCenterModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
        }else
        {
            if ([[responseObject objectForKey:@"status"] integerValue] == 401 || [[responseObject objectForKey:@"status"] integerValue] == 402) {
                [UserManager logoOut];
            }else
            {
                
            }
            [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];
            
        }
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}


- (NSMutableArray *)iconAry
{
    if (!_iconAry) {
        self.iconAry = [@[]mutableCopy];
    }
    return _iconAry;
}

- (NSMutableArray *)titleAry
{
    if (!_titleAry) {
        self.titleAry = [@[]mutableCopy];
    }
    return _titleAry;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mineAry = [@[]mutableCopy];
    [self setNetWork];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)person:(UIButton *)sender
{
    PersonInfomationViewController * personInformation = [[PersonInfomationViewController alloc] init];
    [self.navigationController pushViewController:personInformation animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}


- (void)setNetWork
{
    NSDictionary * dic = @{@"key":[UserManager key]};
//     if (self.bangdingState == 0) {
//
//         [WProgressHUD showHUDShowText:@"加载中..."];
//
//     }
    
    [[HttpRequestManager sharedSingleton] POST:getUserInfoURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        self.personInfo = [PersonInformationModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
        
//        if (self.bangdingState == 0) {
//            [WProgressHUD hideAllHUDAnimated:YES];
//
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"])
//            {
//                //            [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
//
//            }else
//            {
//            if (self.personInfo.mobile == nil || [self.personInfo.mobile isEqualToString:@""]) {
//                NSLog(@"手机号为空");
//
//                UIAlertView *locationAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请绑定手机号码, 便于登录使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                [locationAlert show];
//
//                self.bangdingState = 1;
//            } else {
//                NSLog(@"手机号不为空");
//            }
//            }
//
//        }
        self.nameLabel.text = self.personInfo.name;
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
        CGSize size = [self.nameLabel.text sizeWithAttributes:attrs];
        [self.nameLabel setFrame:CGRectMake(kScreenWidth / 2 - size.width,self.touxiangIcon.frame.size.height + self.touxiangIcon.frame.origin.y + 10, size.width * 2, 16)];
        
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:self.personInfo.head_img] placeholderImage:[UIImage imageNamed:@"user"]];
        
        if (self.personInfo.dorm_open == 1 && self.personInfo.nature == 2)
        {
            NSMutableArray * imgAry = [NSMutableArray arrayWithObjects:@"请假列表新",@"就寝管理新",@"修改密码新",@"绑定手机新",@"联系我们新",@"关注我们新",@"建议反馈新", nil];
            NSMutableArray * TitleAry = [NSMutableArray arrayWithObjects:@"请假列表",@"就寝管理",@"修改密码",@"绑定手机",@"联系我们",@"关注我们",@"建议反馈", nil];
            
            
            for (int i = 0; i < imgAry.count; i++) {
                NSString * img  = [imgAry objectAtIndex:i];
                NSString * title = [TitleAry objectAtIndex:i];
                NSDictionary * dic = @{@"img":img, @"title":title};
                [self.mineAry addObject:dic];
            }
            
            NSInteger width = (kScreenWidth - 60) / 3;
            for (int i = 0; i < self.mineAry.count; i++) {
                NSDictionary * dic = [self.mineAry objectAtIndex:i];
                UIView * itemView = [[UIView alloc] initWithFrame:CGRectMake(30 + width *  (i %3), 0 + 83 * (i / 3), width, 83)];
                [self.bottom addSubview:itemView];
                itemView.tag = i;
                
                UITapGestureRecognizer * itmeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itmeTap:)];
                itemView.userInteractionEnabled = YES;
                [itemView addGestureRecognizer:itmeTap];
                
                UIImageView * itemImg = [[UIImageView alloc] initWithFrame:CGRectMake(itemView.frame.size.width / 2 - 15, 20, 30, 30)];
                itemImg.image = [UIImage imageNamed:[dic objectForKey:@"img"]];
                [itemView addSubview:itemImg];
                
                UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemView.frame.size.width / 2 - 30, itemImg.frame.origin.y + itemImg.frame.size.height + 10, 60, 15)];
                nameLabel.textColor = RGB(51, 51, 51);
                nameLabel.font = [UIFont systemFontOfSize:13];
                nameLabel.text = [dic objectForKey:@"title"];
                [itemView addSubview:nameLabel];

                
            }
            
        }else
        {
             NSMutableArray * imgAry = [NSMutableArray arrayWithObjects:@"请假列表新",@"修改密码新",@"绑定手机新",@"联系我们新",@"关注我们新",@"建议反馈新", nil];
            NSMutableArray * TitleAry = [NSMutableArray arrayWithObjects:@"请假列表",@"修改密码",@"绑定手机",@"联系我们",@"关注我们",@"建议反馈", nil];
            
            for (int i = 0; i < imgAry.count; i++) {
                NSString * img  = [imgAry objectAtIndex:i];
                NSString * title = [TitleAry objectAtIndex:i];
                NSDictionary * dic = @{@"img":img, @"title":title};
                [self.mineAry addObject:dic];
            }
            
            NSInteger width = (kScreenWidth - 60) / 3;
            for (int i = 0; i < self.mineAry.count; i++) {
                NSDictionary * dic = [self.mineAry objectAtIndex:i];
                UIView * itemView = [[UIView alloc] initWithFrame:CGRectMake(30 + width *  (i %3), 0 + 83 * (i / 3), width, 83)];
                [self.bottom addSubview:itemView];
                
                itemView.tag = i;
                
                UITapGestureRecognizer * itmeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itmeTap1:)];
                itemView.userInteractionEnabled = YES;
                [itemView addGestureRecognizer:itmeTap1];
                
                UIImageView * itemImg = [[UIImageView alloc] initWithFrame:CGRectMake(itemView.frame.size.width / 2 - 15, 20, 30, 30)];
                itemImg.image = [UIImage imageNamed:[dic objectForKey:@"img"]];
                [itemView addSubview:itemImg];
                
                UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemView.frame.size.width / 2 - 30, itemImg.frame.origin.y + itemImg.frame.size.height + 10, 60, 15)];
                nameLabel.textColor = RGB(51, 51, 51);
                nameLabel.font = [UIFont systemFontOfSize:13];
                nameLabel.text = [dic objectForKey:@"title"];
                [itemView addSubview:nameLabel];
            }
        }
//        [self.mineTabelView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 有就寝管理
- (void)itmeTap:(UITapGestureRecognizer *)sender
{
    
    NSLog(@"%ld", sender.view.tag);
    switch (sender.view.tag) {
        case 0:
        {
            LeaveListViewController * leaveListVC = [[LeaveListViewController alloc] init];
            [self.navigationController pushViewController:leaveListVC animated:YES];
        }
            break;
        case 1:
        {
            JiuQinGuanLiViewController * jiuQin = [[JiuQinGuanLiViewController alloc] init];
            [self.navigationController pushViewController:jiuQin animated:YES];
        }
            break;
        case 2:
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"])
            {
                [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
                
            }else
            {
                ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
                [self.navigationController pushViewController:changePasswordVC animated:YES];
            }
        }
            break;
        case 3:
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"]) {
                [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
                
            }else
            {
                BindMobilePhoneViewController * bingMoblie = [[BindMobilePhoneViewController alloc] init];
                if (self.personInfo.mobile == nil || [self.personInfo.mobile isEqualToString:@""]) {
                    bingMoblie.typeStr = @"1";
                } else {
                    bingMoblie.typeStr = @"2";
                }
                [self.navigationController pushViewController:bingMoblie animated:YES];
            }
        }
            break;
        case 4:
        {
            if (_webView == nil) {
                _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            }
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.helperCenterModel.phone]]]];
        }
            break;
        case 5:
        {
            self.back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
            self.back.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.8];
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.back];
            
            UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(APP_WIDTH / 2 - 100, APP_HEIGHT / 2 - 100, 200, 200)];
            [img sd_setImageWithURL:[NSURL URLWithString:self.helperCenterModel.wx] placeholderImage:nil];
            [self.back addSubview:img];
            
            UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
            self.back.userInteractionEnabled = YES;
            [self.back addGestureRecognizer:imgTap];
        }
            break;
        case 6:
        {
            AdviceFeedbackViewController *adviceFeedbackVC = [[AdviceFeedbackViewController alloc] init];
            [self.navigationController pushViewController:adviceFeedbackVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 无就寝管理

- (void)itmeTap1:(UITapGestureRecognizer *)sender
{
    
    NSLog(@"%ld", sender.view.tag);
    NSLog(@"%ld", sender.view.tag);
    switch (sender.view.tag) {
        case 0:
        {
            LeaveListViewController * leaveListVC = [[LeaveListViewController alloc] init];
            [self.navigationController pushViewController:leaveListVC animated:YES];
        }
            break;
    
        case 1:
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"])
            {
                [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
                
            }else
            {
                ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
                [self.navigationController pushViewController:changePasswordVC animated:YES];
            }
        }
            break;
        case 2:
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"]) {
                [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
                
            }else
            {
                BindMobilePhoneViewController * bingMoblie = [[BindMobilePhoneViewController alloc] init];
                if (self.personInfo.mobile == nil || [self.personInfo.mobile isEqualToString:@""]) {
                    bingMoblie.typeStr = @"1";
                } else {
                    bingMoblie.typeStr = @"2";
                }
                [self.navigationController pushViewController:bingMoblie animated:YES];
            }
        }
            break;
        case 3:
        {
            if (_webView == nil) {
                _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            }
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.helperCenterModel.phone]]]];
        }
            break;
        case 4:
        {
            self.back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
            self.back.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.8];
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.back];
            
            UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(APP_WIDTH / 2 - 100, APP_HEIGHT / 2 - 100, 200, 200)];
            [img sd_setImageWithURL:[NSURL URLWithString:self.helperCenterModel.wx] placeholderImage:nil];
            [self.back addSubview:img];
            
            UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
            self.back.userInteractionEnabled = YES;
            [self.back addGestureRecognizer:imgTap];
        }
            break;
        case 5:
        {
            AdviceFeedbackViewController *adviceFeedbackVC = [[AdviceFeedbackViewController alloc] init];
            [self.navigationController pushViewController:adviceFeedbackVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (NSMutableArray *)mineAry
{
    if (!_mineAry) {
        self.mineAry = [@[]mutableCopy];
    }
    return _mineAry;
}

- (void)imgTap:(UITapGestureRecognizer *)sender
{
    [self.back removeFromSuperview];
}
//- (UITableView *)mineTabelView
//{
//    if (!_mineTabelView)
//    {
//        self.mineTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT - APP_NAVH) style:UITableViewStylePlain];
//        self.mineTabelView.backgroundColor = backColor;
//        self.mineTabelView.delegate = self;
//        self.mineTabelView.dataSource = self;
//    }
//    return _mineTabelView;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 1;
//    }else if (section == 1)
//    {
//        return self.mineAry.count;
//    }else
//    {
//        return 1;
//    }
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 0;
//    }else if (section == 1)
//    {
//        return 10;
//    }else
//    {
//        return 10;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 20)];
//    headerView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
//    return headerView;
//}
//
////有时候tableview的底部视图也会出现此现象对应的修改就好了
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0)
//    {
//        MinePersonXiXinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MinePersonXiXinCellId" forIndexPath:indexPath];
//        cell.userName.text = self.personInfo.name;
//        cell.userZiLiao.text = @"我的资料";
//
//        [cell.userImg sd_setImageWithURL:[NSURL URLWithString:self.personInfo.head_img] placeholderImage:[UIImage imageNamed:@"user"]];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else if (indexPath.section == 1)
//    {
//        ClassHomePageItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ClassHomePageItemCellId" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        if (self.mineAry.count != 0 && self.mineAry.count > indexPath.row ) {
//            NSDictionary * dic = [self.mineAry objectAtIndex:indexPath.row];
//            cell.itemImg.image = [UIImage imageNamed:[dic objectForKey:@"img"]];
//            cell.itemLabel.text = [dic objectForKey:@"title"];
//        }
//
//
//        return cell;
//    }else
//    {
//        ExitCell *  cell = [tableView dequeueReusableCellWithIdentifier:@"ExitCellId" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.exitBtn addTarget:self action:@selector(tuichuLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
//        cell.userInteractionEnabled = YES;
//        return cell;
//
//
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        return 90;
//    }else if (indexPath.section == 1)
//    {
//        return 50;
//    }else
//    {
//        return 60;
//    }
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        PersonInfomationViewController * personInformation = [[PersonInfomationViewController alloc] init];
//        [self.navigationController pushViewController:personInformation animated:YES];
//    }else if (indexPath.section == 1)
//    {
//        if (indexPath.row == 0) {
//            HelperCenterViewController * helperCenterVC = [[HelperCenterViewController alloc] init];
//            [self.navigationController pushViewController:helperCenterVC animated:YES];
//        }else if (indexPath.row == 1)
//        {
//            LeaveListViewController * leaveListVC = [[LeaveListViewController alloc] init];
//            [self.navigationController pushViewController:leaveListVC animated:YES];
//        }else if (indexPath.row == 2)
//        {
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"])
//            {
//                [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
//
//            }else
//            {
//            ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
//            [self.navigationController pushViewController:changePasswordVC animated:YES];
//            }
//        }else
//        {
//            JiuQinGuanLiViewController * jiuQin = [[JiuQinGuanLiViewController alloc] init];
//            [self.navigationController pushViewController:jiuQin animated:YES];
//        }
//    }else
//    {
//
//    }
//}

//- (void)tuichuLoginBtn:(UIButton *)sender
//{
//
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *alertT = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击退出登录");
//        [UserManager logoOut];
//        [WProgressHUD showSuccessfulAnimatedText:@"退出成功"];
//    }];
//    UIAlertAction *alertF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击了取消");
//    }];
//
//    [actionSheet addAction:alertT];
//    [actionSheet addAction:alertF];
//    [self presentViewController:actionSheet animated:YES completion:nil];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
