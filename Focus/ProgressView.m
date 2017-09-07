//
//  ProgressView.m
//  Focus
//
//  Created by 赵恒 on 2017/9/7.
//  Copyright © 2017年 Bartholomew. All rights reserved.
//

#import "ProgressView.h"

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



@implementation BezierView

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
    // 上半截的View 包括圆
    UIView *progressView = UIView.maker
    .com_setup(self);
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [progressView.superview layoutIfNeeded];
    
    UILabel *timeLabel = UILabel.maker
    .com_setup(progressView)
    .lab_font2(ppx(100), 0, nil)
    .lab_text(@"30:00")
    .lab_textColor([MakerUntil mk_colorWithHexString:kMainColor])
    .lab_textAlignment(mk_Center);
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(progressView);
        make.size.mas_equalTo(CGSizeMake(ppx(400), ppx(400)));
    }];
    
    // 贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:
                               CGPointMake(progressView.bounds.size.width/2, progressView.bounds.size.height/2)
                                                             radius:ppx(200)
                                                         startAngle:kDEGREES(300)
                                                           endAngle:0
                                                          clockwise:NO];
    
    // 固定的Layer
    CAShapeLayer *fixedLayer = [CAShapeLayer layer];
    fixedLayer.frame = progressView.bounds;
    fixedLayer.path = path.CGPath;
    fixedLayer.strokeColor = [MakerUntil mk_colorWithHexString:@"#FFFFFF"].CGColor;
    fixedLayer.fillColor = [UIColor clearColor].CGColor;
    fixedLayer.lineWidth = 5.f;
    [progressView.layer addSublayer:fixedLayer];
    
    // 非固定的Layer
    CAShapeLayer *unFixedLayer = [CAShapeLayer layer];
    unFixedLayer.frame = progressView.bounds;
    unFixedLayer.path = path.CGPath;
    unFixedLayer.strokeColor = [MakerUntil mk_colorWithHexString:kMainColor].CGColor;
    unFixedLayer.fillColor = [UIColor clearColor].CGColor;
    unFixedLayer.lineWidth = 5.0f;
    [progressView.layer addSublayer:unFixedLayer];
    
    // 非固定Layer指定的动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.5f;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [unFixedLayer addAnimation:animation forKey:@""];
    
}

@end
