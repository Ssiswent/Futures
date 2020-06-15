//
//  CommunityVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/3.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityVC.h"
#import "CommunityPopularVC.h"
#import "CommunityFocusVC.h"

#import <JXCategoryTitleView.h>

@interface CommunityVC ()

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;

@end

@implementation CommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
}

- (void)setNavBar
{
    self.titles = @[@"热门", @"关注"];
    
    self.myCategoryView.frame = CGRectMake(0, 0, 120, 30);
    self.myCategoryView.layer.cornerRadius = 7;
    self.myCategoryView.layer.masksToBounds = YES;
    self.myCategoryView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.myCategoryView.layer.borderWidth = 2/[UIScreen mainScreen].scale;
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.cellSpacing = 0;
    self.myCategoryView.cellWidth = 120/2;
    self.myCategoryView.titleFont = [UIFont boldSystemFontOfSize:15];
    self.myCategoryView.titleColor = [UIColor whiteColor];
    self.myCategoryView.titleSelectedColor = [UIColor colorWithHexString:@"#2C3446"];
    self.myCategoryView.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 30;
    backgroundView.indicatorWidthIncrement = 0;
    backgroundView.indicatorColor = [UIColor whiteColor];
    backgroundView.indicatorCornerRadius = 7;
    self.myCategoryView.indicators = @[backgroundView];
    
    [self.myCategoryView removeFromSuperview];
    self.navigationItem.titleView = self.myCategoryView;
    
    UILabel *leftBarItemLabel = UILabel.new;
    leftBarItemLabel.text = @"社区";
    leftBarItemLabel.textColor = [UIColor whiteColor];
    leftBarItemLabel.font = [UIFont boldSystemFontOfSize:18];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItemLabel];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.myCategoryView.frame = CGRectMake(0, 0, 120, 30);
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
    return  2;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0)
    {
        CommunityPopularVC *popularVC = [CommunityPopularVC new];
        return popularVC;
    }
    else
    {
        CommunityFocusVC *focusVC = [CommunityFocusVC new];
        return focusVC;
    }
}

@end
