//
//  SchoolDongTaiViewController.m
//  ZhiNengXiaoFu
//
//  Created by mac on 2018/7/25.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "SchoolDongTaiViewController.h"
#import "TeacherTongZhiCell.h"
#import "SchoolDongTaiDetailsViewController.h"
#import "SchoolDongTaiModel.h"
#import "SchoolTongTaiMoreCell.h"

@interface SchoolDongTaiViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *schoolDynamicTableView;
@property (nonatomic, strong) NSMutableArray *schoolDynamicArr;
@property (nonatomic, assign) NSInteger     page;
@property (nonatomic, strong) NSMutableArray *bannerArr;

@end

@implementation SchoolDongTaiViewController

- (NSMutableArray *)schoolDynamicArr {
    if (!_schoolDynamicArr) {
        _schoolDynamicArr = [NSMutableArray array];
    }
    return _schoolDynamicArr;
}

- (NSMutableArray *)bannerArr {
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.schoolDynamicTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"学校动态";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.page = 1;
    [self.view addSubview:self.schoolDynamicTableView];
    self.schoolDynamicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getBannersURLData];

    [self.schoolDynamicTableView registerClass:[SchoolTongTaiMoreCell class] forCellReuseIdentifier:@"SchoolTongTaiMoreCellId"];
    //下拉刷新
    self.schoolDynamicTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //自动更改透明度
    self.schoolDynamicTableView.mj_header.automaticallyChangeAlpha = YES;
    //进入刷新状态
    [self.schoolDynamicTableView.mj_header beginRefreshing];
    //上拉刷新
    self.schoolDynamicTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
}

- (void)loadNewTopic {
    self.page = 1;
    [self.schoolDynamicArr removeAllObjects];
    [self setNetWork:self.page];
}

- (void)loadMoreTopic {
    self.page += 1;
    [self setNetWork:self.page];
}

- (void)getBannersURLData {
    NSDictionary *dic = @{@"key":[UserManager key],@"t_id":@"6"};
    NSLog(@"%@",[UserManager key]);
    [[HttpRequestManager sharedSingleton] POST:bannersURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            
            self.bannerArr = [BannerModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            
            [self.schoolDynamicTableView reloadData];
            
            
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

- (void)setNetWork:(NSInteger)page
{
    NSDictionary * dic = @{@"key":[UserManager key],@"page":[NSString stringWithFormat:@"%ld",page]};
    [[HttpRequestManager sharedSingleton] POST:dynamicGetList parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        //结束头部刷新
        [self.schoolDynamicTableView.mj_header endRefreshing];
        //结束尾部刷新
        [self.schoolDynamicTableView.mj_footer endRefreshing];
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            NSMutableArray *arr = [SchoolDongTaiModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            for (SchoolDongTaiModel *model in arr) {
                [self.schoolDynamicArr addObject:model];
            }
            [self.schoolDynamicTableView reloadData];
        }else
        {
            if ([[responseObject objectForKey:@"status"] integerValue] == 401 || [[responseObject objectForKey:@"status"] integerValue] == 402) {
                [UserManager logoOut];
            }else
            {
                
            }
            [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];

        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        SchoolDongTaiDetailsViewController * schoolDongTaivc = [[SchoolDongTaiDetailsViewController alloc] init];
        if (self.schoolDynamicArr.count != 0) {
            
            SchoolDongTaiModel * model = [self.schoolDynamicArr objectAtIndex:indexPath.row];
            
            schoolDongTaivc.schoolDongTaiId = model.ID;
        }
        [self.navigationController pushViewController:schoolDongTaivc animated:YES];
    
   
    
}


- (UITableView *)schoolDynamicTableView {
    if (!_schoolDynamicTableView) {
        self.schoolDynamicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT - APP_NAVH) style:UITableViewStylePlain];
        self.schoolDynamicTableView.backgroundColor = [UIColor whiteColor];
        self.schoolDynamicTableView.delegate = self;
        self.schoolDynamicTableView.dataSource = self;
        _schoolDynamicTableView.estimatedRowHeight = 0;
        _schoolDynamicTableView.estimatedSectionHeaderHeight = 0;
        _schoolDynamicTableView.estimatedSectionFooterHeight = 0;
    }
    return _schoolDynamicTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

//有时候tableview的底部视图也会出现此现象对应的修改就好了
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
     return self.schoolDynamicArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        static NSString *CellIdentifier = @"TableViewCell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//        }else{
//            //删除cell中的子对象,刷新覆盖问题。
//            while ([cell.contentView.subviews lastObject] != nil) {
//                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
//            }
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIImageView * imgs = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 170)];
//        if (self.bannerArr.count == 0) {
//            //            imgs.image = [UIImage imageNamed:@"教师端活动管理banner"];
//        } else {
//            BannerModel * model = [self.bannerArr objectAtIndex:0];
//            [imgs sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"教师端活动管理banner"]];
//        }
//        [cell addSubview:imgs];
//        return cell;
//    }else
//    {
        SchoolTongTaiMoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolTongTaiMoreCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

         if (self.schoolDynamicArr.count != 0) {
        SchoolDongTaiModel * model = [self.schoolDynamicArr objectAtIndex:indexPath.row];
        
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
        cell.titleLabel.text = model.title;
        cell.timeLabel.text = model.create_time;
             cell.contentLabel.text = model.content;
         }
        return cell;
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        return 170;
//    }else
//    {
        return (kScreenWidth - 30) * 119 / 364 + 10;
//    }
    
}



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
