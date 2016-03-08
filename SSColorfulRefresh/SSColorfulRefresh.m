//
//  SSColorfulRefresh.m
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "SSColorfulRefresh.h"


static const CGFloat kColorfulRefreshWidth = 35.0;

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
@property (nonatomic,assign,readonly) CGFloat originalCenterY;
@property (nonatomic,assign) float offYChangeSpeed;
@property (nonatomic,assign) NSInteger currentColorIndex;
@property (nonatomic,assign,readonly) SSColorfulItemPosition position;

- (instancetype)initWithCenter:(CGPoint)point originalColor:(UIColor *)color position:(SSColorfulItemPosition)position;

@end


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
        _originalCenterY = point.y;
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
static const NSTimeInterval kColorfulRefreshUpdateTimeInterval = 0.15;
static const CGFloat kColorfulRefreshTargetHeight = 65.0;
static const CGFloat kColorfulRefreshSpringHeight = 100.0;
static NSString *const  ObservingKeyPath = @"contentOffset";

@interface SSColorfulRefresh () <UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *colors;
@property (nonatomic,strong) NSArray *originalColors;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) NSArray *originalItems;
@property (nonatomic,strong) NSMutableArray *originalPositions;
@property (nonatomic,strong) NSArray *speeds;
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
        _attachScrollView = scrollView;
        self.backgroundColor = [UIColor whiteColor];
        [_attachScrollView addSubview:self];
        [_attachScrollView addObserver:self forKeyPath:ObservingKeyPath options:NSKeyValueObservingOptionNew context:NULL];
        if (colors && colors.count == 6) {
            _originalColors = [colors copy];
        }
        else {
            _originalColors = [[self class]defaultColors];
        }
        _originalPositions = [[NSMutableArray alloc]initWithCapacity:6];
        _items = [[NSMutableArray alloc]initWithCapacity:6];
        _colors = @[colors[2],colors[3],colors[1],colors[4],colors[0],colors[5]];
        [_colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {
            SSColorfulItemPosition position = (SSColorfulItemPosition)idx;
            SSColorfulItem *item = [[SSColorfulItem alloc]initWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2, 400-kColorfulRefreshTargetHeight-kColorfulRefreshWidth/2-30*idx) originalColor:color position:position];
            item.tag = idx+kColorfulItemBaseTag;
            [self addSubview:item];
            [_items addObject:item];
            [_originalPositions addObject:@(400-kColorfulRefreshTargetHeight-kColorfulRefreshWidth/2-30*idx)];
        }];
        _speeds = @[@(55.0/75.0),
                    @(85.0/80.0),
                    @(115.0/85.0),
                    @(145.0/90.0),
                    @(175.0/95.0),
                    @(205.0/100.0)];
        _originalItems = @[_items[4],_items[2],_items[0],_items[1],_items[3],_items[5]];
    }
    return self;
}

+ (NSArray *)defaultColors {
    return @[
             [UIColor colorWithRed:90/255.0 green:13/255.0 blue:67/255.0 alpha:1],
             [UIColor colorWithRed:175/255.0 green:18/255.0 blue:88/255.0 alpha:1],
             [UIColor colorWithRed:244/255.0 green:13/255.0 blue:100/255.0 alpha:1],
             [UIColor colorWithRed:244/255.0 green:222/255.0 blue:41/255.0 alpha:1],
             [UIColor colorWithRed:179/255.0 green:197/255.0 blue:135/255.0 alpha:1],
             [UIColor colorWithRed:18/255.0 green:53/255.0 blue:85/255.0 alpha:1]
             ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:ObservingKeyPath]) {
        return;
    }
    CGFloat offsetY = [change[NSKeyValueChangeNewKey]CGPointValue].y;
    if (!self.trigger) {
        if (offsetY <= 0) {
            for (NSInteger i = 0; i<self.colors.count; i++) {
                SSColorfulItem *item = [self viewWithTag:i+10000];
                CGFloat p = [self.originalPositions[i] doubleValue];
                CGFloat s = [self.speeds[i] doubleValue];
                if (p+s*fabs(offsetY)>=400-20-35.0/2) {
                    item.center = CGPointMake(item.center.x, 400-20-35.0/2);
                }
                else {
                    item.center = CGPointMake(item.center.x, p+s*fabs(offsetY));
                }
            }
        }
    }
    else {
        if (!self.attachScrollView.dragging && self.attachScrollView.decelerating) {
            [self.attachScrollView setContentOffset:CGPointMake(0, -75) animated:YES];
        }
    }
    if (offsetY <= -95) {
        if (!self.attachScrollView.dragging && self.attachScrollView.decelerating) {
            if (!self.trigger) {
                NSLog(@"trigger");
                self.trigger = YES;
                [self.attachScrollView setContentOffset:CGPointMake(0, -75) animated:YES];
                [self.timer setFireDate:[NSDate distantPast]];
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
    
    [_attachScrollView removeObserver:self forKeyPath:ObservingKeyPath context:NULL];
    [_timer invalidate];
    _timer = nil;
    return;
    for (NSInteger i = 0; i<self.colors.count; i++) {
        SSColorfulItem *item = [self viewWithTag:kColorfulItemBaseTag+i];
        item.center = CGPointMake(CGRectGetWidth(self.frame)/2, 365);
    }
    [self.attachScrollView setContentOffset:CGPointMake(0, -kColorfulRefreshTargetHeight) animated:YES];
    [self.timer setFireDate:[NSDate distantPast]];
    
}

- (void)endRefreshing {
    self.flagCount = 0;
    self.trigger = NO;
    [self.timer setFireDate:[NSDate distantFuture]];
    for (NSInteger i = self.colors.count-1; i>=0; i--) {
        SSColorfulItem *item = [self viewWithTag:i+10000];
        [UIView animateWithDuration:0.75 delay:0.1*(self.colors.count-i-1) options:UIViewAnimationOptionCurveLinear animations:^{
            item.center = CGPointMake(item.center.x, item.originalCenterY);
        } completion:nil];
    }
    [UIView animateWithDuration:0.25 delay:0.75 options:UIViewAnimationOptionCurveLinear animations:^{
        self.attachScrollView.contentOffset = CGPointZero;
    } completion:nil];
}


- (void)dealloc {
    [_attachScrollView removeObserver:self forKeyPath:ObservingKeyPath context:NULL];
    [_timer invalidate];
    _timer = nil;
}


@end
