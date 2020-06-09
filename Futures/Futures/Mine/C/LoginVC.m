//
//  LoginVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/9.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "LoginVC.h"

#import "MineUserModel.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
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


#pragma mark - API

- (void)loginWithPwd
{
    WEAKSELF
    NSDictionary *dic = @{@"phone":_accountTextF.text,@"password":_pwdTextF.text,@"type":@(1),@"project":ProjectCategory};
    [ENDNetWorkManager getWithPathUrl:@"/system/login" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        mineUser = [MTLJSONAdapter modelOfClass:[MineUserModel class] fromJSONDictionary:result[@"data"] error:&error];
        NSLog(@"User:%@",mineUser);
        //获取用户偏好
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //记录userId
        [userDefault setObject:mineUser.userId forKey:@"userId"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"登录失败" afterHideTime:DELAYTiME];
    }];
}

@end
