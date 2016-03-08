//
//  AppDelegate.m
//  Demo
//
//  Created by Mrss on 16/3/5.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[DemoViewController alloc]init]];
    self.window.rootViewController = nav;
    NSDictionary *att = @{NSForegroundColorAttributeName:[UIColor darkTextColor],NSFontAttributeName:[UIFont systemFontOfSize:15]};
    [[UIBarButtonItem appearance]setTitleTextAttributes:att forState:UIControlStateNormal];
    return YES;
}


@end
