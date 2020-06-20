//
//  ListViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "DynamicListVC.h"

#import "CommunityDynamicCell.h"

#import "CommunityDynamicModel.h"
#import "CommentModel.h"

#import "DynamicDetaiVC.h"

@interface DynamicListVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (strong , nonatomic) NSArray *allCommentsArray;

@end

@implementation DynamicListVC

NSString *MineDynamicCellID = @"MineDynamicCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getComments];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityDynamicCell class]) bundle:nil]forCellReuseIdentifier:MineDynamicCellID];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat tableViewHeight =  SCREEN_HEIGHT - 54;
    //8(SE2)
    if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667)
    {
        tableViewHeight = SCREEN_HEIGHT - 54;
    }
    //11 Pro
    else if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812)
    {
        tableViewHeight = SCREEN_HEIGHT - 74;
    }
    //8 Plus
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736)
    {
        tableViewHeight = SCREEN_HEIGHT - 54;
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
    CommunityDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:MineDynamicCellID];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = self.allCommentsArray.count;
    if(count % 2 != 0)
    {
        count --;
    }
    NSInteger commentsNum1 = indexPath.row % (count / 2) * 2;
    NSInteger commentsNum2 = commentsNum1 + 1;
    NSMutableArray *temp = NSMutableArray.new;
    [temp addObject: self.allCommentsArray[commentsNum1]];
    [temp addObject: self.allCommentsArray[commentsNum2]];
    
    CommunityDynamicModel *dynamicModel = self.dataSource[indexPath.row];
    dynamicModel.commentArray = temp;
    
    DynamicDetaiVC *dynamicDetaiVC = DynamicDetaiVC.new;
    dynamicDetaiVC.dynamicModel = dynamicModel;
    [self.navigationController pushViewController:dynamicDetaiVC animated:YES];
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

#pragma mark - API

- (void)getComments{
    WEAKSELF
    NSDictionary *dic = @{@"userId":@4161};
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getDiscussByUserId" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.allCommentsArray = [MTLJSONAdapter modelsOfClass:[CommentModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求评论失败" afterHideTime:DELAYTiME];
    }];
}

@end
