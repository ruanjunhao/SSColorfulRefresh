//
//  DemoViewController.m
//  Demo
//
//  Created by Mrss on 16/3/5.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "DemoViewController.h"
#import "SSColorfulRefresh.h"

@interface DemoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) SSColorfulRefresh *colorRefresh;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"DEMO";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"End" style:UIBarButtonItemStyleDone target:self action:@selector(endRefreshing)],
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonItemStyleDone target:self action:@selector(beginRefresh)];
    
    self.data = @[[UIImage imageNamed:@"1.jpg"],
                  [UIImage imageNamed:@"2.jpg"],
                  [UIImage imageNamed:@"3.jpg"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.rowHeight = 235.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.colorRefresh = [[SSColorfulRefresh alloc]initWithScrollView:self.tableView colors:nil];
    [self.colorRefresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)beginRefresh {
    [self.colorRefresh beginRefreshing];
}

- (void)endRefreshing {
    [self.colorRefresh endRefreshing];
}

- (void)refreshAction:(SSColorfulRefresh *)refresh {
    NSLog(@"trigger-----------------------");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 235.0)];
        image.clipsToBounds = YES;
        image.tag = 10000;
        [cell.contentView addSubview:image];
    }
    UIImageView *image = [cell.contentView viewWithTag:10000];
    image.image = self.data[indexPath.row];
    return cell;
}

@end
