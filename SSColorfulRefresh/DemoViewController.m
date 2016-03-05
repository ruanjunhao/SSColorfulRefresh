//
//  DemoViewController.m
//  SSColorfulRefresh
//
//  Created by Mrss on 16/3/1.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "DemoViewController.h"
#import "SSColorfulRefresh.h"
@interface DemoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) SSColorfulRefresh *colorRefresh;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"DEMO";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonItemStyleDone target:self action:@selector(beginRefresh)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"End" style:UIBarButtonItemStyleDone target:self action:@selector(endRefreshing)];
    self.data = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<10; i++) {
        [self.data addObject:[NSString stringWithFormat:@"cell:%ld",i]];
    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    NSArray *array = @[[UIColor colorWithRed:90/255.0 green:13/255.0 blue:67/255.0 alpha:1],
                       [UIColor colorWithRed:175/255.0 green:18/255.0 blue:88/255.0 alpha:1],
                       [UIColor colorWithRed:244/255.0 green:13/255.0 blue:100/255.0 alpha:1],
                       [UIColor colorWithRed:244/255.0 green:222/255.0 blue:41/255.0 alpha:1],
                       [UIColor colorWithRed:179/255.0 green:197/255.0 blue:135/255.0 alpha:1],
                       [UIColor colorWithRed:18/255.0 green:53/255.0 blue:85/255.0 alpha:1]
                       ];
    self.colorRefresh = [[SSColorfulRefresh alloc]initWithScrollView:self.tableView colors:array];
    [self.colorRefresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)beginRefresh {
    [self.colorRefresh beginRefreshing];
}

- (void)endRefreshing {
    [self.colorRefresh endRefreshing];
}

- (void)refreshAction:(SSColorfulRefresh *)refresh {
    NSLog(@"trigger");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

@end
