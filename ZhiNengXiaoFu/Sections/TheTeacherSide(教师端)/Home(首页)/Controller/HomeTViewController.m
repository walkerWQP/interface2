//
//  HomeTViewController.m
//  ZhiNengXiaoFu
//
//  Created by duxiu on 2018/10/10.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "HomeTViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "HomePageJingJiView.h"
#import "WorkCell.h"
#import "WorkTableViewCell.h"
#import "SchoolDongTaiCell.h"
#import "HomePageTongZhiView.h"
#import "OffTheListViewController.h"
#import "NewGuidelinesViewController.h"
#import "PublishJobModel.h"
#import "NewDynamicsViewController.h"
#import "TeacherNotifiedViewController.h"
#import "HomeBannerModel.h"
#import "DCCycleScrollView.h"
#import "ConsultingViewController.h"
#import "SchoolDongTaiViewController.h"
#import "SchoolTongZhiViewController.h"
#import "TeacherNotifiedModel.h"
#import "HomeWorkViewController.h"
#import "ActivityManagementViewController.h"
#import "TongZhiDetailsViewController.h"
#import "WorkDetailsViewController.h"
#import "JingJiActivityDetailsViewController.h"
#import "SchoolDongTaiDetailsViewController.h"


@interface HomeTViewController ()<NewPagedFlowViewDelegate, UITableViewDelegate, UITableViewDataSource, HomePageJingJiViewDelegate,DCCycleScrollViewDelegate>


@property (nonatomic, strong) NSString  * schoolName;
@property (nonatomic, strong) UITableView * HomePageJTabelView;
@property (nonatomic, strong) UIImageView * img;
@property (nonatomic, strong) NSMutableArray *publishJobArr;
@property (nonatomic, strong) NSString  *classID;
@property (nonatomic, strong) NSString  *className;
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) NSMutableArray  *imgArr;
@property (nonatomic, strong) DCCycleScrollView *banner;
@property (nonatomic, strong) NSMutableArray *classArr;
@property (nonatomic, strong) NSMutableArray *activityArr;

@property (nonatomic, strong) NSMutableArray *tongzhiAry;
@property (nonatomic, strong) NSMutableArray *jingjiAry;
@property (nonatomic, strong) NSMutableArray *dongtaiAry;
@property (nonatomic, strong) HomePageTongZhiView *ccspView;

@end

@implementation HomeTViewController

- (NSMutableArray *)activityArr {
    if (!_activityArr)
    {
        _activityArr = [NSMutableArray array];
    }
    return _activityArr;
}

- (NSMutableArray *)classArr {
    if (!_classArr) {
        _classArr = [NSMutableArray array];
    }
    return _classArr;
}

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

- (NSMutableArray *)bannerArr {
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

- (NSMutableArray *)publishJobArr {
    if (!_publishJobArr) {
        _publishJobArr = [NSMutableArray array];
    }
    return _publishJobArr;
}

- (NSMutableArray *)tongzhiAry {
    if (!_tongzhiAry) {
        _tongzhiAry = [NSMutableArray array];
    }
    return _tongzhiAry;
}

- (NSMutableArray *)jingjiAry {
    if (!_jingjiAry) {
        _jingjiAry = [NSMutableArray array];
    }
    return _jingjiAry;
}

- (NSMutableArray *)dongtaiAry {
    if (!_dongtaiAry) {
        _dongtaiAry = [NSMutableArray array];
    }
    return _dongtaiAry;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    [self setUser];
    [self getIndexURLData];
    [self.view addSubview:self.HomePageJTabelView];
    self.HomePageJTabelView.backgroundColor = [UIColor whiteColor];
    self.HomePageJTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.HomePageJTabelView registerClass:[WorkTableViewCell class] forCellReuseIdentifier:@"WorkTableViewCellId"];
    
    [self.HomePageJTabelView registerNib:[UINib nibWithNibName:@"SchoolDongTaiCell" bundle:nil] forCellReuseIdentifier:@"SchoolDongTaiCellId"];
    
    //下拉刷新
    self.HomePageJTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getIndexURLData)];
    //自动更改透明度
    self.HomePageJTabelView.mj_header.automaticallyChangeAlpha = YES;
    //进入刷新状态
    [self.HomePageJTabelView.mj_header beginRefreshing];
}



- (UITableView *)HomePageJTabelView {
    if (!_HomePageJTabelView) {
        self.HomePageJTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - APP_NAVH - APP_TABH) style:UITableViewStyleGrouped];
        self.HomePageJTabelView.delegate = self;
        self.HomePageJTabelView.dataSource = self;
    }
    return _HomePageJTabelView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.classArr.count;
    } else if (section == 5){
        return self.dongtaiAry.count;
    } else {
        return 1;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    } else if (indexPath.section == 1) {
        return 90;
    } else if (indexPath.section == 2) {
        return 75;
    } else if (indexPath.section == 3) {
        return 71;
    } else if (indexPath.section == 4) {
        return (kScreenWidth - 40) / 3 * 144 / 235 + 25;
    } else {
        return 104;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"TableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        } else {
            //删除cell中的子对象,刷新覆盖问题。
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.banner removeAllSubviews];
        self.banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 150) shouldInfiniteLoop:YES imageGroups:self.imgArr];
        self.banner.autoScrollTimeInterval = 3;
        self.banner.autoScroll = YES;
        self.banner.isZoom = YES;
        self.banner.itemSpace = 0;
        self.banner.imgCornerRadius = 10;
        self.banner.itemWidth = self.view.frame.size.width - 100;
        self.banner.delegate = self;
        [cell addSubview:self.banner];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"TableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        } else {
            //删除cell中的子对象,刷新覆盖问题。
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        NSMutableArray * imgAry = [NSMutableArray arrayWithObjects:@"请假列表",@"问题咨询1",@"班级圈子",@"老师通知",@"新生指南1", nil];
        NSMutableArray * titleAry = [NSMutableArray arrayWithObjects:@"请假列表",@"问题咨询",@"班级圈子",@"老师通知",@"新生指南", nil];
        NSInteger width = (kScreenWidth - 50 - 40 * 5) / 4;
        for (int i = 0; i < 5; i++) {
            
            UIButton * back = [[UIButton alloc] initWithFrame:CGRectMake(25 + i * (40 + width), 10, 40, 40)];
            [back setBackgroundImage:[UIImage imageNamed:[imgAry objectAtIndex:i]] forState:UIControlStateNormal];
            [back addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchDown];
            back.tag = i;
            [cell addSubview:back];

            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(back.frame.origin.x - 5, back.frame.origin.y + back.frame.size.height + 5, 50, 15)];
            titleLabel.text = [titleAry objectAtIndex:i];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = RGB(119, 119, 119);
            [cell addSubview:titleLabel];
        }
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 10)];
        lineView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
        [cell addSubview:lineView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        [ self.ccspView removeTimer];

        static NSString *CellIdentifier = @"TableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        } else {
            //删除cell中的子对象,刷新覆盖问题。
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        UIImageView * tongZhiImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 46, 39)];
        tongZhiImg.image = [UIImage imageNamed:@"通知New"];
        [cell addSubview:tongZhiImg];
        
        UITapGestureRecognizer *tongzhiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tongzhiTap:)];
        tongZhiImg.userInteractionEnabled = YES;
        [tongZhiImg addGestureRecognizer:tongzhiTap];
        
        if (self.tongzhiAry.count > 0) {
            self.ccspView =[[HomePageTongZhiView alloc] initWithFrame:CGRectMake(46 + 15 + 10, 0, kScreenWidth, 60)];
            self.ccspView.titleArray = self.tongzhiAry;
            [self.ccspView setClickLabelBlock:^(NSInteger index, NSString * _Nonnull titleString) {
                [self setClick:index];
            }];
            [cell addSubview:self.ccspView];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 10)];
            lineView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
            [cell.contentView addSubview:lineView];
        }

        return cell;
        
    } else if (indexPath.section == 3) {
        
        WorkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WorkTableViewCellId" forIndexPath:indexPath];
        TeacherNotifiedModel *model = self.classArr[indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:@"user"]];
        cell.titleLabel.text = model.name;
        if (indexPath.row == self.classArr.count - 1) {
            cell.lineView.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    } else if (indexPath.section == 4) {
        static NSString *CellIdentifier = @"TableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        } else {
            //删除cell中的子对象,刷新覆盖问题。
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor colorWithRed:32/ 255.0 green:32 / 255.0 blue:32 / 255.0 alpha:1.0f];

        NSArray *array=[NSArray arrayWithArray:self.jingjiAry];
        HomePageJingJiView *view=[[HomePageJingJiView alloc] init];
        view.frame=CGRectMake(0,0, kScreenWidth,  (kScreenWidth - 30) / 2.9 * 144 / 235 + 25);
        view.HomePageJingJiViewDelegate = self;
        [view setDetail:array];
        [cell.contentView addSubview:view];
        return cell;
        
    } else {
        SchoolDongTaiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolDongTaiCellId" forIndexPath:indexPath];
        NSDictionary * dic = [self.dongtaiAry objectAtIndex:indexPath.row];
        [cell.SchoolDongTaiImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]]];
        cell.SchoolDongTaiTitleLabel.text = [dic objectForKey:@"title"];
        cell.SchoolDongTaiConnectLabel.text = [dic objectForKey:@"content"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

//有时候tableview的底部视图也会出现此现象对应的修改就好了
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3 || section == 4 || section == 5) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        header.backgroundColor = [UIColor whiteColor];
        if (section == 3) {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 15, 12)];
            self.img.image = [UIImage imageNamed:@"查看作业"];
        } else if (section == 4) {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 15, 15)];
            self.img.image = [UIImage imageNamed:@"竞技活动头"];
        } else {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 14, 16)];
            self.img.image = [UIImage imageNamed:@"学校动态头"];
        }
        
        [header addSubview:self.img];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.img.frame.origin.x + self.img.frame.size.width + 5, 10, 200, 20)];
        if (section == 3) {
            titleLabel.text = @"作业管理";
        } else if (section == 4) {
            titleLabel.text = @"活动管理";
        } else {
            titleLabel.text = @"学校动态";
        }
        
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
        titleLabel.textColor = RGB(51, 51, 51);

        [header addSubview:titleLabel];
        
        if (section != 3) {
            UILabel * moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 14, 25, 12)];
            moreLabel.text = @"更多";
            moreLabel.textColor = RGB(170, 170, 170);
            moreLabel.font = [UIFont systemFontOfSize:12];
            [header addSubview:moreLabel];
            
            UITapGestureRecognizer * headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
            moreLabel.userInteractionEnabled = YES;
            moreLabel.tag = section;
            [moreLabel addGestureRecognizer:headerTap];
            
            UIImageView * moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width + 4, 14, 12, 12)];
            moreImg.image = [UIImage imageNamed:@"返回"];
            [header addSubview:moreImg];
        }
        
        return header;
    } else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 || section == 4 || section == 5) {
        return 40;
    } else {
        return 0;
    }
}

- (void)jumpToAnswerHomePageJingJi:(NSString *)answerStr weizhi:(NSString *)weizhi {
    JingJiActivityDetailsViewController *jingJiActivityDetailsVC = [JingJiActivityDetailsViewController new];
    jingJiActivityDetailsVC.JingJiActivityDetailsId = answerStr;
    [self.navigationController pushViewController:jingJiActivityDetailsVC animated:YES];
    
}

- (void)setClick:(NSInteger)index {
    
    TongZhiDetailsViewController * tongZhiDetails  = [[TongZhiDetailsViewController alloc] init];
    tongZhiDetails.tongZhiId = [NSString stringWithFormat:@"%ld", index];
    [self.navigationController pushViewController:tongZhiDetails animated:YES];
}

#pragma mark ======= 首页各个点击事件 =======

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            NSLog(@"0");
        }
            break;
        case 1:
        {
            NSLog(@"1");
        }
            break;
        case 2:
        {
            NSLog(@"2");
        }
            break;
        case 3:
        {
            NSLog(@"3");
            TeacherNotifiedModel *model = self.classArr[indexPath.row];
            NSLog(@"%@",model.name);
            NSLog(@"%@",model.ID);
            HomeWorkViewController *homeWorkVC = [HomeWorkViewController new];
            homeWorkVC.titleStr = model.name;
            homeWorkVC.ID = model.ID;
            [self.navigationController pushViewController:homeWorkVC animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"4");
        }
            break;
        case 5:
        {
            SchoolDongTaiDetailsViewController *schoolDongTaiDetailsVC = [[SchoolDongTaiDetailsViewController alloc] init];
            if (self.dongtaiAry.count != 0)
            {
                NSDictionary * model = [self.dongtaiAry objectAtIndex:indexPath.row];
                schoolDongTaiDetailsVC.schoolDongTaiId  = [model objectForKey:@"id"];
            }
            [self.navigationController pushViewController:schoolDongTaiDetailsVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ======= 轮播图点击事件 =======
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *model = self.bannerArr[index];
    NSLog(@"%@",model.ID);
    NSLog(@"%@",model.url);
}

#pragma mark  - 点击通知图标
- (void)tongzhiTap:(UITapGestureRecognizer *)sender {
    SchoolTongZhiViewController *schoolTongZhiVC = [[SchoolTongZhiViewController alloc] init];
    schoolTongZhiVC.typeStr = @"1";
    [self.navigationController pushViewController:schoolTongZhiVC animated:YES];
}

- (void)headerTap:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == 3) {
        NSLog(@"作业管理");
        
    } else if (sender.view.tag == 4) {
        NSLog(@"活动管理");
        ActivityManagementViewController *activityManagementVC = [ActivityManagementViewController new];
        [self.navigationController pushViewController:activityManagementVC animated:YES];
        
    } else if (sender.view.tag == 5) {
        SchoolDongTaiViewController * schoolDongTaiVC = [[SchoolDongTaiViewController alloc] init];
        [self.navigationController pushViewController:schoolDongTaiVC animated:YES];
    }
    
}


#pragma mark ======= 五个图标点击事件 =======
- (void)backBtn:(UIButton *)sender {

    switch (sender.tag) {
        case 0:
        {
            OffTheListViewController *offTheListVC = [OffTheListViewController new];
            [self.navigationController pushViewController:offTheListVC animated:YES];
        }
            break;
            case 1:
        {
            NSLog(@"问题咨询");
            ConsultingViewController *consultingVC = [ConsultingViewController new];
            [self.navigationController pushViewController:consultingVC animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"班级圈子");
            [self getClassURLData2];
        }
            break;
        case 3:
        {
            NSLog(@"老师通知");
            TeacherNotifiedViewController *teacherNotifiedVC = [TeacherNotifiedViewController new];
            [self.navigationController pushViewController:teacherNotifiedVC animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"新生指南");
            NewGuidelinesViewController *newGuidelinesVC = [NewGuidelinesViewController new];
            [self.navigationController pushViewController:newGuidelinesVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kScreenWidth - 60, (kScreenWidth - 60) * 9 / 16);
}


- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}


#pragma mark ======= 获取首页数据 =======

- (void)getIndexURLData {
    NSDictionary *dic = @{@"key":[UserManager key]};
    [[HttpRequestManager sharedSingleton] POST:indexURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            [self.bannerArr removeAllObjects];
            [self.imgArr removeAllObjects];
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            self.bannerArr = [HomeBannerModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"banner"]];
            for (NSDictionary *bannerDict in [dataDic objectForKey:@"banner"]) {
                
                HomeBannerModel *model = [[HomeBannerModel alloc] init];
                model.img = [bannerDict objectForKey:@"img"];
                [self.imgArr addObject:model.img];
            }
            if (self.imgArr.count == 0) {
                UIImage *image1 = [UIImage imageNamed:@"banner"];
                UIImage *image2 = [UIImage imageNamed:@"bannerHelper"];
                UIImage *image3 = [UIImage imageNamed:@"教师端活动管理banner"];
                UIImage *image4 = [UIImage imageNamed:@"banner"];
                UIImage *image5 = [UIImage imageNamed:@"请假列表背景图"];
                self.imgArr = [NSMutableArray arrayWithObjects:image1,image2,image3, image4,image5,nil];
            }
            
            self.classArr = [TeacherNotifiedModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"homework"]];
            self.tongzhiAry = [dataDic objectForKey:@"notice"];
            self.jingjiAry = [dataDic objectForKey:@"activity"];
            self.dongtaiAry = [dataDic objectForKey:@"dynamic"];

            [self.HomePageJTabelView reloadData];
            [self.HomePageJTabelView.mj_header endRefreshing];

        } else {
            if ([[responseObject objectForKey:@"status"] integerValue] == 401 || [[responseObject objectForKey:@"status"] integerValue] == 402) {
                [UserManager logoOut];
            } else {
                
            }
            [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];
            [self.HomePageJTabelView.mj_header endRefreshing];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark ======= 获取个人信息数据 =======
- (void)setUser {
    NSDictionary * dic = @{@"key":[UserManager key]};
    [[HttpRequestManager sharedSingleton] POST:getUserInfoURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            
            self.schoolName = [[responseObject objectForKey:@"data"] objectForKey:@"school_name"];
            UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 44)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = self.schoolName;
            self.navigationItem.titleView = titleLabel;
            
        } else {
            if ([[responseObject objectForKey:@"status"] integerValue] == 401 || [[responseObject objectForKey:@"status"] integerValue] == 402) {
                [UserManager logoOut];
            } else {
                
            }
            [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)getClassURLData2 {
    [WProgressHUD showHUDShowText:@"正在加载中..."];
    NSDictionary *dic = @{@"key":[UserManager key]};
    [[HttpRequestManager sharedSingleton] POST:getClassURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [WProgressHUD hideAllHUDAnimated:YES];
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            self.publishJobArr = [PublishJobModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            NSMutableArray *ary = [@[]mutableCopy];
            for (PublishJobModel * model in self.publishJobArr) {
                [ary addObject:[NSString stringWithFormat:@"%@", model.ID]];
            }
            NSMutableArray *ary1 = [@[]mutableCopy];
            for (PublishJobModel * model in self.publishJobArr) {
                [ary1 addObject:[NSString stringWithFormat:@"%@", model.name]];
            }
            if (ary.count == 0 || ary1.count == 0) {
                [WProgressHUD showErrorAnimatedText:@"数据不正确,请重试"];
            } else {
                self.className = ary1[0];
                self.classID = ary[0];
                NewDynamicsViewController *newDynamicsVC = [NewDynamicsViewController new];
                newDynamicsVC.classID = self.classID;
                newDynamicsVC.className = self.className;
                [self.navigationController pushViewController:newDynamicsVC animated:YES];
            }
            
        } else {
            if ([[responseObject objectForKey:@"status"] integerValue] == 401 || [[responseObject objectForKey:@"status"] integerValue] == 402)
            {
                [UserManager logoOut];
            } else {
                
            }
            [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


@end
