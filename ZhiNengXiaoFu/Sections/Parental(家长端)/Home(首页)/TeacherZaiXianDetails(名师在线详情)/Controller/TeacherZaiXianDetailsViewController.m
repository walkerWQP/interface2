//
//  TeacherZaiXianDetailsViewController.m
//  ZhiNengXiaoFu
//
//  Created by mac on 2018/7/30.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "TeacherZaiXianDetailsViewController.h"
#import "JohnTopTitleView.h"
#import "KeChengJieShaoViewController.h"
#import "ShiPinListViewController.h"
#import "TeacherZaiXianDetailsModel.h"
#import "CLPlayerView.h"
#import "UIView+CLSetRect.h"
#import "TeacherZaiXianModel.h"

@interface TeacherZaiXianDetailsViewController ()

@property (nonatomic,weak) CLPlayerView                 *playerView;
@property (nonatomic,strong) JohnTopTitleView           *titleView;
@property (nonatomic,strong) TeacherZaiXianDetailsModel * teacherZaiXianDetailsModel;
@property (nonatomic, strong) UIView                    *contentView;

@end

@implementation TeacherZaiXianDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    [self setNetWork:self.teacherZaiXianDetailsId];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiPinList:) name:@"shipinListBoFang" object:nil];
}

- (void)shiPinList:(NSNotification *)nofity {
   TeacherZaiXianModel * model =  [[nofity object] objectForKey:@"SchoolDongTaiModel"];
    [self.playerView removeFromSuperview];
    [_playerView destroyPlayer];
    _playerView = nil;
    [self setNetWorkN:model.ID];
}

-  (void)setNetWorkN:(NSString *)str {
    NSDictionary *dic = @{@"key":[UserManager key], @"id":str};
    [[HttpRequestManager sharedSingleton] POST:indexOnlineVideoById parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 200) {
            self.teacherZaiXianDetailsModel = [TeacherZaiXianDetailsModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            self.title = self.teacherZaiXianDetailsModel.title;
            if ([self.teacherZaiXianDetailsModel.video_url isEqualToString:@""]) {
                UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 200)];
                [back sd_setImageWithURL:[NSURL URLWithString:self.teacherZaiXianDetailsModel.img] placeholderImage:nil];
                [self.view addSubview:back];
            } else {
                [self setBoFang];
            }
            
        } else {
            if ([[responseObject objectForKey:@"status"] integerValue] == 401 || [[responseObject objectForKey:@"status"] integerValue] == 402) {
                [UserManager logoOut];
                [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];
            } else if ([[responseObject objectForKey:@"status"] integerValue] == 405) {
                UIImageView * back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 200)];
                [back sd_setImageWithURL:[NSURL URLWithString:self.teacherZaiXianDetailsModel.img] placeholderImage:nil];
                [self.view addSubview:back];
            } else {
                [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)setNetWork:(NSString *)str {
    NSDictionary *dic = @{@"key":[UserManager key], @"id":str};
    [[HttpRequestManager sharedSingleton] POST:indexOnlineVideoById parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        self.teacherZaiXianDetailsModel = [TeacherZaiXianDetailsModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
        self.title = self.teacherZaiXianDetailsModel.title;
//        [self createUI];
        [self makeContentViewUI];
        if ([[responseObject objectForKey:@"status"] integerValue] == 200 ) {
            if ([self.teacherZaiXianDetailsModel.video_url isEqualToString:@""]) {
                UIImageView * back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 200)];
                [back sd_setImageWithURL:[NSURL URLWithString:self.teacherZaiXianDetailsModel.img] placeholderImage:nil];
                [self.view addSubview:back];
            } else {
                [self setBoFang];
            }
            
        } else {
            if ([[responseObject objectForKey:@"status"] integerValue] == 401 || [[responseObject objectForKey:@"status"] integerValue] == 402) {
                [UserManager logoOut];
                [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];
            } else if ([[responseObject objectForKey:@"status"] integerValue] == 405) {
                UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 200)];
                [back sd_setImageWithURL:[NSURL URLWithString:self.teacherZaiXianDetailsModel.img] placeholderImage:nil];
                [self.view addSubview:back];
            } else {
                [WProgressHUD showErrorAnimatedText:[responseObject objectForKey:@"msg"]];
            }
        }
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)setBoFang {
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.CLwidth, 200)];
    
    _playerView = playerView;
    [self.view addSubview:_playerView];
    
    //    //重复播放，默认不播放
         _playerView.repeatPlay = YES;
    //    //当前控制器是否支持旋转，当前页面支持旋转的时候需要设置，告知播放器
    _playerView.isLandscape = YES;
    //    //设置等比例全屏拉伸，多余部分会被剪切
    //    _playerView.fillMode = ResizeAspectFill;
    //    //设置进度条背景颜色
    //    _playerView.progressBackgroundColor = [UIColor purpleColor];
    //    //设置进度条缓冲颜色
    //    _playerView.progressBufferColor = [UIColor redColor];
    //    //设置进度条播放完成颜色
    //    _playerView.progressPlayFinishColor = [UIColor greenColor];
    //    //全屏是否隐藏状态栏
    //    _playerView.fullStatusBarHidden = NO;
    //    //是否静音，默认NO
    //    _playerView.mute = YES;
    //    //转子颜色
    //    _playerView.strokeColor = [UIColor redColor];
    //视频地址
    //     _playerView.url = [NSURL URLWithString:@"http://c31.aipai.com/user/128/31977128/1006/card/44340096/card.mp4?l=f&ip=1"];
    _playerView.url = [NSURL URLWithString:self.teacherZaiXianDetailsModel.video_url];
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
        //查询是否是全屏状态
        NSLog(@"%d",_playerView.isFullScreen);
    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        //        [_playerView destroyPlayer];
        //        _playerView = nil;
        NSLog(@"播放完成");
    }];
}

#pragma mark -- 需要设置全局支持旋转方向，然后重写下面三个方法可以让当前页面支持多个方向
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return YES;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


- (void)makeContentViewUI {
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 50)];
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius  = 25;
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.teacherZaiXianDetailsModel.head_img]] placeholderImage:[UIImage imageNamed:@"user"]];
    [self.contentView addSubview:headImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 + headImgView.frame.size.width, 25, 90, 20)];
    nameLabel.textColor = RGB(51, 51, 51);
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.text = self.teacherZaiXianDetailsModel.name;
    [self.contentView addSubview:nameLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(APP_WIDTH - 100, 30, 90, 20)];
    numLabel.textColor = RGB(170, 170, 170);
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.text = self.teacherZaiXianDetailsModel.name;
    if (self.teacherZaiXianDetailsModel.view > 9999) {
        CGFloat num = self.teacherZaiXianDetailsModel.view / 10000;
        numLabel.text = [NSString stringWithFormat:@"播放数:%.1f", num];
    } else {
        numLabel.text = [NSString stringWithFormat:@"播放数:%ld", self.teacherZaiXianDetailsModel.view];
    }
    numLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:numLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, headImgView.frame.size.height + 20, APP_WIDTH - 40, 1)];
    lineView.backgroundColor = RGB(238, 238, 238);
    [self.contentView addSubview:lineView];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, headImgView.frame.size.height + 30, 200, 20)];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.text = @"内容简介";
    typeLabel.textColor = RGB(51, 51, 51);
    typeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:typeLabel];
    
   UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, headImgView.frame.size.height + typeLabel.frame.size.height + 40, APP_WIDTH - 40, 100)];
    NSString *labelStr = self.teacherZaiXianDetailsModel.content;
    CGSize labelSize = {0, 0};
    labelSize = [labelStr sizeWithFont:[UIFont systemFontOfSize:12]
                     constrainedToSize:CGSizeMake(200.0, 5000)
                         lineBreakMode:NSLineBreakByWordWrapping];
    contentLabel.numberOfLines = 0;//表示label可以多行显示
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    contentLabel.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentLabel.frame.size.width, labelSize.height);//保持原来Label的位置和宽度，只是改变高度。
    contentLabel.textColor = RGB(102, 102, 102);
    contentLabel.text = labelStr;
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.isTop = YES;
    [self.contentView addSubview:contentLabel];
    
    
}


- (void)createUI {
    NSArray *titleArray = [NSArray arrayWithObjects:@"视频介绍",@"相关推荐", nil];
    self.titleView.title = titleArray;
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
}

- (NSArray <UIViewController *>*)setChildVC {
    KeChengJieShaoViewController * vc1 = [[KeChengJieShaoViewController alloc]init];
    vc1.teacherZaiXianDetailsModel = self.teacherZaiXianDetailsModel;
    ShiPinListViewController *vc2 = [[ShiPinListViewController alloc]init];
    vc2.teacherZaiXianDetailsModel = self.teacherZaiXianDetailsModel;
    NSArray *childVC = [NSArray arrayWithObjects:vc1,vc2, nil];
    return childVC;
}

#pragma mark - getter
//- (JohnTopTitleView *)titleView {
//    if (!_titleView) {
//        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height)];
//    }
//    return _titleView;
//}

-(void)viewDidDisappear:(BOOL)animated {
    [_playerView destroyPlayer];
    _playerView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
