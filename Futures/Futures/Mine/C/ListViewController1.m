//
//  ListViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "ListViewController1.h"
#import "DetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "UIWindow+JXSafeArea.h"

#import "CommunityDynamicCell.h"

@interface ListViewController1 () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation ListViewController1

NSString *MineDynamicCellID1 = @"MineDynamicCell1";

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityDynamicCell class]) bundle:nil]forCellReuseIdentifier:MineDynamicCellID1];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat tableViewHeight = tableViewHeight = SCREEN_HEIGHT - 54;;
    if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667)
    {
        tableViewHeight = SCREEN_HEIGHT - 54;
    }
    //11 Pro
    else if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812)
    {
        
    }
    //8 Plus
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736)
    {
        
    }
    //11 Pro Max
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 896)
    {
        tableViewHeight = SCREEN_HEIGHT - 74;
    }
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, tableViewHeight);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:MineDynamicCellID1];
    cell.dynamicModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listWillDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

@end
