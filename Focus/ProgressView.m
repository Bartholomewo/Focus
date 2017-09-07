//
//  ProgressView.m
//  Focus
//
//  Created by 赵恒 on 2017/9/7.
//  Copyright © 2017年 Bartholomew. All rights reserved.
//

#import "ProgressView.h"

// 设置固定1800秒
static NSInteger fixedSecond = 1800;
// 设置初始的弧度
static NSInteger fixedAngle = 360;

@implementation ProgressView {
    UILabel *_currentTaskLabel;
    BezierView *_bezierView;
}

#pragma mark ================== ProgressView ====================
- (void) setupProgressView {
    // 任务button
    [UIButton.maker
     .com_setup(self)
     .btn_insets(UIEdgeInsetsMake(ppx(20), 0, ppx(20), ppx(40)), mk_Image)
     .btn_image([UIImage imageNamed:@"foucs_home_task"], mk_Normal, NO) mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.top.mas_equalTo(ppx(40));
         make.size.mas_equalTo(CGSizeMake(ppx(80), ppx(80)));
     }];
    
    // 设置button
    [UIButton.maker
     .com_setup(self)
     .btn_insets(UIEdgeInsetsMake(ppx(20), ppx(40), ppx(20), 0), mk_Image)
     .btn_image([UIImage imageNamed:@"foucs_home_setting"], mk_Normal, NO) mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(ppx(40));
         make.right.mas_equalTo(ppx(-40));
         make.size.mas_equalTo(CGSizeMake(ppx(80), ppx(80)));
     }];
    
    // 中间的view
    _bezierView = (BezierView *)[BezierView maker]
    .com_setup(self)
    .com_backgroundColor(@"#ffffff")
    .com_cornerRadius(ppx(20));
    [_bezierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ppx(40));
        make.right.mas_equalTo(ppx(-40));
        make.top.mas_equalTo(ppx(160));
        make.bottom.mas_equalTo(ppx(-120));
    }];
    [_bezierView drawCircle];
    [_bezierView startTheTimer];
    
    _currentTaskLabel = [UILabel maker]
    .com_setup(self)
    .lab_font1(ppx(28))
    .lab_text(@"当前任务")
    .lab_textAlignment(mk_Center)
    .lab_textColor(@"#ffffff");
    [_currentTaskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ppx(40));
        make.right.mas_equalTo(ppx(-40));
        make.bottom.mas_equalTo(self.mas_bottom).offset(ppx(-40));
        make.height.mas_equalTo(ppx(28));
    }];
}
- (void)updateCurrentTask:(NSString *)task {
    _currentTaskLabel.lab_text(task);
}

@end



@implementation BezierView {
    UILabel         *_timeLabel;
    UIView          *_progressView;
    CAShapeLayer    *_unFixedLayer;
}

- (void)drawRect:(CGRect)rect {
    [[MakerUntil mk_colorWithHexString:kMainColor] set];
    // 右上角的开始和暂停贝塞尔曲线
    UIBezierPath *rightTopSEPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width, 0)
                                                                  radius:ppx(150)
                                                              startAngle:0
                                                                endAngle:kDEGREES(360)
                                                               clockwise:NO];
    [rightTopSEPath fill];
    // 左下角
    UIBezierPath *leftBottomSEPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, self.bounds.size.height)
                                                                    radius:ppx(150)
                                                                startAngle:0
                                                                  endAngle:kDEGREES(360)
                                                                 clockwise:NO];
    [leftBottomSEPath fill];
}


#pragma mark ================== Draw Rect ====================
- (void) drawCircle {
    // --------------------------- 上半截的View 包括圆 Start---------------------------
    // 上半截的View 包括圆
    _progressView = UIView.maker
    .com_setup(self);
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [_progressView.superview layoutIfNeeded];
    // 事件控件
    _timeLabel = UILabel.maker
    .com_setup(_progressView)
    .lab_font2(ppx(120), 0, @"ArialHebrew-Bold")
    .lab_text(@"30:00")
    .lab_textColor([MakerUntil mk_colorWithHexString:kMainColor])
    .lab_textAlignment(mk_Center);
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_progressView);
        make.size.mas_equalTo(CGSizeMake(ppx(400), ppx(400)));
    }];
    // 非固定的Layer
    _unFixedLayer = [CAShapeLayer layer];
    _unFixedLayer.frame = _progressView.bounds;
    _unFixedLayer.path = [self getBezierPathWithStartAngle:fixedAngle];
    _unFixedLayer.strokeColor = [MakerUntil mk_colorWithHexString:kMainColor].CGColor;
    _unFixedLayer.fillColor = [UIColor clearColor].CGColor;
    _unFixedLayer.lineWidth = 10.0f;
    [_progressView.layer addSublayer:_unFixedLayer];
    // 非固定Layer指定的动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.5f;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_unFixedLayer addAnimation:animation forKey:@""];
    // --------------------------- 上半截的View 包括圆 End---------------------------
    
    // --------------------------- 下半截的View Start ---------------------------
    // 下半截的View
    UIView *bottomView = UIView.maker
    .com_setup(self);
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.mas_centerY);
    }];
    // 今日专注时间
    UIImageView *todayImageView = UIImageView.maker
    .com_setup(self)
    .img_imageName(@"focus_home_time_today");
    
    [todayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(ppx(-300));
        make.bottom.equalTo(self).offset(ppx(-100));
        make.size.mas_equalTo(CGSizeMake(ppx(30), ppx(30)));
    }];
    [UILabel.maker
     .com_setup(self)
     .lab_font1(ppx(24))
     .lab_textColor(@"#666666")
     .lab_text(@"今日: 30分钟") mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(todayImageView.mas_right).offset(ppx(10));
         make.centerY.equalTo(todayImageView);
         make.right.equalTo(self).offset(ppx(-40));
         make.height.mas_equalTo(ppx(24));
     }];
    // 所有专注时间
    UIImageView *totalImageView = UIImageView.maker
    .com_setup(self)
    .img_imageName(@"focus_home_time_total");
    [totalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(ppx(-300));
        make.bottom.equalTo(self).offset(ppx(-30));
        make.size.mas_equalTo(CGSizeMake(ppx(30), ppx(30)));
    }];
    [UILabel.maker
     .com_setup(self)
     .lab_font1(ppx(24))
     .lab_textColor(@"#666666")
     .lab_text(@"所有: 23小时30分钟") mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(totalImageView.mas_right).offset(ppx(10));
         make.centerY.equalTo(totalImageView);
         make.right.equalTo(self).offset(ppx(-40));
         make.height.mas_equalTo(ppx(24));
     }];
    // --------------------------- 下半截的View End ---------------------------
    
}
- (void)startTheTimer {
    // 定时器
    self.bTimer = [NSTimer scheduledTimerWithTimeInterval:1/10 target:self selector:@selector(_timerLoop:) userInfo:nil repeats:YES];
    [self.bTimer fire];
}


#pragma mark ================== Private Functon ====================
// 定时器循环
- (void) _timerLoop:(NSTimer *)timer {
    static NSInteger fiveBy = 5;
    fixedSecond--;
    fiveBy--;
    if (fixedSecond <= 0 || fixedAngle <= 0) {
        [self.bTimer invalidate];
        self.bTimer = nil;
        self->_timeLabel.lab_text(@"Finished!").lab_font1(ppx(80));
        return ;
    }
    NSInteger minutes = fixedSecond / 60;
    NSInteger seconds = fixedSecond % 60;
    NSString *fixMinutes = [NSString stringWithFormat:@"%@", @(minutes)];
    NSString *fixSeconds = [NSString stringWithFormat:@"%@", @(seconds)];
    if (minutes < 10) {
        fixMinutes = [NSString stringWithFormat:@"0%@", @(minutes)];
    }
    if (seconds < 10) {
        fixSeconds = [NSString stringWithFormat:@"0%@", @(seconds)];
    }
    
    if (fiveBy <= 0) {
        fiveBy = 5;
        fixedAngle--;
        self->_unFixedLayer.path = [self getBezierPathWithStartAngle:fixedAngle];
    }
    self->_timeLabel.lab_text([NSString stringWithFormat:@"%@:%@", fixMinutes, fixSeconds]);
}
// 获取贝塞尔曲线
- (CGPathRef) getBezierPathWithStartAngle:(CGFloat)startAngle {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:
                          CGPointMake(_progressView.bounds.size.width/2, _progressView.bounds.size.height/2)
                                                        radius:ppx(200)
                                                    startAngle:kDEGREES(startAngle)
                                                      endAngle:0
                                                     clockwise:NO];
    return path.CGPath;
}

@end
