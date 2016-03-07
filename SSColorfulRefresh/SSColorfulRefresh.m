//
//  SSColorfulRefresh.m
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "SSColorfulRefresh.h"

@interface NSTimer (SafeTimer)

+ (NSTimer *)safe_timerWithTimeInterval:(NSTimeInterval)ti
                                  block:(void(^)())block
                                repeats:(BOOL)bo;

@end


@implementation NSTimer (SafeTimer)

+ (NSTimer *)safe_timerWithTimeInterval:(NSTimeInterval)ti block:(void (^)())block repeats:(BOOL)bo {
    return [self timerWithTimeInterval:ti target:self selector:@selector(safe_timerBlock:) userInfo:[block copy] repeats:bo];
}

+ (void)safe_timerBlock:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end

typedef NS_ENUM(NSInteger,SSColorfulItemPosition) {
    SSColorfulItemPositionRightBottom,
    SSColorfulItemPositionLeftBottom,
    SSColorfulItemPositionRightCenter,
    SSColorfulItemPositionLeftCenter,
    SSColorfulItemPositionRightTop,
    SSColorfulItemPositionLeftTop,
};

@interface SSColorfulItem : UIView

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) NSInteger currentColorIndex;
@property (nonatomic,assign,readonly) SSColorfulItemPosition position;

- (instancetype)initWithCenter:(CGPoint)point originalColor:(UIColor *)color position:(SSColorfulItemPosition)position;

@end


static const CGFloat kColorfulRefreshWidth = 35.0;

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

static const NSInteger kColorfulItemBaseTag = 10000;
static const NSTimeInterval kColorfulRefreshUpdateTimeInterval = 0.2;
static const CGFloat kColorfulRefreshTargetHeight = 70;
static NSString *const  ObservingKeyPath = @"contentOffset";

@interface SSColorfulRefresh ()

@property (nonatomic,strong) NSArray *colors;
@property (nonatomic,strong) NSArray *originalColors;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) NSArray *originalItems;
@property (nonatomic,  weak) UIScrollView *attachScrollView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger flagCount;
@property (nonatomic,assign) BOOL trigger;

@end


@implementation SSColorfulRefresh

- (NSTimer *)timer {
    if (_timer == nil) {
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer safe_timerWithTimeInterval:kColorfulRefreshUpdateTimeInterval block:^{
            [weakSelf updateColor];
        } repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:CGRectMake(0, -400, CGRectGetWidth(scrollView.frame), 400)];
    if (self) {
        self.attachScrollView = scrollView;
        self.backgroundColor = [UIColor whiteColor];
        [self.attachScrollView addSubview:self];
        [self.attachScrollView addObserver:self forKeyPath:ObservingKeyPath options:NSKeyValueObservingOptionNew context:NULL];
        _originalColors = [colors copy];
        
        _items = [[NSMutableArray alloc]initWithCapacity:6];
        _colors = @[colors[2],colors[3],colors[1],colors[4],colors[0],colors[5]];
        [_colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {
            SSColorfulItemPosition position = (SSColorfulItemPosition)idx;
            SSColorfulItem *item = [[SSColorfulItem alloc]initWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2, 365-20*idx) originalColor:[color colorWithAlphaComponent:0] position:position];
            item.tag = idx+10000;
            [self addSubview:item];
            [_items addObject:item];
        }];
        _originalItems = @[_items[4],_items[2],_items[0],_items[1],_items[3],_items[5]];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ObservingKeyPath]) {
        CGFloat offsetY = [change[NSKeyValueChangeNewKey]CGPointValue].y;
        if (offsetY > 0) {
            return;
        }
        NSLog(@"%lf",offsetY);
        CGFloat f = fabs(offsetY)/kColorfulRefreshTargetHeight;
        
        if (fabs(offsetY) < kColorfulRefreshTargetHeight) {
            [_colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {
                SSColorfulItem *item = [self viewWithTag:idx+10000];
                item.color = [color colorWithAlphaComponent:f];
                if (item.center.y < 365) {
                    item.center = CGPointMake(item.center.x, item.center.y+f);
                }
            }];
        }
        
        if (!self.attachScrollView.dragging && self.attachScrollView.decelerating && !self.trigger) {
            [self.attachScrollView setContentOffset:CGPointMake(0, -kColorfulRefreshTargetHeight) animated:YES];
            [self.timer setFireDate:[NSDate distantPast]];
            if (!self.trigger) {
                self.trigger = YES;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
    }
}

- (void)updateColor {
    [self.originalItems enumerateObjectsUsingBlock:^(SSColorfulItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.color = self.originalColors[(self.flagCount+idx)%6];
    }];
    self.flagCount++;
}

- (void)beginRefreshing {
    for (NSInteger i = 0; i<self.colors.count; i++) {
        SSColorfulItem *item = [self viewWithTag:kColorfulItemBaseTag+i];
        item.center = CGPointMake(CGRectGetWidth(self.frame)/2, 365);
    }
    [self.attachScrollView setContentOffset:CGPointMake(0, -kColorfulRefreshTargetHeight) animated:YES];
    [self.timer setFireDate:[NSDate distantPast]];
    
}

- (void)endRefreshing {
    [self.timer setFireDate:[NSDate distantFuture]];
    self.flagCount = 0;
    self.trigger = NO;
    
    for (NSInteger i = self.colors.count-1; i>=0; i--) {
        SSColorfulItem *item = [self viewWithTag:i+10000];
        [UIView animateWithDuration:0.75 delay:0.1*(self.colors.count-i-1) options:UIViewAnimationOptionCurveLinear animations:^{
            item.center = CGPointMake(item.center.x, item.center.y-200);
        } completion:nil];
    }
    [self performSelector:@selector(back) withObject:nil afterDelay:0.75];
}

- (void)back {
    [self.attachScrollView setContentOffset:CGPointZero animated:YES];
}

- (void)dealloc {
    [self.attachScrollView removeObserver:self forKeyPath:ObservingKeyPath context:NULL];
    [_timer invalidate];
    _timer = nil;
    NSLog(@"%s",__func__);
}


@end
