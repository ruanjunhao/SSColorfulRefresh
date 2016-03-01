//
//  ViewController.m
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UITextView *tv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _timer  = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(dododo) userInfo:nil repeats:YES];
    
    [_timer setFireDate:[NSDate distantFuture]];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)dododo {
    NSLog(@"dododo");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
