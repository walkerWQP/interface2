//
//  UploadVideoViewController.m
//  ZhiNengXiaoFu
//
//  Created by duxiu on 2018/7/26.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "UploadVideoViewController.h"
#import "ForClassViewController.h"
#import "PublicClassViewController.h"


@interface UploadVideoViewController ()

@property (nonatomic,strong) JohnTopTitleView *titleView;

@end

@implementation UploadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名师在线";
    [self makeUploadVideoViewControllerUI];
}

- (void)makeUploadVideoViewControllerUI {
    NSArray *titleArray = [NSArray arrayWithObjects:@"公开课",@"收费课",nil];
    self.titleView.title = titleArray;
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
}

- (NSArray <UIViewController *>*)setChildVC{
    //公开课
    PublicClassViewController *publicClassVC = [[PublicClassViewController alloc]init];
    //收费课
    ForClassViewController *forClassVC = [[ForClassViewController alloc]init];
    NSArray *childVC = [NSArray arrayWithObjects:publicClassVC,forClassVC, nil];
    return childVC;
}

- (JohnTopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _titleView;
}

@end
