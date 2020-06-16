//
//  LoginVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/9.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "LoginVC.h"

#import "RegisterVC.h"

#import "MineUserModel.h"

@interface LoginVC ()<RegisterVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    [self.accountTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}
- (void)textChange {
    if(self.accountTextF.text.length == 11 && self.pwdTextF.text.length != 0)
    {
        _loginBtn.enabled = YES;
    }
    else
    {
        _loginBtn.enabled = NO;
    }
}

- (void)initialSetup
{
    _accountView.layer.cornerRadius = 10;
    _accountView.layer.masksToBounds = YES;
    _pwdView.layer.cornerRadius = 10;
    _pwdView.layer.masksToBounds = YES;
}

- (IBAction)loginBtnClicked:(id)sender {
    [self loginWithPwd];
}

- (IBAction)registerBtnClicked:(id)sender {
    RegisterVC *registerVC = RegisterVC.new;
    registerVC.delegate = self;
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (void)dismissToRootViewController  {
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RegisterVCDelegate

- (void)RegisterVCDidGetUser:(RegisterVC *)registerVC
{
    if([self.delegate respondsToSelector:@selector(LoginVCDidGetUser:)])
    {
        [self.delegate LoginVCDidGetUser:self];
    }
}

#pragma mark - API

- (void)loginWithPwd
{
    WEAKSELF
    NSDictionary *dic = @{@"phone":_accountTextF.text,@"password":_pwdTextF.text,@"type":@(1),@"project":ProjectCategory};
    [ENDNetWorkManager getWithPathUrl:@"/system/login" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        mineUser = [MTLJSONAdapter modelOfClass:[MineUserModel class] fromJSONDictionary:result[@"data"] error:&error];
        //获取用户偏好
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //记录userId
        [userDefault setObject:mineUser.userId forKey:@"userId"];
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self dismissToRootViewController];
        if([self.delegate respondsToSelector:@selector(LoginVCDidGetUser:)])
        {
            [self.delegate LoginVCDidGetUser:self];
        }
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"登录失败" afterHideTime:DELAYTiME];
    }];
}

@end
