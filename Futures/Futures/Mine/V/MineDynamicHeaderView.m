//
//  MineDynamicHeaderView.m
//  Futures
//
//  Created by Ssiswent on 2020/6/11.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineDynamicHeaderView.h"

#import "MineUserModel.h"

@interface MineDynamicHeaderView()
@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerBgImgView;
@property (nonatomic, assign) CGRect headerBgImgViewFrame;

@end

@implementation MineDynamicHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _avatarView.layer.cornerRadius = 37.5;
    _avatarView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 32.5;
    _avatarImgView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerBgImgViewFrame = self.bounds;
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    CGRect frame = self.headerBgImgViewFrame;
    frame.size.height -= contentOffsetY;
    frame.origin.y = contentOffsetY;
    self.headerBgImgView.frame = frame;
}

- (void)setMineUser:(MineUserModel *)mineUser
{
    _mineUser = mineUser;
    self.followsCountLabel.text = [NSString stringWithFormat:@"%d",mineUser.followCount.intValue];
    self.fansCountLabel.text = [NSString stringWithFormat:@"%d",mineUser.fansCount.intValue];
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:mineUser.head]
                              placeholderImage:[UIImage imageNamed:@"head"]];
    self.nameLabel.text = mineUser.nickName;
}

@end
