//
//  ForClassViewController.m
//  ZhiNengXiaoFu
//
//  Created by duxiu on 2018/7/30.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "ForClassViewController.h"
#import "PublicClassCell.h"
#import "PublicClassModel.h"
#import "VideoSettingsViewController.h"
#import "TeacherZaiXianDetailsViewController.h"

@interface ForClassViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView      *noDataImgView;
@property (nonatomic, strong) NSMutableArray   *forClassArr;
@property (nonatomic, strong) UICollectionView *forClassCollectionView;
@property (nonatomic, assign) NSInteger        page;
@property (nonatomic, strong) NSString         *urlStr;


@end

@implementation ForClassViewController

- (NSMutableArray *)forClassArr {
    if (!_forClassArr) {
        _forClassArr = [NSMutableArray array];
    }
    return _forClassArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.page = 1;
    [self makeForClassViewControllerUI];
    self.noDataImgView = [[UIImageView alloc] initWithFrame:CGRectMake(APP_WIDTH / 2 - 105 / 2, 200, 105, 111)];
    self.noDataImgView.image = [UIImage imageNamed:@"暂无数据家长端"];
    self.noDataImgView.alpha = 0;
    [self.view addSubview:self.noDataImgView];
    //下拉刷新
    self.forClassCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //自动更改透明度
    self.forClassCollectionView.mj_header.automaticallyChangeAlpha = YES;
    //进入刷新状态
    [self.forClassCollectionView.mj_header beginRefreshing];
    //上拉刷新
    self.forClassCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)loadNewTopic {
    self.page = 1;
    [self.forClassArr removeAllObjects];
    [self getDataFromMyPublishListURL:self.page];
}

- (void)loadMoreTopic {
    self.page += 1;
    [self getDataFromMyPublishListURL:self.page];
}

- (void)getDataFromMyPublishListURL:(NSInteger)page {
    NSDictionary *dic = @{@"key":[UserManager key],@"is_charge":@"0",@"page":[NSString stringWithFormat:@"%ld",page]};
    [[HttpRequestManager sharedSingleton] POST:myPublishListURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //结束头部刷新
        [self.forClassCollectionView.mj_header endRefreshing];
        //结束尾部刷新
        [self.forClassCollectionView.mj_footer endRefreshing];
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            NSMutableArray *arr = [PublicClassModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            for (PublicClassModel *model in arr) {
                [self.forClassArr addObject:model];
            }
            if (self.forClassArr.count == 0) {
                self.noDataImgView.alpha = 1;
            } else {
                self.noDataImgView.alpha = 0;
                [self.forClassCollectionView reloadData];
            }
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

- (void)makeForClassViewControllerUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.forClassCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT - APP_NAVH - 40) collectionViewLayout:layout];
    self.forClassCollectionView.backgroundColor = backColor;
    self.forClassCollectionView.delegate = self;
    self.forClassCollectionView.dataSource = self;
    [self.view addSubview:self.forClassCollectionView];
    [self.forClassCollectionView registerClass:[PublicClassCell class] forCellWithReuseIdentifier:PublicClassCell_CollectionView];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.forClassArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    PublicClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PublicClassCell_CollectionView forIndexPath:indexPath];
    if (self.forClassArr.count != 0) {
        PublicClassModel *model = [self.forClassArr objectAtIndex:indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
        cell.contentLabel.text = model.title;
        self.urlStr = model.url;
        [cell.playBtn addTarget:self action:@selector(playBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.setUpBtn addTarget:self action:@selector(setUpBtn:) forControlEvents:UIControlEventTouchUpInside];
        gridcell = cell;
    }
    return gridcell;
}

- (void)playBtn : (UIButton *)sender {
    NSLog(@"点击播放按钮");
    TeacherZaiXianDetailsViewController *teacherZaiXianDetailsVC = [[TeacherZaiXianDetailsViewController alloc] init]; teacherZaiXianDetailsVC.teacherZaiXianDetailsId = self.urlStr;
    [self.navigationController pushViewController:teacherZaiXianDetailsVC animated:YES];
}

- (void)setUpBtn : (UIButton *)sender {
    NSLog(@"点击设置");
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeZero;
    itemSize = CGSizeMake(APP_WIDTH, APP_HEIGHT * 0.3 + 50);
    return itemSize;
}


//点击响应方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.forClassArr.count != 0) {
        PublicClassModel *model = [self.forClassArr objectAtIndex:indexPath.row];
        TeacherZaiXianDetailsViewController *teacherZaiXianDetailsVC = [[TeacherZaiXianDetailsViewController alloc] init];
        if (model.ID == nil) {
            [WProgressHUD showErrorAnimatedText:@"数据不正确,请重试"];
        } else {
            teacherZaiXianDetailsVC.teacherZaiXianDetailsId = model.ID;
            [self.navigationController pushViewController:teacherZaiXianDetailsVC animated:YES];
        }
    }
}

@end
