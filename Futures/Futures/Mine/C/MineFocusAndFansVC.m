//
//  MineFocusAndFansVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineFocusAndFansVC.h"

#import "HomeFocusAndFansCell.h"
#import "UIImage+OriginalImage.h"

#import "UserModel.h"

#import "MineUserModel.h"

#import "CustomTBC.h"

#import "EmptyView.h"

@interface MineFocusAndFansVC ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *focusAndFansTableView;

@property (strong, nonatomic)NSArray *followsArray;

@property (nonatomic, strong)NSNumber *userId;

@end

@implementation MineFocusAndFansVC

NSString *HomeFocusAndFansCellID = @"HomeFocusAndFansCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserDefault];
    [self initialSetUp];
    [self.focusAndFansTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeFocusAndFansCell class]) bundle:nil] forCellReuseIdentifier:HomeFocusAndFansCellID];
}

- (void)initialSetUp
{
    self.title = _titleStr;
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    if([_focusOrFans isEqualToString:@"focus"])
    {
        [self getFollows];
        if([_user.followCount isEqualToNumber:@0])
        {
            EmptyView *emptyView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([EmptyView class]) owner:nil options:nil].firstObject;
            [self.focusAndFansTableView removeFromSuperview];
            [self.view addSubview:emptyView];
            [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(153, 200));
            }];
        }
    }
    else if([_focusOrFans isEqualToString:@"Fans"])
    {
        [self getFans];
        if([_user.fansCount isEqualToNumber:@0])
        {
            EmptyView *emptyView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([EmptyView class]) owner:nil options:nil].firstObject;
            [self.focusAndFansTableView removeFromSuperview];
            [self.view addSubview:emptyView];
            [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(153, 200));
            }];
        }
    }
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.followsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeFocusAndFansCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeFocusAndFansCellID];
    if([_focusOrFans isEqualToString:@"focus"])
    {
        cell.focusBtn.selected = YES;
    }
    cell.model = self.followsArray[indexPath.row];
    return cell;
}

#pragma mark - API

-(void)getFollows{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId,@"type":@1};
    [ENDNetWorkManager getWithPathUrl:@"/user/follow/getUserFollowList" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.followsArray = [MTLJSONAdapter modelsOfClass:[UserModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.focusAndFansTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求关注列表失败" afterHideTime:DELAYTiME];
    }];
}

-(void)getFans{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId,@"type":@2};
    [ENDNetWorkManager getWithPathUrl:@"/user/follow/getUserFollowList" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.followsArray = [MTLJSONAdapter modelsOfClass:[UserModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.focusAndFansTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求粉丝列表失败" afterHideTime:DELAYTiME];
    }];
}

@end
