//
//  MineVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/3.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineVC.h"

#import "MineUserModel.h"

@interface MineVC ()

@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIView *levelView;
@property (weak, nonatomic) IBOutlet UIView *sexView;


@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    _avatarView.layer.cornerRadius = 37.5;
    _avatarView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 32.5;
    _avatarImgView.layer.masksToBounds = YES;
    _levelView.layer.cornerRadius = 10;
    _levelView.layer.masksToBounds = YES;
    _sexView.layer.cornerRadius = 10;
    _sexView.layer.masksToBounds = YES;
}

@end
