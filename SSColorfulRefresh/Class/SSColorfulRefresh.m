//
//  SSColorfulRefresh.m
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "SSColorfulRefresh.h"
#define kColorfulRefreshBorderLength 50

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
@property (nonatomic,assign,readonly) SSColorfulItemPosition position;

- (instancetype)initWithFrame:(CGRect)frame originalColor:(UIColor *)color position:(SSColorfulItemPosition)position;

@end


@implementation SSColorfulItem

- (instancetype)initWithFrame:(CGRect)frame originalColor:(UIColor *)color position:(SSColorfulItemPosition)position {
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
        _position = position;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    CGPoint minPoint,middlePoint,maxPoint;
    switch (self.position) {
        case SSColorfulItemPositionLeftBottom:
            
            break;
        case SSColorfulItemPositionLeftCenter:
            
            break;
        case SSColorfulItemPositionLeftTop:

            break;
        case SSColorfulItemPositionRightBottom:
            
            break;
        case SSColorfulItemPositionRightCenter:
            break;
        case SSColorfulItemPositionRightTop:
            break;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, minPoint.x, minPoint.y);
    CGContextAddLineToPoint(ctx, middlePoint.x, middlePoint.y);
    CGContextAddLineToPoint(ctx, maxPoint.x, maxPoint.y);
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextFillPath(ctx);
}


@end



@interface SSColorfulRefresh () {
    NSTimer *_timer;
}

@property (nonatomic,  weak) UIScrollView *attachScrollView;

@end

static NSString *const  ObservingKeyPath = @"contentOffset";

@implementation SSColorfulRefresh

- (instancetype)initWithScrollView:(UIScrollView *)scrollView colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectMake(0, -400, CGRectGetWidth(scrollView.frame), 400)];
    if (self) {
        self.attachScrollView = scrollView;
        [self.attachScrollView addSubview:self];
        [self.attachScrollView addObserver:self forKeyPath:ObservingKeyPath options:NSKeyValueObservingOptionNew context:NULL];
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateItemColor) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)updateItemColor {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ObservingKeyPath]) {
        CGFloat offsetY = [change[NSKeyValueChangeNewKey]CGPointValue].y;
    }
}

- (void)beginRefreshing {
    
}

- (void)endRefreshing {
    
}


@end
