//
//  MyViewController.m
//  ZhiNengXiaoFu
//
//  Created by duxiu on 2018/7/23.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "MyViewController.h"
#import "ExitCell.h"
#import "MyInformationCell.h"
#import "HomeworkCell.h"
#import "PersonalDataViewController.h"
#import "HelperCenterViewController.h"
#import "LoginHomePageViewController.h"
#import "OffTheListViewController.h"
#import "ChangePasswordViewController.h"
#import "OngoingTableViewController.h"
#import "PersonInformationModel.h"
#import "SleepManagementViewController.h"
#import "BindMobilePhoneViewController.h"
#import "ActivityManagementViewController.h"
#import "AdviceFeedbackViewController.h"
#import "HelperCenterModel.h"


@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView    *myTabelView;
@property (nonatomic, strong) NSMutableArray *myArr;
@property (nonatomic, strong) PersonInformationModel * model;
@property (nonatomic, strong) HelperCenterModel * helperCenterModel;
@property (nonatomic, strong) UIView * back;
@property (nonatomic, strong) UIWebView * webView;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * iconImg;
@property (nonatomic, strong)  UIImageView * touxiangIcon;

@property (nonatomic, strong) NSMutableArray * iconAry;
@property (nonatomic, strong) NSMutableArray * titleAry;
@property (nonatomic, strong)  UIView * bottom;

@end

@implementation MyViewController

- (NSMutableArray *)myArr {
    if (!_myArr) {
        _myArr = [NSMutableArray array];
    }
    return _myArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.title = @"我的";
    [self setUser];
    [self setNetWorkNew];
    
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
    self.bottom.userInteractionEnabled = YES;
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

    
}




- (void)setUser {
    NSDictionary * dic = @{@"key":[UserManager key]};
    [WProgressHUD showHUDShowText:@"加载中..."];

    [[HttpRequestManager sharedSingleton] POST:getUserInfoURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        
        [WProgressHUD hideAllHUDAnimated:YES];

        self.model = [PersonInformationModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
//        if (self.model.is_adviser == 1 && self.model.dorm_open == 1) {
//            NSMutableArray * imgAry = [NSMutableArray arrayWithObjects:@"帮助1",@"请假列表",@"修改密码",@"已发布", @"就寝管理",nil];
//            NSMutableArray * TitleAry = [NSMutableArray arrayWithObjects:@"帮助",@"请假列表",@"修改密码",@"已发布的活动", @"就寝管理", nil];
//
//            for (int i = 0; i < imgAry.count; i++) {
//                NSString * img  = [imgAry objectAtIndex:i];
//                NSString * title = [TitleAry objectAtIndex:i];
//                NSDictionary * dic = @{@"img":img, @"title":title};
//                [self.myArr addObject:dic];
//            }
//
//        }else
//        {
//            NSMutableArray * imgAry = [NSMutableArray arrayWithObjects:@"帮助1",@"请假列表",@"修改密码",@"已发布",nil];
//            NSMutableArray * TitleAry = [NSMutableArray arrayWithObjects:@"帮助",@"请假列表",@"修改密码",@"已发布的活动", nil];
//
//            for (int i = 0; i < imgAry.count; i++) {
//                NSString * img  = [imgAry objectAtIndex:i];
//                NSString * title = [TitleAry objectAtIndex:i];
//                NSDictionary * dic = @{@"img":img, @"title":title};
//                [self.myArr addObject:dic];
//            }
//        }
//
//        NSLog(@"%@",self.model.mobile);
        
    
        
       

        self.nameLabel.text = self.model.name;
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
        CGSize size = [self.nameLabel.text sizeWithAttributes:attrs];
        [self.nameLabel setFrame:CGRectMake(kScreenWidth / 2 - size.width,self.touxiangIcon.frame.size.height + self.touxiangIcon.frame.origin.y + 10, size.width * 2, 16)];
        
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:self.model.head_img] placeholderImage:[UIImage imageNamed:@"user"]];
        
        if (self.model.dorm_open == 1 && self.model.nature == 2)
        {
            NSMutableArray * imgAry = [NSMutableArray arrayWithObjects:@"请假列表新",@"已发活动新",@"就寝管理新",@"修改密码新",@"绑定手机新",@"联系我们新",@"关注我们新",@"建议反馈新", nil];
            NSMutableArray * TitleAry = [NSMutableArray arrayWithObjects:@"请假管理",@"已发活动",@"就寝管理",@"修改密码",@"绑定手机",@"联系我们",@"关注我们",@"建议反馈", nil];
            
            
            for (int i = 0; i < imgAry.count; i++) {
                NSString * img  = [imgAry objectAtIndex:i];
                NSString * title = [TitleAry objectAtIndex:i];
                NSDictionary * dic = @{@"img":img, @"title":title};
                [self.myArr  addObject:dic];
            }
            
            NSInteger width = (kScreenWidth - 60) / 3;
            for (int i = 0; i < self.myArr .count; i++) {
                NSDictionary * dic = [self.myArr  objectAtIndex:i];
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
            NSMutableArray * imgAry = [NSMutableArray arrayWithObjects:@"请假列表新",@"已发活动新",@"修改密码新",@"绑定手机新",@"联系我们新",@"关注我们新",@"建议反馈新", nil];
            NSMutableArray * TitleAry = [NSMutableArray arrayWithObjects:@"请假管理",@"已发活动",@"修改密码",@"绑定手机",@"联系我们",@"关注我们",@"建议反馈", nil];
            
            for (int i = 0; i < imgAry.count; i++) {
                NSString * img  = [imgAry objectAtIndex:i];
                NSString * title = [TitleAry objectAtIndex:i];
                NSDictionary * dic = @{@"img":img, @"title":title};
                [self.myArr  addObject:dic];
            }
            
            NSInteger width = (kScreenWidth - 60) / 3;
            for (int i = 0; i < self.myArr .count; i++) {
                NSDictionary * dic = [self.myArr  objectAtIndex:i];
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


- (void)person:(UIButton *)sender
{
    PersonalDataViewController *personalDataVC = [[PersonalDataViewController alloc] init];
    [self.navigationController pushViewController:personalDataVC animated:YES];
}

#pragma mark ======= 就寝管理 =======
- (void)itmeTap:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 0:
        {
            NSLog(@"请假列表");
            OffTheListViewController *offTheListVC = [OffTheListViewController new];
            [self.navigationController pushViewController:offTheListVC animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"已发活动");
            ActivityManagementViewController *activityManagementVC = [ActivityManagementViewController new];
            [self.navigationController pushViewController:activityManagementVC animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"点击就寝管理");
            SleepManagementViewController * sleepManagementVC = [[SleepManagementViewController alloc] init];
            [self.navigationController pushViewController:sleepManagementVC animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"修改密码");
            ChangePasswordViewController *changePasswordVC = [ChangePasswordViewController new];
            [self.navigationController pushViewController:changePasswordVC animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"绑定手机");
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"])
            {
                [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
                
            }else
            {
                BindMobilePhoneViewController *bingMoblie = [[BindMobilePhoneViewController alloc] init];
                if (self.model.mobile == nil || [self.model.mobile isEqualToString:@""]) {
                    bingMoblie.typeStr = @"1";
                } else {
                    bingMoblie.typeStr = @"2";
                }
                
                [self.navigationController pushViewController:bingMoblie animated:YES];
            }
        }
            break;
        case 5:
        {
            NSLog(@"联系我们");
            if (_webView == nil) {
                _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            }
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.helperCenterModel.phone]]]];
        }
            break;
        case 6:
        {
            NSLog(@"关注我们");
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
        case 7:
        {
            NSLog(@"建议反馈");
            AdviceFeedbackViewController *adviceFeedbackVC = [AdviceFeedbackViewController new];
            [self.navigationController pushViewController:adviceFeedbackVC animated:YES];
        }
            break;
       
            
        default:
            break;
    }
}

#pragma mark ======= 无就寝管理 =======
- (void)itmeTap1:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 0:
        {
            OffTheListViewController *offTheListVC = [OffTheListViewController new];
            [self.navigationController pushViewController:offTheListVC animated:YES];
        }
            break;
        case 1:
        {
            ActivityManagementViewController *activityManagementVC = [ActivityManagementViewController new];
            [self.navigationController pushViewController:activityManagementVC animated:YES];
        }
            break;
        case 2:
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"]) {
                [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
            }else
            {
                NSLog(@"修改密码");
                ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
                [self.navigationController pushViewController:changePasswordVC animated:YES];
            }
        }
            break;
        case 3:
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"])
            {
                [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
                
            }else
            {
                BindMobilePhoneViewController *bingMoblie = [[BindMobilePhoneViewController alloc] init];
                if (self.model.mobile == nil || [self.model.mobile isEqualToString:@""]) {
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
            NSLog(@"拨打电话");
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
            AdviceFeedbackViewController *adviceFeedbackVC = [AdviceFeedbackViewController new];
            [self.navigationController pushViewController:adviceFeedbackVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)imgTap:(UITapGestureRecognizer *)sender
{
    [self.back removeFromSuperview];
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


//- (UITableView *)myTabelView {
//    if (!_myTabelView) {
//        self.myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT - APP_NAVH) style:UITableViewStylePlain];
//        self.myTabelView.backgroundColor = backColor;
//        self.myTabelView.delegate = self;
//        self.myTabelView.dataSource = self;
//        self.myTabelView.separatorStyle = UITableViewCellEditingStyleNone;
//    }
//    return _myTabelView;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    } else if (section == 1) {
//        return self.myArr.count;
//    } else {
//        return 1;
//    }
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0;
//    }else if (section == 1) {
//        return 10;
//    } else {
//        return 10;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 10)];
//    headerView.backgroundColor = backColor;
//    return headerView;
//}
//
////有时候tableview的底部视图也会出现此现象对应的修改就好了
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return nil;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0)
//    {
//        MyInformationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyInformationCellId" forIndexPath:indexPath];
//        cell.userName.text = self.model.name;
//        cell.userZiLiao.text = @"我的资料";
//
//        if (self.model.head_img == nil)
//        {
//            cell.userImg.image = [UIImage imageNamed:@"user"];
//        } else
//        {
//            [cell.userImg sd_setImageWithURL:[NSURL URLWithString:self.model.head_img] placeholderImage:[UIImage imageNamed:@"user"]];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    } else if (indexPath.section == 1) {
//        HomeworkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkCellId" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (self.myArr.count != 0) {
//            NSDictionary * dic = [self.myArr objectAtIndex:indexPath.row];
//            cell.itemImg.image = [UIImage imageNamed:[dic objectForKey:@"img"]];
//            cell.itemLabel.text = [dic objectForKey:@"title"];
//        }
//
//        return cell;
//    } else
//    {
//        ExitCell *  cell = [tableView dequeueReusableCellWithIdentifier:@"ExitCellId" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.exitBtn addTarget:self action:@selector(exitBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//        return cell;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 90;
//    } else if (indexPath.section == 1) {
//        return 50;
//    } else {
//        return 50;
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        PersonalDataViewController *personalDataVC = [[PersonalDataViewController alloc] init];
//        [self.navigationController pushViewController:personalDataVC animated:YES];
//    } else if (indexPath.section == 1) {
//        switch (indexPath.row) {
//            case 0:
//            {
//                NSLog(@"1");
//                HelperCenterViewController *helpCenterVC = [[HelperCenterViewController alloc] init];
//                [self.navigationController pushViewController:helpCenterVC animated:YES];
//            }
//                break;
//            case 1:
//            {
//                NSLog(@"请假列表");
//                OffTheListViewController *offTheListVC = [[OffTheListViewController alloc] init];
//                [self.navigationController pushViewController:offTheListVC animated:YES];
//
//            }
//                break;
//            case 2:
//            {
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"youkeState"] isEqualToString:@"1"]) {
//                    [WProgressHUD showErrorAnimatedText:@"游客不能进行此操作"];
//                }else
//                {
//                    NSLog(@"修改密码");
//                    ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
//                    [self.navigationController pushViewController:changePasswordVC animated:YES];
//                }
//            }
//                break;
//            case 3:
//            {
//                NSLog(@"我的活动");
//                OngoingTableViewController *ongoingTableViewC = [[OngoingTableViewController alloc] init];
//                [self.navigationController pushViewController:ongoingTableViewC animated:YES];
//
//            }
//                break;
//            case 4:
//            {
//                NSLog(@"点击就寝管理");
//                SleepManagementViewController * sleepManagementVC = [[SleepManagementViewController alloc] init];
//                [self.navigationController pushViewController:sleepManagementVC animated:YES];
//            }
//            default:
//                break;
//        }
//    } else if (indexPath.section == 2) {
//        NSLog(@"退出登录");
//    }
//}
//
//- (void)exitBtn : (UIButton *)sender
//{
//    NSLog(@"点击退出");
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *alertT = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击退出登录");
//        [self tuichuLogin];
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
//
//- (void)tuichuLogin
//{
//    [UserManager logoOut];
//    [WProgressHUD showSuccessfulAnimatedText:@"退出成功"];
//
//}

@end
