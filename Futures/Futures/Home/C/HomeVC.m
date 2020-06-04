//
//  HomeVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/3.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeVC.h"

#import "HomeBannerCell.h"
#import "HomeFourBtnCell.h"
#import "HomeCheckInCell.h"
#import "HomeADCell.h"
#import "HomeGoldCell.h"
#import "HomeNewsCell.h"

#import "HomeNewsHeaderView.h"

#import "HomeNewsModel.h"

@interface HomeVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;

@property (strong , nonatomic) NSArray *newsArray;

@end

@implementation HomeVC

NSString *HomeBannerCellID = @"HomeBannerCell";
NSString *HomeFourBtnCellID = @"HomeFourBtnCell";
NSString *HomeCheckInCellID = @"HomeCheckInCell";
NSString *HomeADCellID = @"HomeADCell";
NSString *HomeGoldCellID = @"HomeGoldCell";
NSString *HomeNewsCellID = @"HomeNewsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
    [self registTableView];
    [self getTopics];
}

- (void)registTableView
{
    [self.homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeBannerCell class]) bundle:nil] forCellReuseIdentifier:HomeBannerCellID];
    [self.homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeFourBtnCell class]) bundle:nil] forCellReuseIdentifier:HomeFourBtnCellID];
    [self.homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCheckInCell class]) bundle:nil] forCellReuseIdentifier:HomeCheckInCellID];
    [self.homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeADCell class]) bundle:nil] forCellReuseIdentifier:HomeADCellID];
    [self.homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeGoldCell class]) bundle:nil] forCellReuseIdentifier:HomeGoldCellID];
    [self.homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeNewsCell class]) bundle:nil] forCellReuseIdentifier:HomeNewsCellID];
}

- (void)initialSetup
{
    [self.navigationController setNavigationBarHidden:YES];
    
    if(SCREEN_HEIGHT >= 812)
    {
        _topViewHeight.constant = 88;
    }
    
    [self setSearchBar];
}

- (void)setSearchBar
{
    _searchBar.layer.cornerRadius = 12.5;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.searchTextField.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#E9E9E9"];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"搜索股票/用户/讨论" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    _searchBar.searchTextField.attributedPlaceholder = string;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
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
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        default:
            return self.newsArray.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:HomeBannerCellID];
    HomeFourBtnCell *fourBtnCell = [tableView dequeueReusableCellWithIdentifier:HomeFourBtnCellID];
    HomeCheckInCell *checkInCell = [tableView dequeueReusableCellWithIdentifier:HomeCheckInCellID];
    HomeADCell *adCell = [tableView dequeueReusableCellWithIdentifier:HomeADCellID];
    HomeGoldCell *goldCell = [tableView dequeueReusableCellWithIdentifier:HomeGoldCellID];
    HomeNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:HomeNewsCellID];
    
    switch (indexPath.section) {
        case 0:
            return bannerCell;
            break;
        case 1:
            return fourBtnCell;
            break;
        case 2:
            return checkInCell;
            break;
        case 3:
            return adCell;
            break;
        case 4:
            return goldCell;
            break;
        default:
            newsCell.newsModel = self.newsArray[indexPath.row];
            return newsCell;
            break;
    }
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 5)
    {
        HomeNewsHeaderView *newsHeaderView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomeNewsHeaderView class]) owner:nil options:nil].firstObject;
        return newsHeaderView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 5)
    {
        return 36;
    }
    else
    {
        return 0.001;
    }
}

- (void)getTopics{
    WEAKSELF
    NSDate *todayDate = [NSDate date];
    NSDictionary *dic = @{@"date":todayDate};
    [ENDNetWorkManager getWithPathUrl:@"/admin/getFinanceAffairs" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.newsArray = [MTLJSONAdapter modelsOfClass:[HomeNewsModel class] fromJSONArray:result[@"data"] error:&error];
        [weakSelf.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求新闻失败" afterHideTime:DELAYTiME];
    }];
}

@end