//
//  RegisterVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/10.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "RegisterVC.h"

#import "MineCodeView.h"

#import "MineUserModel.h"

#import <ZXCountDownView.h>


@interface RegisterVC ()<MineCodeViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
@property (weak, nonatomic) IBOutlet ZXCountDownBtn *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@property (weak, nonatomic)UIView *coverView;
@property (weak, nonatomic)MineCodeView *mineCodeView;
@property (copy, nonatomic)NSString *picCode;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.accountTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    [self.codeBtn setCountDown:10 mark:@"codeBtn" resTextFormat:^NSString * _Nullable(long remainSec) {
        [self codeBtnCountViewStatus];
        //显示剩余几分几秒
        return [NSString stringWithFormat:@"%lds",remainSec];
    }];
}

//查看计时器的状态
- (void)codeBtnCountViewStatus {
    //判断计时器是否是开启状态,是就执行以下操作
    if (self.codeBtn.countViewStatus == ZXCountViewStatusRunning) {
        _codeBtn.enabled = NO;
    }
    else
    {
        _codeBtn.enabled = YES;
    }
}

- (void)textChange {
    if(self.accountTextF.text.length == 11 && self.pwdTextF.text.length != 0)
    {
        _codeBtn.enabled = YES;
    }
    else
    {
        _codeBtn.enabled = NO;
    }
    if(self.accountTextF.text.length == 11 && self.pwdTextF.text.length != 0 && self.codeTextF.text.length != 0)
    {
        _registerBtn.enabled = YES;
    }
    else
    {
        _registerBtn.enabled = NO;
    }
}

- (IBAction)codeBtnClicked:(id)sender {
    MineCodeView *mineCodeView = [[NSBundle mainBundle]loadNibNamed:@"MineCodeView" owner:nil options:nil].firstObject;
    mineCodeView.delegate = self;
    self.mineCodeView = mineCodeView;
    [self addCoverView];
    [self getPicCode];
}

- (IBAction)registerBtnClicked:(id)sender {
    [self register];
}

- (void)dismissToRootViewController  {
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeCoverView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.mineCodeView.alpha = 0;
        CGRect frame = self.mineCodeView.frame;
        frame.size = CGSizeMake(0, 0);
        self.mineCodeView.frame = frame;
    }completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}

- (void)addCoverView
{
    UIView *coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    _mineCodeView.alpha = 0;
    _mineCodeView.center = coverView.center;
    CGRect frame = _mineCodeView.frame;
    frame.size = CGSizeMake(0, 0);
    _mineCodeView.frame = frame;
    [coverView addSubview:_mineCodeView];
    _coverView = coverView;
    
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *keyWindow = [array objectAtIndex:0];
    [keyWindow addSubview:_coverView];
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.mineCodeView.alpha = 1;
        CGRect frame = self.mineCodeView.frame;
        frame.size = CGSizeMake(340, 181);
        self.mineCodeView.frame = frame;
    }];
}

#pragma mark - MineCodeViewDelegate

- (void)MineCodeViewDidClickCancelBtn:(MineCodeView *)mineCodeView
{
    [self removeCoverView];
}

- (void)MineCodeViewDidClickConfirmBtn:(MineCodeView *)mineCodeView inputCode:(NSString *)inputCode
{
    self.picCode = inputCode;
    [self sendCode];
}

- (void)MineCodeViewDidClickChangeBtn:(MineCodeView *)mineCodeView
{
    [self getPicCode];
}

- (void)MineCodeViewDidClickCodeImgView:(MineCodeView *)mineCodeView
{
    [self getPicCode];
}

#pragma mark - API

- (void)getPicCode
{
    WEAKSELF
    [ENDNetWorkManager getWithPathUrl:@"/system/sendVerify" parameters:nil queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSString *dataStr = result[@"data"];
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imgData];
        weakSelf.mineCodeView.codeImgView.image = image;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"获取图形验证码失败" afterHideTime:DELAYTiME];
    }];
}

- (void)sendCode
{
    WEAKSELF
    if([self.picCode isEqualToString:@""])
    {
        self.picCode = @" ";
    }
    NSDictionary *dic = @{@"phone":self.accountTextF.text,@"type":@(1),@"project":ProjectCategory,@"code":self.picCode};
    [ENDNetWorkManager postWithPathUrl:@"/system/sendCode" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        [self removeCoverView];
        [self.codeBtn startCountDown];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.coverView Message:@"发送验证码失败" afterHideTime:DELAYTiME];
    }];
    
}

- (void)register
{
    WEAKSELF
    NSDictionary *dic = @{@"phone":self.accountTextF.text,@"password":self.pwdTextF.text,@"confirmPassword":self.pwdTextF.text,@"code":self.codeTextF.text,@"type":@(1),@"project":ProjectCategory};
    [ENDNetWorkManager postWithPathUrl:@"/system/register" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        mineUser = [MTLJSONAdapter modelOfClass:[MineUserModel class] fromJSONDictionary:result[@"data"] error:&error];
        //获取用户偏好
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //记录userId
        [userDefault setObject:mineUser.userId forKey:@"userId"];
        [weakSelf dismissToRootViewController];
        if([self.delegate respondsToSelector:@selector(RegisterVCDidGetUser:)])
        {
            [self.delegate RegisterVCDidGetUser:self];
        }
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"注册失败" afterHideTime:DELAYTiME];
    }];
}


@end
