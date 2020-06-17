//
//  HomeMessageCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineMessageCell.h"

@interface MineMessageCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

@end

@implementation MineMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImgView.layer.cornerRadius = 30;
    _avatarImgView.layer.masksToBounds = YES;
}

@end
