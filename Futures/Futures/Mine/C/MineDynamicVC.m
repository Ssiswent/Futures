//
//  MineDynamicVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/10.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineDynamicVC.h"

#import "CommunityDynamicCell.h"
#import "CommunityDynamicModel.h"

#import "MineUserModel.h"

#import "CustomTBC.h"


#define oriOffsetY -150
#define oriH 150

@interface MineDynamicVC ()<UITableViewDataSource, UITableViewDelegate, YPNavigationBarConfigureStyle, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *dynamicTableView;
@property (weak, nonatomic) IBOutlet UILabel *followsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@property (nonatomic, strong)NSNumber *userId;

@property (strong , nonatomic) NSArray *dynamicsArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;

@property (strong, nonatomic) UIColor *navBgColor;

@property (assign, nonatomic) CGFloat alpha;

@end

@implementation MineDynamicVC

NSString *MineDynamicCellID = @"MineDynamicCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    [self.dynamicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityDynamicCell class]) bundle:nil]forCellReuseIdentifier:MineDynamicCellID];
    
    [self setContentInset];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self getUserDefault];
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
    [self getDynamics];
    [self getUser];
}

- (void)initialSetup
{
    _avatarView.layer.cornerRadius = 37.5;
    _avatarView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 32.5;
    _avatarImgView.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_return"] style:0 target:self action:@selector(backBtnClicked)];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //不设置为YES的话，导航栏设置为Opaque则控制器的View会下移
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setNavFade

- (void)setContentInset
{
    if (@available(iOS 11.0, *)) {
        self.dynamicTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.dynamicTableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y - oriOffsetY;
    CGFloat h = oriH - offset;
    if (h <= 64) {
        h = 64;
    }
    self.headerViewHeight.constant = h;
    
    CGFloat alpha = offset * 1 / 86.0;
    if (alpha >= 1) {
        alpha = 1;
    }
    _alpha = alpha;
    if (alpha <= 1) {
        [self yp_refreshNavigationBarStyle];
    }
    
    UIColor *color = [UIColor colorWithHexString:@"#293AFF" alpha:alpha];
    _navBgColor = color;
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

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dynamicsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:MineDynamicCellID];
    cell.dynamicModel = self.dynamicsArray[indexPath.row];
    return cell;
}


#pragma mark - API

- (void)getDynamics{
    WEAKSELF
    NSDictionary *dic = @{@"_orderByDesc":@"publishTime",@"userId":@155};
    [ENDNetWorkManager postWithPathUrl:@"/user/talk/getTalkList/155" parameters:dic queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.dynamicsArray = [MTLJSONAdapter modelsOfClass:[CommunityDynamicModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.dynamicTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        weakSelf.followsCountLabel.text = [NSString stringWithFormat:@"%d",mineUser.followCount.intValue];
        weakSelf.fansCountLabel.text = [NSString stringWithFormat:@"%d",mineUser.fansCount.intValue];
        [weakSelf.avatarImgView sd_setImageWithURL:[NSURL URLWithString:mineUser.head]
                                  placeholderImage:[UIImage imageNamed:@"head"]];
        weakSelf.nameLabel.text = mineUser.nickName;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户数据失败" afterHideTime:DELAYTiME];
    }];
}

@end
