//
//  HomeCalendarVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/15.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeCalendarVC.h"

#import "HomeCalendarColletionCell.h"

#import "CustomTBC.h"

#import <FSCalendar.h>

#import "UIView+CornerAndBorder.h"

@interface HomeCalendarVC ()<UICollectionViewDataSource, UICollectionViewDelegate, FSCalendarDataSource, FSCalendarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIView *calendarBgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarWidth;

@end

@implementation HomeCalendarVC

NSString *HomeCalendarColletionCellID = @"HomeCalendarColletionCell";

- (void)viewDidLoad {
    [self setCollectonView];
    
    _calendarBgView.layer.cornerRadius = 10;
    _calendarBgView.layer.masksToBounds = YES;
    
//    UIRectCorner corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
//    [_calendarBgView setBorderWithCornerRadius:10 borderWidth:0 borderColor:UIColor.redColor type:corners];
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: _calendarBgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
//    //创建 layer
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _calendarBgView.bounds;
//    //赋值
//    maskLayer.path = maskPath.CGPath;
//    _calendarBgView.layer.mask = maskLayer;
    
    //隐藏header两侧
//    self.calendar.appearance.headerMinimumDissolvedAlpha = 0;
    self.calendar.backgroundColor = [UIColor clearColor];
    self.calendar.scope = FSCalendarScopeWeek;
    [self.calendar selectDate:[NSDate date]];
    self.calendar.appearance.weekdayFont = [UIFont systemFontOfSize:11 weight:UIFontWeightBold];
    self.calendar.appearance.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    
    _calendarWidth.constant = SCREEN_WIDTH;
    _dateLabel.text = [self getTimeToTimeStr:[NSDate date]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

-(UIView *)listView{
    return self.view;
}

- (void)setCollectonView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    CGFloat itemW = (SCREEN_WIDTH - 20) / 2;
//    CGFloat itemH = itemW * 256 / 180;
    layout.itemSize = CGSizeMake(180, 180);
    layout.sectionInset = UIEdgeInsetsMake(0, 7.5, 0, 7.5);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _calendarCollectionView.collectionViewLayout = layout;
    _calendarCollectionView.backgroundColor = [UIColor whiteColor];
    _calendarCollectionView.delegate = self;
    _calendarCollectionView.dataSource = self;
    [_calendarCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCalendarColletionCell class]) bundle:nil] forCellWithReuseIdentifier:HomeCalendarColletionCellID];
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCalendarColletionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCalendarColletionCellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - FSCalendarDelegate

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    return 1;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    _dateLabel.text = [self getTimeToTimeStr:date];
}

- (NSString *)getTimeToTimeStr:(NSDate *)date{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY年M月d日"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    return timeStr;
}

@end
