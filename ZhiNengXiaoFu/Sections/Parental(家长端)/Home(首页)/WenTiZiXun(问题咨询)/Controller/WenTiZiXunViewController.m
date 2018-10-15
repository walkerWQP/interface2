//
//  WenTiZiXunViewController.m
//  ZhiNengXiaoFu
//
//  Created by mac on 2018/7/30.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "WenTiZiXunViewController.h"
#import "MyZiXunViewController.h"
#import "YiHuiFuViewController.h"
#import "WeiHuiFuViewController.h"
#import "JohnTopTitleView.h"

@interface WenTiZiXunViewController ()

@property (nonatomic, strong) UITableView * WenTiZiXunTableView;
@property (nonatomic,strong) JohnTopTitleView *titleView;

@end

@implementation WenTiZiXunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的咨询";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"咨询" style:UIBarButtonItemStyleDone target:self action:@selector(rightButton:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self createUI];
    
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];

    if([[pushJudge objectForKey:@"notify"]isEqualToString:@"push"])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回(1)"] style:UIBarButtonItemStylePlain target:self action:@selector(rebackToRootViewAction)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@""forKey:@"notify"];
        [pushJudge synchronize];//记得立即同步
        
    }else
    {
        
    }
}

- (void)rebackToRootViewAction {
    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@""forKey:@"notify"];
    [pushJudge synchronize];//记得立即同步
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createUI{
    NSArray *titleArray = [NSArray arrayWithObjects:@"已回复",@"未回复", nil];
    self.titleView.title = titleArray;
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
}

- (NSArray <UIViewController *>*)setChildVC{
    YiHuiFuViewController * vc1 = [[YiHuiFuViewController alloc]init];
    WeiHuiFuViewController *vc2 = [[WeiHuiFuViewController alloc]init];
    NSArray *childVC = [NSArray arrayWithObjects:vc1,vc2, nil];
    return childVC;
}

#pragma mark - getter
- (JohnTopTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _titleView;
}

- (void)rightButton:(UIBarButtonItem *)sender
{
    MyZiXunViewController * myZiXunVC = [[MyZiXunViewController alloc] init];
    [self.navigationController pushViewController:myZiXunVC animated:YES];
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
