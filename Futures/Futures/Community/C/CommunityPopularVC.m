//
//  CommunityPopularVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityPopularVC.h"

#import "CommunityHeaderCell.h"
#import "CommunityTopicCell.h"
#import "CommunityFocusCell.h"
#import "CommunityDynamicCell.h"

#import "CommunityDynamicHeaderView.h"

#import "CommunityDynamicModel.h"

@interface CommunityPopularVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *popularTableView;

@property (strong , nonatomic) NSArray *dynamicsArray;

@end

@implementation CommunityPopularVC

NSString *CommunityHeaderCellID = @"CommunityHeaderCell";
NSString *CommunityTopicCellID = @"CommunityTopicCell";
NSString *CommunityFocusCellID = @"CommunityFocusCell";
NSString *CommunityDynamicCellID = @"CommunityDynamicCell";

- (void)viewDidLoad {
    [self registTableView];
    [self getDynamics];
}

-(UIView *)listView{
    return self.view;
}

- (void)registTableView
{
    [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityHeaderCell class]) bundle:nil] forCellReuseIdentifier:CommunityHeaderCellID];
    [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityTopicCell class]) bundle:nil] forCellReuseIdentifier:CommunityTopicCellID];
     [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityFocusCell class]) bundle:nil] forCellReuseIdentifier:CommunityFocusCellID];
    [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityDynamicCell class]) bundle:nil] forCellReuseIdentifier:CommunityDynamicCellID];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return self.dynamicsArray.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:CommunityHeaderCellID];
    CommunityTopicCell *topicCell = [tableView dequeueReusableCellWithIdentifier:CommunityTopicCellID];
    CommunityFocusCell *focusCell = [tableView dequeueReusableCellWithIdentifier:CommunityFocusCellID];
    CommunityDynamicCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:CommunityDynamicCellID];
    
    switch (indexPath.section) {
        case 0:
            return headerCell;
            break;
        case 1:
            return topicCell;
            break;
        case 2:
            return focusCell;
            break;
        default:
            dynamicCell.dynamicModel = self.dynamicsArray[indexPath.row];
            return dynamicCell;
            break;
    }
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 3)
    {
        CommunityDynamicHeaderView *dynamicHeaderView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CommunityDynamicHeaderView class]) owner:nil options:nil].firstObject;
        return dynamicHeaderView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 3)
    {
        return 36;
    }
    else
    {
        return 0.001;
    }
}

#pragma mark - API

- (void)getDynamics{
    WEAKSELF
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getRecommandTalk" parameters:nil queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.dynamicsArray = [MTLJSONAdapter modelsOfClass:[CommunityDynamicModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.popularTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求热门动态失败" afterHideTime:DELAYTiME];
    }];
}

@end
