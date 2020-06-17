//
//  MineLikeVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineLikeVC.h"
#import "MineLikeChildAVC.h"
#import "MineLikeChildBVC.h"

#import <JXCategoryTitleView.h>

@interface MineLikeVC ()

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;

@end

@implementation MineLikeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
}

- (void)setNavBar
{
    
    self.title = @"点赞";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.titles = @[@"谁赞了我", @"我赞了谁"];
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.cellSpacing = 0;
    self.myCategoryView.contentEdgeInsetLeft = 0;
    self.myCategoryView.contentEdgeInsetRight = 0;
    self.myCategoryView.averageCellSpacingEnabled = NO;
    self.myCategoryView.cellWidth = SCREEN_WIDTH/2;
    
    self.myCategoryView.titleFont = [UIFont systemFontOfSize:14];
    self.myCategoryView.titleColor = [UIColor colorWithHexString:@"#272727"];
    self.myCategoryView.titleSelectedColor = [UIColor colorWithHexString:@"#293AFF"];
    self.myCategoryView.titleColorGradientEnabled = YES;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorWidth = 20;
    lineView.indicatorHeight = 3;
    lineView.indicatorColor = [UIColor colorWithHexString:@"#293AFF"];
    lineView.verticalMargin = 10;
    
    self.myCategoryView.indicators = @[lineView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.myCategoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 58);
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
        MineLikeChildAVC *mineLikeChildAVC = [MineLikeChildAVC new];
        return mineLikeChildAVC;
    }
    else
    {
        MineLikeChildBVC *mineLikeChildBVC = [MineLikeChildBVC new];
        return mineLikeChildBVC;
    }
}

@end
