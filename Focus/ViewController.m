//
//  ViewController.m
//  Focus
//
//  Created by 赵恒 on 2017/9/6.
//  Copyright © 2017年 Bartholomew. All rights reserved.
//

#import "ViewController.h"
#import "ProgressView.h"

@interface ViewController ()
@property (nonatomic, strong) ProgressView *progressView;

@end

@implementation ViewController

#pragma mark ================== Life Cycle ====================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupProgressView];
}


#pragma mark ================== Load ProgressView ====================
- (void) _setupProgressView {
    self.progressView = (ProgressView *)[ProgressView maker]
    .com_setup(self.view)
    .com_backgroundColor(kMainColor);
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.progressView setupProgressView];
}

@end
