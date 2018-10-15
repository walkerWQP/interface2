//
//  HomePageJViewController.m
//  ZhiNengXiaoFu
//
//  Created by 独秀科技 on 2018/9/28.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "HomePageJViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "HomePageJingJiView.h"
#import "WorkCell.h"
#import "SchoolDongTaiCell.h"
#import "HomePageTongZhiView.h"

#import "SchoolDongTaiViewController.h"
#import "TongZhiViewController.h"

#import "NewDynamicsViewController.h"
#import "NewGuidelinesViewController.h"
#import "HomeWorkPViewController.h"
#import "ParentXueTangNewViewController.h"
#import "TeacherZaiXianTotalViewController.h"
#import "CompetitiveActivityViewController.h"
#import "DCCycleScrollView.h"
#import "HomeBannerModel.h"
#import "TongZhiDetailsViewController.h"
#import "WorkDetailsViewController.h"
#import "JingJiActivityDetailsViewController.h"
#import "SchoolDongTaiDetailsViewController.h"
#import "WenTiZiXunViewController.h"
@interface HomePageJViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource, UITableViewDelegate, UITableViewDataSource, HomePageJingJiViewDelegate, DCCycleScrollViewDelegate>

@property (nonatomic, strong) NSString  * schoolName;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UITableView * HomePageJTabelView;
@property (nonatomic, strong) UIImageView * img;

@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) NSMutableArray  *imgArr;

@property (nonatomic, strong) DCCycleScrollView *banner;

@property (nonatomic, strong) NSMutableArray * tongzhiAry;
@property (nonatomic, strong) NSMutableArray * workAry;
@property (nonatomic, strong) NSMutableArray * jingJiAry;
@property (nonatomic, strong) NSMutableArray * dongtaiAry;


@end

@implementation HomePageJViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image1 = [UIImage imageNamed:@"banner"];
    UIImage *image2 = [UIImage imageNamed:@"bannerHelper"];
    UIImage *image3 = [UIImage imageNamed:@"教师端活动管理banner"];
    UIImage *image4 = [UIImage imageNamed:@"banner"];
    UIImage *image5 = [UIImage imageNamed:@"请假列表背景图"];
    self.imageArray = [NSMutableArray arrayWithObjects:image1,image2,image3, image4,image5,nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUser];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:self.HomePageJTabelView];
    
    self.HomePageJTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.HomePageJTabelView registerNib:[UINib nibWithNibName:@"WorkCell" bundle:nil] forCellReuseIdentifier:@"WorkCellId"];
    [self.HomePageJTabelView registerNib:[UINib nibWithNibName:@"SchoolDongTaiCell" bundle:nil] forCellReuseIdentifier:@"SchoolDongTaiCellId"];
    [self getIndexURLData];

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

- (NSMutableArray *)tongzhiAry {
    if (!_tongzhiAry) {
        _tongzhiAry = [NSMutableArray array];
    }
    return _tongzhiAry;
}

//点击图片的代理
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index = %ld",(long)index);
    BannerModel *model = self.bannerArr[index];
    NSLog(@"%@",model.ID);
    NSLog(@"%@",model.url);
}

#pragma mark ======= 获取首页数据 =======

- (void)getIndexURLData {
    NSDictionary *dic = @{@"key":[UserManager key]};
    [[HttpRequestManager sharedSingleton] POST:indexURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            [self.bannerArr removeAllObjects];
            [self.imgArr removeAllObjects];
            NSLog(@"%@",[responseObject objectForKey:@"data"]);
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            self.bannerArr = [HomeBannerModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"banner"]];
            for (NSDictionary *bannerDict in [dataDic objectForKey:@"banner"]) {
                HomeBannerModel *model = [[HomeBannerModel alloc] init];
                model.img = [bannerDict objectForKey:@"img"];
                [self.imgArr addObject:model.img];
            }
            
            self.tongzhiAry = [dataDic objectForKey:@"notice"];
            self.workAry = [dataDic objectForKey:@"homework"];
            self.jingJiAry = [dataDic objectForKey:@"activity"];
            self.dongtaiAry = [dataDic objectForKey:@"dynamic"];
            
            if (self.imgArr.count == 0) {
                UIImage *image1 = [UIImage imageNamed:@"banner"];
                UIImage *image2 = [UIImage imageNamed:@"bannerHelper"];
                UIImage *image3 = [UIImage imageNamed:@"教师端活动管理banner"];
                UIImage *image4 = [UIImage imageNamed:@"banner"];
                UIImage *image5 = [UIImage imageNamed:@"请假列表背景图"];
                self.imgArr = [NSMutableArray arrayWithObjects:image1,image2,image3, image4,image5,nil];
            }
            
            [self.HomePageJTabelView reloadData];
            
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

- (UITableView *)HomePageJTabelView
{
    if (!_HomePageJTabelView) {
        self.HomePageJTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - APP_NAVH) style:UITableViewStyleGrouped];
        self.HomePageJTabelView.delegate = self;
        self.HomePageJTabelView.dataSource = self;
    }
    return _HomePageJTabelView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5 ) {
        return self.dongtaiAry.count;
    }else if (section == 3) {
        return self.workAry.count;
    }
    else
    {
        return 1;

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 155;
    }else if (indexPath.section == 1)
    {
        return 90;
    }else if (indexPath.section == 2)
    {
        return 75;
    }else if (indexPath.section == 3)
    {
        return 80;

    }else if (indexPath.section == 4)
    {
         return (kScreenWidth - 40) / 3 * 144 / 235 + 25;
    }else
    {
        return 104;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        //    banner.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
        //    banner.cellPlaceholderImage = [UIImage imageNamed:@"placeholderImage"];
        self.banner.autoScrollTimeInterval = 3;
        self.banner.autoScroll = YES;
        self.banner.isZoom = YES;
        self.banner.itemSpace = 0;
        self.banner.imgCornerRadius = 10;
        self.banner.itemWidth = self.view.frame.size.width - 100;
        self.banner.delegate = self;
        [cell addSubview:self.banner];
        
        
//        NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 150)];
//        pageFlowView.delegate = self;
//        pageFlowView.dataSource = self;
//        pageFlowView.minimumPageAlpha = 0.1;
//        pageFlowView.isCarousel = NO;
//        pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
//        pageFlowView.isOpenAutoScroll = YES;
        
        //初始化pageControl
        //    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 32, Width, 8)];
        //    pageFlowView.pageControl = pageControl;
        //    [pageFlowView addSubview:pageControl];
//        [pageFlowView reloadData];
//
//        [cell addSubview:pageFlowView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else  if (indexPath.section == 1)
    {
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
        
        NSMutableArray * imgAry = [NSMutableArray arrayWithObjects:@"名师在线",@"新生指南",@"家长学堂",@"问题咨询",@"成长手册", nil];
        NSMutableArray * titleAry = [NSMutableArray arrayWithObjects:@"名师在线",@"新生指南",@"家长学堂",@"问题咨询",@"班级圈子", nil];
        NSInteger width = (kScreenWidth - 50 - 40 * 5) / 4;
        
        for (int i = 0; i < 5; i++) {
            
            UIButton * back = [[UIButton alloc] initWithFrame:CGRectMake(25 + i * (40 + width), 10, 40, 40)];
            [back setBackgroundImage:[UIImage imageNamed:[imgAry objectAtIndex:i]] forState:UIControlStateNormal];
            [back addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchDown];
            back.tag = i;
//            back.image = [UIImage imageNamed:[imgAry objectAtIndex:i]];
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
    }else if (indexPath.section == 2)
    {
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
        
        UITapGestureRecognizer * tongzhiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tongzhiTap:)];
        tongZhiImg.userInteractionEnabled = YES;
        [tongZhiImg addGestureRecognizer:tongzhiTap];
        
        
        if (self.tongzhiAry.count > 0) {
            HomePageTongZhiView *ccspView=[[HomePageTongZhiView alloc] initWithFrame:CGRectMake(46 + 15 + 10, 0, kScreenWidth, 60)];
            ccspView.titleArray = self.tongzhiAry;
            [ccspView setClickLabelBlock:^(NSInteger index, NSString * _Nonnull titleString) {
                [self setClick:index];
            }];
            [cell addSubview:ccspView];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 10)];
            lineView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
            [cell addSubview:lineView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        return cell;
    }else if (indexPath.section == 3)
    {
        WorkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WorkCellId" forIndexPath:indexPath];
        NSDictionary * dic = [self.workAry objectAtIndex:indexPath.row];
        [cell.WorkImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"head_img"]] placeholderImage:[UIImage imageNamed:@"user"]];
        cell.WorkTitleLabel.text = [dic objectForKey:@"title"];
        cell.WorkConnectLabel.text = [dic objectForKey:@"course_name"];
        cell.WorkTimeLabel.text = [dic objectForKey:@"create_time"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if (indexPath.section == 4)
    {
        
        static NSString *CellIdentifier = @"TableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }else{
            //删除cell中的子对象,刷新覆盖问题。
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor=[UIColor colorWithRed:32/ 255.0 green:32 / 255.0 blue:32 / 255.0 alpha:1.0f];
        
        cell.userInteractionEnabled = YES;
//        NSMutableArray * ary = [NSMutableArray arrayWithObjects:@"开学典礼",@"参观活动",@"运动会", nil];
        NSArray *array=[NSArray arrayWithArray:self.jingJiAry];
        HomePageJingJiView *view=[[HomePageJingJiView alloc] init];
        view.frame=CGRectMake(0,0, kScreenWidth,  (kScreenWidth - 40) / 3 * 144 / 235 + 25);
        view.HomePageJingJiViewDelegate = self;
        [view setDetail:array];
        
        [cell.contentView addSubview:view];
        return cell;
       
    }else
    {
        
        SchoolDongTaiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolDongTaiCellId" forIndexPath:indexPath];
        NSDictionary * dic = [self.dongtaiAry objectAtIndex:indexPath.row];
        [cell.SchoolDongTaiImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]]];
        cell.SchoolDongTaiTitleLabel.text = [dic objectForKey:@"title"];
        cell.SchoolDongTaiConnectLabel.text = [dic objectForKey:@"content"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3 || section == 4 || section == 5) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        header.backgroundColor = [UIColor whiteColor];
        header.userInteractionEnabled = YES;
        if (section == 3)
        {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 15, 12)];
            self.img.image = [UIImage imageNamed:@"查看作业"];
        }else if (section == 4)
        {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 15, 15)];
            self.img.image = [UIImage imageNamed:@"竞技活动头"];
        }else
        {
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 14, 16)];
            self.img.image = [UIImage imageNamed:@"学校动态头"];
        }
       
        [header addSubview:self.img];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.img.frame.origin.x + self.img.frame.size.width + 5, 10, 200, 20)];
        if (section == 3)
        {
            titleLabel.text = @"查看作业";
        }else if (section == 4)
        {
            titleLabel.text = @"竞技活动";
        }else
        {
            titleLabel.text = @"学校动态";
        }
        
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
        titleLabel.textColor = RGB(51, 51, 51);
        [header addSubview:titleLabel];
        
       
        
        UILabel * moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 55, 14, 25, 12)];
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
        
        return header;
    }else
    {
        return nil;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//有时候tableview的底部视图也会出现此现象对应的修改就好了
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        WorkDetailsViewController * workDetailsVC = [[WorkDetailsViewController alloc] init];
        if (self.workAry.count != 0) {
            NSDictionary * model = [self.workAry objectAtIndex:indexPath.row];
            workDetailsVC.workId = [model objectForKey:@"id"];
        }
        [self.navigationController pushViewController:workDetailsVC animated:YES];
    }else if (indexPath.section == 5)
    {
        SchoolDongTaiDetailsViewController *schoolDongTaiDetailsVC = [[SchoolDongTaiDetailsViewController alloc] init];
        if (self.dongtaiAry.count != 0) {
            NSDictionary * model = [self.dongtaiAry objectAtIndex:indexPath.row];
             schoolDongTaiDetailsVC.schoolDongTaiId  = [model objectForKey:@"id"];
        }
        [self.navigationController pushViewController:schoolDongTaiDetailsVC animated:YES];
        
    }
}

- (void)headerTap:(UITapGestureRecognizer *)sender
{
    if (sender.view.tag == 3) {
        HomeWorkPViewController * homeWorkVC = [[HomeWorkPViewController alloc] init];
        [self.navigationController pushViewController:homeWorkVC animated:YES];
        
    }else if (sender.view.tag == 4)
    {
        CompetitiveActivityViewController * comeptitiveActivityVC = [[CompetitiveActivityViewController alloc] init];
        [self.navigationController pushViewController:comeptitiveActivityVC animated:YES];
    }else if (sender.view.tag == 5)
    {
        SchoolDongTaiViewController * schoolDongTaiVC = [[SchoolDongTaiViewController alloc] init];
        [self.navigationController pushViewController:schoolDongTaiVC animated:YES];
    }
    
}

- (void)jumpToAnswerHomePageJingJi:(NSString *)answerStr weizhi:(NSString *)weizhi
{
    JingJiActivityDetailsViewController *jingJiActivityDetailsVC = [JingJiActivityDetailsViewController new];
    jingJiActivityDetailsVC.JingJiActivityDetailsId = answerStr;
    [self.navigationController pushViewController:jingJiActivityDetailsVC animated:YES];
    
}

- (void)setClick:(NSInteger)index
{
    NSLog(@"%ld", index);
    TongZhiDetailsViewController * tongZhiDetails  = [[TongZhiDetailsViewController alloc] init];
 
    tongZhiDetails.tongZhiId = [NSString stringWithFormat:@"%ld", index];

    [self.navigationController pushViewController:tongZhiDetails animated:YES];
}

#pragma mark  - 点击通知图标
- (void)tongzhiTap:(UITapGestureRecognizer *)sender
{
    TongZhiViewController * teacherTongZhiVC = [[TongZhiViewController alloc] init];
    [self.navigationController pushViewController:teacherTongZhiVC animated:YES];
}

- (void)backBtn:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            TeacherZaiXianTotalViewController * teacherZaiXianVC = [[TeacherZaiXianTotalViewController alloc] init];
            [self.navigationController pushViewController:teacherZaiXianVC animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"新生指南");
            NewGuidelinesViewController *newGuidelinesVC = [NewGuidelinesViewController new];
            [self.navigationController pushViewController:newGuidelinesVC animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"家长学堂");
            ParentXueTangNewViewController * parentX = [[ParentXueTangNewViewController alloc] init];
            [self.navigationController pushViewController:parentX animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"问题咨询");
            WenTiZiXunViewController * wenTiZiXunVC = [[WenTiZiXunViewController alloc] init];
            [self.navigationController pushViewController:wenTiZiXunVC animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"班级圈子");
            NewDynamicsViewController *newDynamicsVC = [NewDynamicsViewController new];
            newDynamicsVC.typeStr = @"1";
            [self.navigationController pushViewController:newDynamicsVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if (section == 3 || section == 4 || section == 5) {
         return 40;
     }else
     {
         return 0;
     }
}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kScreenWidth - 60, (kScreenWidth - 60) * 9 / 16);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
    
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}


#pragma mark --懒加载
//- (NSMutableArray *)imageArray
//{
//    if (_imageArray == nil)
//    {
//        _imageArray = [NSMutableArray array];
//    }
//    return _imageArray;
//}


#pragma mark ======= 获取个人信息数据 =======
- (void)setUser
{
    NSDictionary * dic = @{@"key":[UserManager key]};
    [[HttpRequestManager sharedSingleton] POST:getUserInfoURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
