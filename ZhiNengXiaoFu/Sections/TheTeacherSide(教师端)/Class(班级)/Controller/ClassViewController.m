//
//  ClassViewController.m
//  ZhiNengXiaoFu
//
//  Created by duxiu on 2018/7/23.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "ClassViewController.h"
#import "TeacherNotifiedCell.h"
#import "TeacherNotifiedModel.h"
#import "TheClassInformationViewController.h"

@interface ClassViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *classArr;
@property (nonatomic, strong) UICollectionView *classCollectionView;
@property (nonatomic, strong) UIImageView  *headImgView;
@property (nonatomic, strong) UIImageView * zanwushuju;
@property (nonatomic, strong) NSMutableArray *bannerArr;
@end

@implementation ClassViewController

- (NSMutableArray *)bannerArr {
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

- (NSMutableArray *)classArr {
    if (!_classArr) {
        self.classArr = [@[]mutableCopy];
    }
    return _classArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.title = @"班级管理";
    [self getBannersURLData];
    [self getClassData];
    [self makeClassViewControllerUI];
    self.zanwushuju = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 105 / 2, 200, 105, 111)];
    self.zanwushuju.image = [UIImage imageNamed:@"暂无数据家长端"];
    self.zanwushuju.alpha = 0;
    [self.classCollectionView addSubview:self.zanwushuju];
    
}

- (void)getBannersURLData {
    NSDictionary *dic = @{@"key":[UserManager key],@"t_id":@"2"};
    NSLog(@"%@",[UserManager key]);
    [[HttpRequestManager sharedSingleton] POST:bannersURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            
            self.bannerArr = [BannerModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            if (self.bannerArr.count == 0) {
                self.headImgView.image = [UIImage imageNamed:@"教师端活动管理banner"];
            } else {
                BannerModel * model = [self.bannerArr objectAtIndex:0];
                [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"教师端活动管理banner"]];
                [self.classCollectionView reloadData];
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

- (void)getClassData {
    
    NSDictionary *dic = @{@"key":[UserManager key]};
    [[HttpRequestManager sharedSingleton] POST:getClassURL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            
            self.classArr = [TeacherNotifiedModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            if (self.classArr.count == 0) {
                self.zanwushuju.alpha = 1;
            } else {
                self.zanwushuju.alpha = 0;
                [self.classCollectionView reloadData];
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

- (void)makeClassViewControllerUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(190, 0, 0, 0);
    self.classCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT) collectionViewLayout:layout];
    self.classCollectionView.backgroundColor = backColor;
    self.classCollectionView.delegate = self;
    self.classCollectionView.dataSource = self;
    [self.view addSubview:self.classCollectionView];
    
    [self.classCollectionView registerClass:[TeacherNotifiedCell class] forCellWithReuseIdentifier:TeacherNotifiedCell_CollectionView];
    
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 170)];
    self.headImgView.backgroundColor = [UIColor clearColor];
    [self.classCollectionView addSubview:self.headImgView];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.classArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewCell *gridcell = nil;
    TeacherNotifiedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeacherNotifiedCell_CollectionView forIndexPath:indexPath];
    if (self.classArr.count != 0) {
        TeacherNotifiedModel *model = [self.classArr objectAtIndex:indexPath.row];
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:nil];
        cell.classLabel.text = model.name;
        gridcell = cell;
    }
    
    return gridcell;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeZero;
    
    itemSize = CGSizeMake(APP_WIDTH, 70);
    
    return itemSize;
}


//点击响应方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TeacherNotifiedModel *model = [self.classArr objectAtIndex:indexPath.row];
    TheClassInformationViewController *theClassInformationVC = [TheClassInformationViewController new];
    theClassInformationVC.ID = model.ID;
    [self.navigationController pushViewController:theClassInformationVC animated:YES];
    
}



@end
