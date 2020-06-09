//
//  CommunityFocusVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityFocusVC.h"

#import "CommunityDynamicCell.h"

#import "CommunityDynamicModel.h"

@interface CommunityFocusVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *focusTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong , nonatomic) NSArray *dynamicsArray;


@end

@implementation CommunityFocusVC

NSString *CommunityDynamicCellID1 = @"CommunityDynamicCell1";

- (void)viewDidLoad {
    [self.focusTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityDynamicCell class]) bundle:nil] forCellReuseIdentifier:CommunityDynamicCellID1];
    [self getDynamics];
    [self initialSetup];
}

-(UIView *)listView{
    return self.view;
}

- (void)initialSetup
{
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,0);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 36;
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dynamicsArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommunityDynamicCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:CommunityDynamicCellID1];
    dynamicCell.dynamicModel = self.dynamicsArray[indexPath.row];
    return dynamicCell;
    
}

#pragma mark - API

- (void)getDynamics{
    WEAKSELF
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getRecommandTalk" parameters:nil queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.dynamicsArray = [MTLJSONAdapter modelsOfClass:[CommunityDynamicModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.focusTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求热门动态失败" afterHideTime:DELAYTiME];
    }];
}


@end
