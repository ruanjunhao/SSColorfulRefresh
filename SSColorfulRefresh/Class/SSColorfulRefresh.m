//
//  SSColorfulRefresh.m
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "SSColorfulRefresh.h"

static const CGFloat kColorfulRefreshWidth = 50.0;

typedef struct {
    CGFloat minBorderLen;
    CGFloat middleBorderLen;
    CGFloat maxBorderLen;
}TriangleBorder;

@implementation SSColorfulItem {
    TriangleBorder _border;
}

- (instancetype)initWithCenter:(CGPoint)point originalColor:(UIColor *)color position:(SSColorfulItemPosition)position {
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, kColorfulRefreshWidth, kColorfulRefreshWidth);
        self.center = point;
        _color = color;
        _position = position;
        _border.middleBorderLen = kColorfulRefreshWidth/2;
        _border.minBorderLen = _border.middleBorderLen*tan(M_PI/6);
        _border.maxBorderLen = 2*_border.minBorderLen;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(kColorfulRefreshWidth/2, kColorfulRefreshWidth/2);
    CGPoint minPoint,middlePoint,maxPoint;
    switch (self.position) {
        case SSColorfulItemPositionLeftBottom: {
            minPoint = CGPointMake(kColorfulRefreshWidth/2, kColorfulRefreshWidth);
            middlePoint = CGPointMake(center.x-_border.middleBorderLen*cos(M_PI/6), 3/4.0*kColorfulRefreshWidth);
            maxPoint = CGPointMake(center.x-_border.maxBorderLen*sin(M_PI/6), center.y);
        }
            break;
        case SSColorfulItemPositionLeftCenter: {
            minPoint = CGPointMake(center.x-_border.middleBorderLen*cos(M_PI/6), 3/4.0*kColorfulRefreshWidth);
            middlePoint = CGPointMake(center.x-_border.middleBorderLen*cos(M_PI/6), kColorfulRefreshWidth/4);
            maxPoint = CGPointMake(center.x-_border.minBorderLen*sin(M_PI/6), kColorfulRefreshWidth/4);
        }
            break;
        case SSColorfulItemPositionLeftTop: {
            minPoint = CGPointMake(center.x-_border.middleBorderLen*cos(M_PI/6), kColorfulRefreshWidth/4);
            middlePoint = CGPointMake(center.x, 0);
            maxPoint = CGPointMake(center.x+_border.minBorderLen*sin(M_PI/6),kColorfulRefreshWidth/4);
        }
            break;
        case SSColorfulItemPositionRightBottom: {
            minPoint = CGPointMake(center.x+_border.middleBorderLen*cos(M_PI/6),3/4.0*kColorfulRefreshWidth);
            middlePoint = CGPointMake(kColorfulRefreshWidth/2, kColorfulRefreshWidth);
            maxPoint = CGPointMake(center.x-_border.minBorderLen*sin(M_PI/6), 3/4.0*kColorfulRefreshWidth);
        }
            break;
        case SSColorfulItemPositionRightCenter: {
            minPoint = CGPointMake(center.x+_border.middleBorderLen*cos(M_PI/6), kColorfulRefreshWidth/4);
            middlePoint = CGPointMake(center.x+_border.middleBorderLen*cos(M_PI/6),3/4.0*kColorfulRefreshWidth);
            maxPoint = CGPointMake(center.x+_border.minBorderLen*sin(M_PI/6),3/4.0*kColorfulRefreshWidth);
        }
            break;
        case SSColorfulItemPositionRightTop: {
            minPoint = CGPointMake(center.x ,0);
            middlePoint = CGPointMake(center.x+_border.middleBorderLen*cos(M_PI/6), kColorfulRefreshWidth/4);
            maxPoint = CGPointMake(center.x+_border.maxBorderLen*sin(M_PI/6), center.y);
        }
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
