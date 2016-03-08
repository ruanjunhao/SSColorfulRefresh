//
//  ViewController.m
//  Demo
//
//  Created by Mrss on 16/3/5.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewController.h"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[DemoViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
