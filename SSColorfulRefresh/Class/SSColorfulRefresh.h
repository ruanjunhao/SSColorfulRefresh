//
//  SSColorfulRefresh.h
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SSColorfulRefresh : UIControl

//the array count must be 6.
//clockwise.

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                            colors:(NSArray <UIColor *> *)colors;

- (void)beginRefreshing;

- (void)endRefreshing;

@property (nonatomic,assign,readonly,getter=isRefreshing) BOOL refreshing;

@end
