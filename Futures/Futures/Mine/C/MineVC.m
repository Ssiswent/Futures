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
#import "UserModel.h"

#import "CustomTBC.h"

#import "MineDynamicVC.h"

#import "AccountSwitchVC.h"

#import "MineEditVC.h"

#import "MineFocusAndFansVC.h"

@interface MineVC ()<YPNavigationBarConfigureStyle, LoginVCDelegate, AccountSwitchVCDelegate>

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

@property (weak, nonatomic) IBOutlet UIView *focusView;
@property (weak, nonatomic) IBOutlet UIView *fansView;
@property (weak, nonatomic) IBOutlet UIView *messagesView;


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
    [self addClickFocusViewGes];
    [self addClickFansViewGes];
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

- (IBAction)editBtnClicked:(id)sender {
    if(_hasUserId)
    {
        MineEditVC *mineEditVC = MineEditVC.new;
        MineUserModel *user = [MineUserModel sharedMineUserModel];
        mineEditVC.user = user;
        [self.navigationController pushViewController:mineEditVC animated:YES];
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
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    if(userId == nil)
    {
        LoginVC *loginVC = [LoginVC new];
        loginVC.delegate = self;
        //    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else
    {
        AccountSwitchVC *accountSwitchVC = AccountSwitchVC.new;
        accountSwitchVC.delegate = self;
        [self presentViewController:accountSwitchVC animated:YES completion:nil];
    }
}

- (void)addClickFocusViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusViewClicked)];
    [_focusView addGestureRecognizer:tap];
}

- (void)focusViewClicked
{
    if(_hasUserId)
    {
        MineFocusAndFansVC *focusAndFansVC = [[MineFocusAndFansVC alloc] init];
        focusAndFansVC.titleStr = @"关注";
        focusAndFansVC.focusOrFans = @"focus";
        MineUserModel *user = [MineUserModel sharedMineUserModel];
        focusAndFansVC.user = user;
        [self.navigationController pushViewController:focusAndFansVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        [self.navigationController pushViewController:loginVC animated:YES];
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickFansViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fansViewClicked)];
    [_fansView addGestureRecognizer:tap];
}

- (void)fansViewClicked
{
    if(_hasUserId)
    {
        MineFocusAndFansVC *focusAndFansVC = [[MineFocusAndFansVC alloc] init];
        focusAndFansVC.titleStr = @"粉丝";
        focusAndFansVC.focusOrFans = @"Fans";
        MineUserModel *user = [MineUserModel sharedMineUserModel];
        focusAndFansVC.user = user;
        [self.navigationController pushViewController:focusAndFansVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        [self.navigationController pushViewController:loginVC animated:YES];
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
}

#pragma mark - LoginVCDelegate

- (void)LoginVCDidGetUser:(LoginVC *)loginVC
{
    [self getUserDefault];
}

#pragma mark - AccountSwitchVCDelegate

- (void)accountSwitchVCDidGetUser:(AccountSwitchVC *)accountSwitchVC
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
        UserModel *user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:result[@"data"] error:&error];
        mineUser.userId = user.userId;
        mineUser.nickName = user.nickName;
        mineUser.followCount = user.followCount;
        mineUser.fansCount = user.fansCount;
        mineUser.head = user.head;
        mineUser.signature = user.signature;
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
