//
//  ParentXueTangViewController.m
//  ZhiNengXiaoFu
//
//  Created by mac on 2018/7/30.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "ParentXueTangViewController.h"
#import "ChildJiaoYuViewController.h"
#import "HeartHealtyViewController.h"
@interface ParentXueTangViewController ()

@property (nonatomic,strong) JohnTopTitleView *titleView;

@end

@implementation ParentXueTangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR(246, 246, 246, 1);
    self.title = @"家长学堂";
    [self createUI];
}

- (void)createUI{
    NSArray *titleArray = [NSArray arrayWithObjects:@"子女教育",@"心理健康", nil];
    self.titleView.title = titleArray;
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
}

- (NSArray <UIViewController *>*)setChildVC{
    ChildJiaoYuViewController * vc1 = [[ChildJiaoYuViewController alloc]init];
    HeartHealtyViewController *vc2 = [[HeartHealtyViewController alloc]init];
    NSArray *childVC = [NSArray arrayWithObjects:vc1,vc2, nil];
    return childVC;
}

#pragma mark - getter
- (JohnTopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _titleView;
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
