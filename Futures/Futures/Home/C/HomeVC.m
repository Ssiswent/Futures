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

#import "HomeFourBtnVC.h"

#import "CustomTBC.h"

#import "LoginVC.h"
#import "CheckInVC.h"

#import "CheckInModel.h"

@interface HomeVC ()<UITableViewDataSource, UITableViewDelegate,YPNavigationBarConfigureStyle, HomeFourBtnCellDelegate, HomeCheckInCellDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong , nonatomic) NSArray *newsArray;

@property (strong , nonatomic) NSArray *checkInList;
@property (strong , nonatomic) NSMutableArray <NSDate *> *datesArray;
@property (nonatomic, assign) BOOL hasCheckedIn;

@property (nonatomic, strong)NSNumber *userId;


@end

@implementation HomeVC

NSString *HomeBannerCellID = @"HomeBannerCell";
NSString *HomeFourBtnCellID = @"HomeFourBtnCell";
NSString *HomeCheckInCellID = @"HomeCheckInCell";
NSString *HomeADCellID = @"HomeADCell";
NSString *HomeGoldCellID = @"HomeGoldCell";
NSString *HomeNewsCellID = @"HomeNewsCell";

- (NSMutableArray<NSDate *> *)datesArray
{
    if(_datesArray == nil)
    {
        _datesArray = NSMutableArray.new;
    }
    return _datesArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
    [self registerTableView];
    [self getTopics];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserDefault];
    [self getSignList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CustomTBC setTabBarHidden:NO TabBarVC:self.tabBarController];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (void)registerTableView
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
    if(SCREEN_HEIGHT >= 812)
    {
        _topViewHeight.constant = 88;
    }
    
    [self setSearchBar];
    
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,0);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 36;
}

- (void)setSearchBar
{
    _searchBar.layer.cornerRadius = 12.5;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.searchTextField.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9" alpha:0.1];
    _searchBar.searchTextField.font = [UIFont systemFontOfSize:14];
    _searchBar.searchTextField.textColor = [UIColor colorWithHexString:@"#2A39FB"];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9" alpha:0.1];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#E9E9E9" alpha:0.1];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"搜索股票/用户/讨论" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    _searchBar.searchTextField.attributedPlaceholder = string;
}

// MARK: HomeCheckInCellDelegate

- (void)homeCheckInCellDidClickCheckInBtn:(HomeCheckInCell *)homeCheckInCell
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    if(userId != nil)
    {
        CheckInVC *checkInVC = CheckInVC.new;
        checkInVC.datesArray = _datesArray;
        checkInVC.checkInList = _checkInList;
        checkInVC.hasCheckedIn = _hasCheckedIn;
        [self.navigationController pushViewController:checkInVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        //        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
}

#pragma mark - yp_navigtionBarConfiguration
- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarHidden;
}

- (UIColor *)yp_navigationBarTintColor{
    return [UIColor whiteColor];
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
    fourBtnCell.delegate = self;
    HomeCheckInCell *checkInCell = [tableView dequeueReusableCellWithIdentifier:HomeCheckInCellID];
    checkInCell.delegate = self;
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
            switch (indexPath.row % 5) {
                case 0:
                    newsCell.newsImgView.image = [UIImage imageNamed:@"news_1"];
                    break;
                case 1:
                    newsCell.newsImgView.image = [UIImage imageNamed:@"news_2"];
                    break;
                case 2:
                    newsCell.newsImgView.image = [UIImage imageNamed:@"news_3"];
                    break;
                case 3:
                    newsCell.newsImgView.image = [UIImage imageNamed:@"news_4"];
                    break;
                default:
                    newsCell.newsImgView.image = [UIImage imageNamed:@"news_5"];
                    break;
            }
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

#pragma mark - HomeFourBtnCellDelegate

- (void)HomeFourBtnCellDidClickBtnView:(HomeFourBtnCell *)homeFourBtnCell Tag:(NSInteger)tag
{
    HomeFourBtnVC *fourBtnVC = HomeFourBtnVC.new;
    fourBtnVC.index = tag;
    [self.navigationController pushViewController:fourBtnVC animated:YES];
}

#pragma mark - API

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

- (void)getSignList
{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager getWithPathUrl:@"/user/sign/getSignList" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        [weakSelf.datesArray removeAllObjects];
        weakSelf.hasCheckedIn = NO;
        weakSelf.checkInList = [MTLJSONAdapter modelsOfClass:[CheckInModel class] fromJSONArray:result[@"data"] error:&error];
        for (CheckInModel *checkInModel in weakSelf.checkInList) {
            NSDate *checkInDate = [NSDate dateWithTimeIntervalSince1970: checkInModel.time / 1000];
            [weakSelf.datesArray addObject:checkInDate];
            if([self isSameDay:checkInDate date2:[NSDate date]])
            {
                weakSelf.hasCheckedIn = YES;
            }
        }
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求签到记录失败" afterHideTime:DELAYTiME];
    }];
}

// 判断是否是同一天
- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

@end
