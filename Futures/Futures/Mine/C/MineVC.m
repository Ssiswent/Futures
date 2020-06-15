//
//  MineVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/3.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineVC.h"
#import "MineSettingsVC.h"
#import "LoginVC.h"
#import "MineDynamicVC.h"

#import "MineUserModel.h"

#import "CustomTBC.h"

#import "MineDynamicVC.h"

@interface MineVC ()<YPNavigationBarConfigureStyle, LoginVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarImgViewWidth;

@property (weak, nonatomic) IBOutlet UIView *levelView;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *messagesCountLabel;

@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdViewWidth;
@property (weak, nonatomic) IBOutlet UIView *pwdContentView;
@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UIView *accountView;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;


@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong)NSNumber *userId;

@property (nonatomic, assign)BOOL hasUserId;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CustomTBC setTabBarHidden:NO TabBarVC:self.tabBarController];
}

- (void)initialSetup
{
    _avatarView.layer.cornerRadius = 37.5;
    _avatarView.layer.masksToBounds = YES;
    _levelView.layer.cornerRadius = 10;
    _levelView.layer.masksToBounds = YES;
    _sexView.layer.cornerRadius = 10;
    _sexView.layer.masksToBounds = YES;
    
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,0);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 37;
    
    [self addClickAvatarGes];
    [self addClickLogoutViewGes];
    [self addClickAccountViewGes];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    if(userId != nil)
    {
        _userId = userId;
        _hasUserId = YES;
        [self getUser];
        
        self.avatarImgViewWidth.constant = 65;
        self.avatarImgViewHeight.constant = 65;
        _avatarImgView.layer.cornerRadius = 32.5;
        _avatarImgView.layer.masksToBounds = YES;
        
        _pwdViewWidth.constant = 0;
        _pwdView.hidden = NO;
        _pwdContentView.hidden = NO;
        _logoutView.hidden = NO;
        _accountLabel.text = @"切换账号";
    }
    else
    {
        [self clearUser];
    }
}

- (void)clearUser
{
    _hasUserId = NO;
    
    self.followsCountLabel.text = @"0";
    self.fansCountLabel.text = @"0";
    self.messagesCountLabel.text = @"0";
    self.avatarImgView.image = [UIImage imageNamed:@"defaultHead"];
    self.nameLabel.text = @"登录后更精彩";
    self.avatarImgViewWidth.constant = 35;
    self.avatarImgViewHeight.constant = 40;
    _avatarImgView.layer.cornerRadius = 0;
    _avatarImgView.layer.masksToBounds = YES;
    
    _pwdViewWidth.constant = -SCREEN_WIDTH * 0.25;
    _pwdView.hidden = YES;
    _pwdContentView.hidden = YES;
    _logoutView.hidden = YES;
    _accountLabel.text = @"登录账号";
}

- (IBAction)settingsBtnClicked:(id)sender {
    MineSettingsVC *settingsVC = MineSettingsVC.new;
    [self.navigationController pushViewController:settingsVC animated:YES];
}

#pragma mark - Gestures

- (void)addClickAvatarGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarViewClicked)];
    [_avatarView addGestureRecognizer:tap];
}

- (void)avatarViewClicked
{
    if(_hasUserId)
    {
//        MineDynamicVC *mineDynamicVC = MineDynamicVC.new;
//        [self.navigationController pushViewController:mineDynamicVC animated:YES];
        MineDynamicVC *pageVC = MineDynamicVC.new;
        [self.navigationController pushViewController:pageVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        loginVC.delegate = self;
//        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickLogoutViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoutViewClicked)];
    [_logoutView addGestureRecognizer:tap];
}

- (void)logoutViewClicked
{
    //清空userId
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:@"userId"];
    [self clearUser];
}

- (void)addClickAccountViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(accountViewClicked)];
    [_accountView addGestureRecognizer:tap];
}

- (void)accountViewClicked
{
    LoginVC *loginVC = [LoginVC new];
    loginVC.delegate = self;
//    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - LoginVCDelegate

- (void)LoginVCDidGetUser:(LoginVC *)loginVC
{
    [self getUserDefault];
}

#pragma mark - yp_navigtionBarConfiguration
- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarHidden;
}

- (UIColor *)yp_navigationBarTintColor{
    return [UIColor whiteColor];
}

#pragma mark - API

-(void)getUser{
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
