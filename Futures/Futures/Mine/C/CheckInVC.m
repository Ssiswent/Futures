//
//  CheckInVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/19.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CheckInVC.h"

#import "CustomTBC.h"

#import "UIImage+Image.h"

#import "DIYCalendarCell.h"

#import "CheckInSuccessView.h"

#import "CheckInModel.h"

#import <FSCalendar.h>

@interface CheckInVC ()<UIGestureRecognizerDelegate, FSCalendarDataSource, FSCalendarDelegate>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *checkInBtn;

@property (nonatomic, strong)NSNumber *userId;

@property (weak, nonatomic)UIView *coverView;
@property (weak, nonatomic)CheckInSuccessView *checkInSuccessView;

@end

@implementation CheckInVC

NSString *DIYCalendarCellID = @"DIYCalendarCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    [self getUserDefault];
    
    for (NSDate *checkInDate in _datesArray) {
        [self.calendar selectDate:checkInDate];
    }
//    _checkInBtn.enabled = !_hasCheckedIn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)initialSetup
{
    self.title = @"签到";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    self.calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.calendar.appearance.weekdayFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.calendar.appearance.titleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    
    UIView *headerLineView = [[UIView alloc]initWithFrame:CGRectMake(18, 44, SCREEN_WIDTH - 36, 0.5)];
    headerLineView.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    [self.calendar.calendarHeaderView addSubview:headerLineView];
    
    [self.calendar registerClass:[DIYCalendarCell class] forCellReuseIdentifier:DIYCalendarCellID];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkInBtnClicked:(id)sender {
    CheckInSuccessView *checkInSuccessView =  [CheckInSuccessView checkInSuccessView];
    NSString *dateStr;
    
    CheckInModel *lastModel = _checkInList.lastObject;
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970: lastModel.time / 1000];
    if([self isSameDay:lastDate date2:[NSDate date]])
    {
        dateStr = [NSString stringWithFormat:@"已签到%@天，积分+10!",lastModel.continueTimes];
    }
    else
    {
        dateStr = @"已签到1天，积分+10!";
    }
    checkInSuccessView.dateLabel.text = dateStr;
    _checkInSuccessView = checkInSuccessView;
    [self signNow];
//    [self addCoverView];
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

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (void)removeCoverView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.checkInSuccessView.alpha = 0;
        CGRect frame = self.checkInSuccessView.frame;
        frame.size = CGSizeMake(0, 0);
        self.checkInSuccessView.frame = frame;
    }completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}

- (void)addCoverView
{
    UIView *coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    _checkInSuccessView.alpha = 0;
    [coverView addSubview:_checkInSuccessView];
    [_checkInSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(coverView);
    }];
    _coverView = coverView;
    
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *keyWindow = [array objectAtIndex:0];
    [keyWindow addSubview:_coverView];
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.checkInSuccessView.alpha = 1;
        CGRect frame = self.checkInSuccessView.frame;
        frame.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * (253.5 / 309.5));
        self.checkInSuccessView.frame = frame;
    }completion:^(BOOL finished) {
        WEAKSELF
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverViewClicked)];
        [weakSelf.coverView addGestureRecognizer:tap];
    }];
}

- (void)coverViewClicked
{
    [self removeCoverView];
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    DIYCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:DIYCalendarCellID forDate:date atMonthPosition:monthPosition];
    
    for (NSDate *checkedInDate in self.datesArray) {
        if([date isEqualToDate:checkedInDate])
        {
            cell.hasChecked = YES;
        }
    }
    return cell;
}

// MARK: API

- (void)signNow
{
    WEAKSELF
    NSDictionary *dic = @{@"userId":@4181};
    [ENDNetWorkManager postWithPathUrl:@"/user/sign/signNow" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        weakSelf.checkInBtn.enabled = NO;
        [weakSelf addCoverView];
        [self.calendar selectDate:[NSDate date]];
//        [self.calendar reloadData];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"签到失败" afterHideTime:DELAYTiME];
    }];
}


@end
