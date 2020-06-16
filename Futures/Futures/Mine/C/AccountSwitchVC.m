//
//  AccountSwitchVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "AccountSwitchVC.h"

#import "CustomTBC.h"

#import "MineUserModel.h"

#import "LoginVC.h"

@interface AccountSwitchVC ()<LoginVCDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIView *circleView;

@property (nonatomic, strong) NSNumber *userId;

@end

@implementation AccountSwitchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarImgView.layer.cornerRadius = 15;
    _avatarImgView.layer.masksToBounds = YES;
    _circleView.layer.cornerRadius = 3;
    _circleView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserDefault];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
    [self getUser];
}

- (IBAction)switchBtnClicked:(id)sender {
    LoginVC *loginVC = [LoginVC new];
    loginVC.delegate = self;
    //        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - LoginVCDelegate

- (void)LoginVCDidGetUser:(LoginVC *)loginVC
{
    [self getUserDefault];
    if([self.delegate respondsToSelector:@selector(accountSwitchVCDidGetUser:)])
    {
        [self.delegate accountSwitchVCDidGetUser:self];
    }
}

#pragma mark - API

-(void)getUser{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/personal/queryUser" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        mineUser = [MTLJSONAdapter modelOfClass:[MineUserModel class] fromJSONDictionary:result[@"data"] error:&error];
        [weakSelf.avatarImgView sd_setImageWithURL:[NSURL URLWithString:mineUser.head]];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户数据失败" afterHideTime:DELAYTiME];
    }];
}

@end
