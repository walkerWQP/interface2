//
//  PublicClassCell.m
//  ZhiNengXiaoFu
//
//  Created by duxiu on 2018/7/30.
//  Copyright © 2018年 henanduxiu. All rights reserved.
//

#import "PublicClassCell.h"

@implementation PublicClassCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makePublicClassCellUI];
    }
    return self;
}

- (void)makePublicClassCellUI {
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT * 0.3)];
    self.imgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imgView];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT * 0.3)];
    self.bgView.backgroundColor = touMColor;
    [self.imgView addSubview:self.bgView];
    
    self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake((APP_WIDTH - 60) / 2, (self.bgView.frame.size.height - 60) / 2, 60, 60)];
    self.playBtn.layer.masksToBounds = YES;
    self.playBtn.layer.masksToBounds = YES;
    self.playBtn.layer.cornerRadius = 30;
    self.playBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.playBtn.layer.borderWidth = 1.0f;
    [self.playBtn setImage:[UIImage imageNamed:@"播放按钮"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.playBtn];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bgView.frame.size.height + 10, APP_WIDTH * 0.6, 30)];
    self.contentLabel.textColor = titlColor;
    self.contentLabel.font = titFont;
    [self.contentView addSubview:self.contentLabel];
    
    self.setUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(APP_WIDTH - 60, self.bgView.frame.size.height + 10, 50, 30)];
    self.setUpBtn.backgroundColor = THEMECOLOR;
    self.setUpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.setUpBtn setTitle:@"设置" forState:UIControlStateNormal];
    self.setUpBtn.titleLabel.font = contentFont;
    [self.contentView addSubview:self.setUpBtn];
    self.setUpBtn.hidden = YES;
    
    
    
}

@end
