//
//  SSColorfulRefresh.h
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSColorfulRefresh : UIControl

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                            colors:(NSArray <UIColor *> *)colors; //the array count must be 6.

- (void)beginRefreshing;

- (void)endRefreshing;

@property (nonatomic,assign,readonly) BOOL refreshing;

@end
