//
//  MineVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/3.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineVC.h"

#import "MineSettingsVC.h"

#import "MineUserModel.h"

@interface MineVC ()<YPNavigationBarConfigureStyle>

@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIView *levelView;
@property (weak, nonatomic) IBOutlet UIView *sexView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup
{
    _avatarView.layer.cornerRadius = 37.5;
    _avatarView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 32.5;
    _avatarImgView.layer.masksToBounds = YES;
    _levelView.layer.cornerRadius = 10;
    _levelView.layer.masksToBounds = YES;
    _sexView.layer.cornerRadius = 10;
    _sexView.layer.masksToBounds = YES;
    
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,0);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 37;
}

- (IBAction)settingsBtnClicked:(id)sender {
    MineSettingsVC *settingsVC = MineSettingsVC.new;
    [self.navigationController pushViewController:settingsVC animated:YES];
}

#pragma mark - yp_navigtionBarConfiguration
- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    return YPNavigationBarHidden;
}

- (UIColor *)yp_navigationBarTintColor{
    return [UIColor whiteColor];
}

@end
