//
//  HomeFourVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/15.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeFourBtnVC.h"

#import "CZ_NEWMarketVC.h"
#import "HomeCalendarVC.h"
#import "HomeBusinessVC.h"
#import "HomeNewsVC.h"

#import <JXCategoryTitleView.h>

@interface HomeFourBtnVC ()

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;

@end

@implementation HomeFourBtnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
}

- (void)setNavBar
{
    self.titles = @[@"实时行情", @"日历数据", @"行业风暴", @"极速快讯"];
    
    self.myCategoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.cellSpacing = 0;
    self.myCategoryView.cellWidth = 60.5;
    self.myCategoryView.titleFont = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.myCategoryView.titleSelectedFont = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    self.myCategoryView.titleColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.myCategoryView.titleSelectedColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.myCategoryView.listContainer.contentScrollView.scrollEnabled = NO;
    
    [self.myCategoryView removeFromSuperview];
    self.navigationItem.titleView = self.myCategoryView;
    self.navigationItem.hidesBackButton = YES;
    
    self.myCategoryView.defaultSelectedIndex = self.index;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.myCategoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

- (CGFloat)preferredCategoryViewHeight {
    return 0;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView{
    return  4;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0)
    {
        CZ_NEWMarketVC *marketVC = [CZ_NEWMarketVC new];
        return marketVC;
    }
    else if (index == 1)
    {
        HomeCalendarVC *calendarVC = HomeCalendarVC.new;
        return calendarVC;
    }
    else if (index == 2)
    {
        HomeBusinessVC *industryVC = HomeBusinessVC.new;
        return industryVC;
    }
    else
    {
        HomeNewsVC *newsVC = [HomeNewsVC new];
        return newsVC;
    }
}

@end
