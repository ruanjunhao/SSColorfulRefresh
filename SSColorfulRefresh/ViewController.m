//
//  ViewController.m
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "ViewController.h"
#import "SSColorfulRefresh.h"


@interface ViewController () {
    NSTimer *_timer;
    NSArray *_colors;
    NSArray *_items;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _colors = @[[UIColor colorWithRed:90/255.0 green:13/255.0 blue:67/255.0 alpha:1],
                [UIColor colorWithRed:175/255.0 green:18/255.0 blue:88/255.0 alpha:1],
                [UIColor colorWithRed:244/255.0 green:13/255.0 blue:100/255.0 alpha:1],
                [UIColor colorWithRed:244/255.0 green:222/255.0 blue:41/255.0 alpha:1],
                [UIColor colorWithRed:179/255.0 green:197/255.0 blue:135/255.0 alpha:1],
                [UIColor colorWithRed:18/255.0 green:53/255.0 blue:85/255.0 alpha:1]
                ];
    _timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(updateColor) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)updateColor {
    static NSInteger index = 0;
    for (NSInteger i = 0; i<_items.count; i++) {
        SSColorfulItem *item = _items[i];
        item.color = _colors[(index+i)%6];
    }
    index++;
}

- (void)viewWillAppear:(BOOL)animated {
    SSColorfulItem *item1 = [[SSColorfulItem alloc]initWithCenter:self.view.center originalColor:_colors[0] position:SSColorfulItemPositionLeftTop];
    SSColorfulItem *item2 = [[SSColorfulItem alloc]initWithCenter:self.view.center originalColor:_colors[1] position:SSColorfulItemPositionLeftCenter];
    SSColorfulItem *item3 = [[SSColorfulItem alloc]initWithCenter:self.view.center originalColor:_colors[2] position:SSColorfulItemPositionLeftBottom];
    SSColorfulItem *item4 = [[SSColorfulItem alloc]initWithCenter:self.view.center originalColor:_colors[3] position:SSColorfulItemPositionRightBottom];
    SSColorfulItem *item5 = [[SSColorfulItem alloc]initWithCenter:self.view.center originalColor:_colors[4] position:SSColorfulItemPositionRightCenter];
    SSColorfulItem *item6 = [[SSColorfulItem alloc]initWithCenter:self.view.center originalColor:_colors[5] position:SSColorfulItemPositionRightTop];
    [self.view addSubview:item1];
    [self.view addSubview:item2];
    [self.view addSubview:item3];
    [self.view addSubview:item4];
    [self.view addSubview:item5];
    [self.view addSubview:item6];
    _items = @[item1,item2,item3,item4,item5,item6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
