//
//  HomeIndustryVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/15.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeBusinessVC.h"

#import "HomeBusinessCell.h"
#import "HomeBusinessHeaderCell.h"

#import "CustomTBC.h"

#import "HomeNewsModel.h"

@interface HomeBusinessVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *businessTableView;

@property (strong , nonatomic) NSArray *businessArray;

@end

@implementation HomeBusinessVC

NSString *HomeBusinessCellID = @"HomeBusinessCell";
NSString *HomeBusinessHeaderCellID = @"HomeBusinessHeaderCell";

- (void)viewDidLoad {
    [self.businessTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeBusinessCell class]) bundle:nil] forCellReuseIdentifier:HomeBusinessCellID];
    [self.businessTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeBusinessHeaderCell class]) bundle:nil] forCellReuseIdentifier:HomeBusinessHeaderCellID];
    [self getTopics];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

-(UIView *)listView{
    return self.view;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return self.businessArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        HomeBusinessHeaderCell *businessHeaderCell = [tableView dequeueReusableCellWithIdentifier:HomeBusinessHeaderCellID];
        return businessHeaderCell;
    }
    else
    {
        HomeBusinessCell *businessCell = [tableView dequeueReusableCellWithIdentifier:HomeBusinessCellID];
        businessCell.businessModel = self.businessArray[indexPath.row];
        switch (indexPath.row % 5) {
            case 0:
                businessCell.businessImgView.image = [UIImage imageNamed:@"news_1"];
                break;
            case 1:
                businessCell.businessImgView.image = [UIImage imageNamed:@"news_2"];
                break;
            case 2:
                businessCell.businessImgView.image = [UIImage imageNamed:@"news_3"];
                break;
            case 3:
                businessCell.businessImgView.image = [UIImage imageNamed:@"news_4"];
                break;
            default:
                businessCell.businessImgView.image = [UIImage imageNamed:@"news_5"];
                break;
        }
        return businessCell;
    }
}

#pragma mark - API

- (void)getTopics{
    WEAKSELF
    NSDate *todayDate = [NSDate date];
    NSDictionary *dic = @{@"date":todayDate};
    [ENDNetWorkManager getWithPathUrl:@"/admin/getFinanceAffairs" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.businessArray = [MTLJSONAdapter modelsOfClass:[HomeNewsModel class] fromJSONArray:result[@"data"] error:&error];
        [weakSelf.businessTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求新闻失败" afterHideTime:DELAYTiME];
    }];
}

@end
