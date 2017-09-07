//
//  ProgressView.h
//  Focus
//
//  Created by 赵恒 on 2017/9/7.
//  Copyright © 2017年 Bartholomew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

#pragma mark ================== ProgressView ====================
/**
 加载ProgressView
 */
- (void) setupProgressView;

/**
 跟新ProgressView的当前任务

 @param task 当前任务名称
 */
- (void) updateCurrentTask:(NSString *)task;

@end



@interface BezierView: UIView
@property (nonatomic, strong) NSTimer *bTimer;

/**
 绘制圆圈
 */
- (void) drawCircle;

/**
 启动定时器
 */
- (void) startTheTimer;

@end
