//
//  MyRefreshView.h
//  TestProject
//
//  Created by iOS－Dev on 2017/5/22.
//  Copyright © 2017年 iOS－Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRefreshView : UIView

/**
 刷新状态
 */
@property (nonatomic, assign) BOOL refreshing;

/**
 刷新文字
 */
@property (nonatomic, copy) NSString *title;


+ (MyRefreshView *)refreshViewWithScrollView:(UIScrollView *)scrollView;

- (void)endRefresh;

@end
