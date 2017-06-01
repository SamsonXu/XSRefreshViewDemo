//
//  MyRefreshView.m
//  TestProject
//
//  Created by iOS－Dev on 2017/5/22.
//  Copyright © 2017年 iOS－Dev. All rights reserved.
//

#import "MyRefreshView.h"
#import "Define.h"
@interface MyRefreshView ()
/**
 刷新状态
 */
@property (nonatomic, assign) NSInteger refreshFlag;

/**
 刷新菊花圈
 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

/**
 偏移动画
 */
@property (nonatomic, strong) CAShapeLayer *scheduleLayer;

/**
 监听视图
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 刷新文字
 */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MyRefreshView

+ (MyRefreshView *)refreshViewWithScrollView:(UIScrollView *)scrollView{
    MyRefreshView *refreshView = [[MyRefreshView alloc]init];
    refreshView.frame = CGRectMake(20, 20, KScreenWidth-20, 18);
    refreshView.scrollView = scrollView;
    [refreshView setupView];
    return refreshView;
}

- (void)setupView{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, KScreenWidth-20-25, 18)];
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:self.titleLabel];
    
    self.scheduleLayer = [[CAShapeLayer alloc]init];
    self.scheduleLayer.frame = CGRectMake(0, 0, 18, 18);
    self.scheduleLayer.strokeStart = 0;
    self.scheduleLayer.fillColor = [UIColor clearColor].CGColor;
    self.scheduleLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.scheduleLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.scheduleLayer.lineWidth = 2.0;
    self.scheduleLayer.strokeEnd = 0.0;
    [self.scheduleLayer setTransform:CATransform3DMakeRotation(-M_PI_2, 0, 0, 1)];
    self.scheduleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, 18, 18), 2, 2)].CGPath;
    [self.layer addSublayer:self.scheduleLayer];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    [self addSubview:self.activityIndicatorView];
    
//    [self.scrollView addSubview:self];
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (self.refreshing) {
        return;
    }
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat height = [change[@"new"] CGPointValue].y;
        if (height >= 0) {
            height = 0;
            self.title = nil;
        }else if (height > -80){
            height = height/-80.0;
        }else{
            height = 1.0;
        }
        
        
            if (self.scrollView.isDragging) {
                self.hidden = NO;
                
                if (height == 1.0) {
                    self.title = @"释放刷新";
                }else if(height > 0){
                    self.title = @"下拉刷新";
                }
                
                [self.activityIndicatorView stopAnimating];
                self.scheduleLayer.strokeEnd = height;
                self.scheduleLayer.hidden = NO;
                self.refreshFlag = height;
            }else{
                
                if (self.refreshFlag == 1.0){
                    self.refreshing = YES;
                    [self.scrollView setContentOffset:CGPointMake(0, -80) animated:YES];
                    [self.activityIndicatorView startAnimating];
                    self.title = @"正在刷新";
                    self.scheduleLayer.hidden = YES;
                    self.scheduleLayer.strokeEnd = 0;
                    
                    
                }else{
                    [self.activityIndicatorView stopAnimating];
                    self.scheduleLayer.hidden = NO;
                    self.scheduleLayer.strokeEnd = height;
                }

            }
        
        
    }
}

- (void)endRefresh{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.refreshing = NO;
        self.refreshFlag = 0;
        self.scheduleLayer.strokeEnd = 0;
        [self.activityIndicatorView stopAnimating];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.hidden = YES;
    });
    
   
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
