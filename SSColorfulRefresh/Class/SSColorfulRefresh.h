//
//  SSColorfulRefresh.h
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,SSColorfulItemPosition) {
    SSColorfulItemPositionLeftTop,
    SSColorfulItemPositionLeftCenter,
    SSColorfulItemPositionLeftBottom,
    SSColorfulItemPositionRightTop,
    SSColorfulItemPositionRightCenter,
    SSColorfulItemPositionRightBottom,
};

@interface SSColorfulItem : UIView

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) NSInteger currentColorIndex;
@property (nonatomic,assign,readonly) SSColorfulItemPosition position;

- (instancetype)initWithCenter:(CGPoint)point originalColor:(UIColor *)color position:(SSColorfulItemPosition)position;

@end


@interface SSColorfulRefresh : UIControl

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                            colors:(NSArray <UIColor *> *)colors; //the array count must be 6.

- (void)beginRefreshing;

- (void)endRefreshing;

@property (nonatomic,assign,readonly) BOOL refreshing;

@end
