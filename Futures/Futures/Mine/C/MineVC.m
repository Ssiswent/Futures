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
#import "MineMessagesVC.h"
#import "MineCollectionVC.h"
#import "MineLikeVC.h"

#import "CheckInVC.h"

#import "CheckInModel.h"

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
@property (weak, nonatomic) IBOutlet UIView *dynamicView;
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *collectView;


@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong)NSNumber *userId;

@property (nonatomic, assign)BOOL hasUserId;

@property (strong , nonatomic) NSArray *checkInList;
@property (strong , nonatomic) NSMutableArray <NSDate *> *datesArray;
@property (nonatomic, assign) BOOL hasCheckedIn;

@end

@implementation MineVC

- (NSMutableArray<NSDate *> *)datesArray
{
    if(_datesArray == nil)
    {
        _datesArray = NSMutableArray.new;
    }
    return _datesArray;
}

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
    
    [self addGestures];
}

- (void)addGestures
{
    [self addClickAvatarGes];
    [self addClickLogoutViewGes];
    [self addClickAccountViewGes];
    [self addClickFocusViewGes];
    [self addClickFansViewGes];
    [self addClickMessagesViewGes];
    [self addClickDynamicViewGes];
    [self addClickCommentViewGes];
    [self addClickCollectViewGes];
    [self addClickLikeViewGes];
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
        [self getSignList];
        
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

- (IBAction)checkInBtnClicked:(id)sender {
    if(_hasUserId)
    {
        CheckInVC *checkInVC = CheckInVC.new;
        checkInVC.datesArray = _datesArray;
        checkInVC.checkInList = _checkInList;
        checkInVC.hasCheckedIn = _hasCheckedIn;
        [self.navigationController pushViewController:checkInVC animated:YES];
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

- (void)addClickMessagesViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messagesViewClicked)];
    [_messagesView addGestureRecognizer:tap];
}

- (void)messagesViewClicked
{
    if(_hasUserId)
    {
        MineMessagesVC *messagesVC = [[MineMessagesVC alloc] init];
        messagesVC.titleStr = @"消息";
        [self.navigationController pushViewController:messagesVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        [self.navigationController pushViewController:loginVC animated:YES];
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickDynamicViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarViewClicked)];
    [_dynamicView addGestureRecognizer:tap];
}

- (void)addClickCommentViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentViewClicked)];
    [_commentView addGestureRecognizer:tap];
}

- (void)commentViewClicked
{
    if(_hasUserId)
    {
        MineMessagesVC *messagesVC = [[MineMessagesVC alloc] init];
        messagesVC.titleStr = @"评论";
        [self.navigationController pushViewController:messagesVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        [self.navigationController pushViewController:loginVC animated:YES];
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickCollectViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectViewClicked)];
    [_collectView addGestureRecognizer:tap];
}

- (void)collectViewClicked
{
    if(_hasUserId)
    {
        MineCollectionVC *collectionVC = [[MineCollectionVC alloc] init];
        [self.navigationController pushViewController:collectionVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        [self.navigationController pushViewController:loginVC animated:YES];
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
}

- (void)addClickLikeViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeViewClicked)];
    [_likeView addGestureRecognizer:tap];
}

- (void)likeViewClicked
{
    if(_hasUserId)
    {
        MineLikeVC *likeVC = [[MineLikeVC alloc] init];
        likeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:likeVC animated:YES];
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

- (void)getSignList
{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager getWithPathUrl:@"/user/sign/getSignList" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        [weakSelf.datesArray removeAllObjects];
        weakSelf.hasCheckedIn = NO;
        weakSelf.checkInList = [MTLJSONAdapter modelsOfClass:[CheckInModel class] fromJSONArray:result[@"data"] error:&error];
        for (CheckInModel *checkInModel in weakSelf.checkInList) {
            NSDate *checkInDate = [NSDate dateWithTimeIntervalSince1970: checkInModel.time / 1000];
            [weakSelf.datesArray addObject:checkInDate];
            if([self isSameDay:checkInDate date2:[NSDate date]])
            {
                weakSelf.hasCheckedIn = YES;
            }
        }
        NSLog(@"datesArray:%@",weakSelf.datesArray);
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求签到记录失败" afterHideTime:DELAYTiME];
    }];
}

// 判断是否是同一天
- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}


@end
