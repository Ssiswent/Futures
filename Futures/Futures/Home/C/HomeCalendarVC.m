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
//    self.calendar.appearance
    self.calendar.backgroundColor = [UIColor clearColor];
    self.calendar.scope = FSCalendarScopeWeek;
    [self.calendar selectDate:[NSDate date]];
    self.calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    self.calendar.appearance.weekdayFont = [UIFont systemFontOfSize:11 weight:UIFontWeightBold];
    self.calendar.appearance.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
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

@end
