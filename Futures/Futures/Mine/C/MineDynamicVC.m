//
//  OCExampleViewController.m
//  JXPagerView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "MineDynamicVC.h"
#import <JXCategoryView.h>
#import "CustomTBC.h"

#import "MineUserModel.h"
#import "CommunityDynamicModel.h"

@interface MineDynamicVC () <JXCategoryViewDelegate, YPNavigationBarConfigureStyle>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@property (assign, nonatomic) CGFloat alpha;
@property (strong, nonatomic) UIColor *navBgColor;

@property (assign, nonatomic) CGFloat verticalOffset;
@property (assign, nonatomic) CGFloat thresholdDistance;

@property (nonatomic, strong) NSNumber *userId;
@property (strong , nonatomic) NSArray *dynamicsArray;
@property (strong , nonatomic) NSArray *hotDynamicsArray;



@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation MineDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
    [self getUserDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (JXPagerView *)preferredPagingView {
    return [[JXPagerView alloc] initWithDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.pagerView.frame = self.view.bounds;
}

- (void)initialSetup
{
    
    self.title = @"我的动态";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    _titleLabel = titleLabel;
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_return"] style:0 target:self action:@selector(backBtnClicked)];
    
    [self screenAdapter];
    
    _alpha = 0;
    UIColor *color = [UIColor colorWithHexString:@"#293AFF" alpha:_alpha];
    _navBgColor = color;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    _titles = @[@"最热", @"最新"];
    
    _userHeaderView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MineDynamicHeaderView class]) owner:nil options:nil].firstObject;
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection)];
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleFont = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#293AFF"];
    self.categoryView.titleColor = [UIColor colorWithHexString:@"#272727"];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    self.categoryView.cellWidth = 24;
    self.categoryView.contentEdgeInsetLeft = 14.5;
    self.categoryView.contentEdgeInsetRight = kScaleFrom_iPhone8_Width(238);
    self.categoryView.cellSpacing = 74.5;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    lineView.indicatorWidth = 7.5;
    lineView.indicatorHeight = 3;
    lineView.verticalMargin = 5;
    self.categoryView.indicators = @[lineView];
    
    _pagerView = [self preferredPagingView];
    self.pagerView.mainTableView.gestureDelegate = self;
    //隐藏右侧指示器
    self.pagerView.automaticallyDisplayListVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.pagerView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    
    _verticalOffset = JXTableHeaderViewHeight - _thresholdDistance;
    
    //调整pagingView的位置
    self.pagerView.pinSectionHeaderVerticalOffset = _verticalOffset;
}

- (void)screenAdapter
{
    //_thresholdDistance = scrollView.contentOffset.y
    _thresholdDistance = 86;
    
    //8(SE2)
    if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667)
    {
        _thresholdDistance = 86;
    }
    //11 Pro
    else if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812)
    {
        _thresholdDistance = 62;
    }
    //8 Plus
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736)
    {
        _thresholdDistance = 86;
    }
    //11 Pro Max
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 896)
    {
        _thresholdDistance = 64;
    }
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
    [self getDynamics];
    [self getHotDynamics];
    [self getUser];
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return JXTableHeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return JXheightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    DynamicListVC *list = [[DynamicListVC alloc] init];
    list.title = self.titles[index];
    if (index == 0) {
        list.dataSource = self.hotDynamicsArray.mutableCopy;
    }
    else
    {
        list.dataSource = self.dynamicsArray.mutableCopy;
    }
    return list;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.userHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
    CGFloat thresholdDistance = _thresholdDistance;
    CGFloat percent = scrollView.contentOffset.y/thresholdDistance;
    percent = MAX(0, MIN(1, percent));
    _alpha = percent;
    [self yp_refreshNavigationBarStyle];
    UIColor *color = [UIColor colorWithHexString:@"#293AFF" alpha:percent];
    _navBgColor = color;
    
    _titleLabel.textColor = [UIColor colorWithWhite:1 alpha:percent];
}

#pragma mark - yp_navigtionBarConfiguration

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    if(_alpha == 1)
    {
        return YPNavigationBarBackgroundStyleOpaque | YPNavigationBarBackgroundStyleColor ;
    }
    return YPNavigationBarBackgroundStyleColor;
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor colorWithWhite:1 alpha:_alpha];
}

- (UIColor *)yp_navigationBackgroundColor{
    return _navBgColor;
}

#pragma mark - API

- (void)getDynamics{
    WEAKSELF
    NSDictionary *dic = @{@"_orderByDesc":@"publishTime",@"userId":_userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/talk/getTalkList/155" parameters:dic queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.dynamicsArray = [MTLJSONAdapter modelsOfClass:[CommunityDynamicModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [self.pagerView reloadData];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户说说失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getHotDynamics{
    WEAKSELF
    NSDictionary *dic = @{@"_orderBy":@"publishTime",@"userId":_userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/talk/getTalkList/155" parameters:dic queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.hotDynamicsArray = [MTLJSONAdapter modelsOfClass:[CommunityDynamicModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [self.pagerView reloadData];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户说说失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getUser{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/personal/queryUser" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        mineUser = [MTLJSONAdapter modelOfClass:[MineUserModel class] fromJSONDictionary:result[@"data"] error:&error];
        weakSelf.userHeaderView.mineUser = mineUser;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户数据失败" afterHideTime:DELAYTiME];
    }];
}

@end
