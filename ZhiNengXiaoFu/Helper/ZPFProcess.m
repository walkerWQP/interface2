//
//  ZPFProcess.m
//  OutputStream-01
//
//  Created by 周先森 on 16/6/8.
//  Copyright © 2016年 周先森. All rights reserved.
//

#import "ZPFProcess.h"

@implementation ZPFProcess
-(void)setProcess:(float)process {
    _process = process;
    [self setTitle:[NSString stringWithFormat:@"%0.2f%%",process * 100] forState:UIControlStateNormal];
    //重绘
    [self setNeedsDisplay];

}

/*
// Only override drawRect: if you perform custom drawing.
*/// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //获取图形上下文
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat radius = MIN(center.x, center.y) - 5;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = 2 * M_PI * self.process + startAngle;
    
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    //设置样式
        //圆角
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 5;
    [[UIColor orangeColor] setStroke];
    
    [path stroke];
}


@end
