//
//  CourseManagementViewController.m
//  ZhiNengXiaoFu
//
//  Created by duxiu on 2018/7/26.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "CourseManagementViewController.h"

@interface CourseManagementViewController ()

@property (nonatomic, strong) UIImageView  *bgimgView;

@end

@implementation CourseManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"右脑开发";
    self.bgimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    self.bgimgView.image = [UIImage imageNamed:@"右脑开发"];
    [self.view addSubview:self.bgimgView];
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
