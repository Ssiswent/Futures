//
//  CommunityFocusCollectionCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityFocusCollectionCell.h"

#import "UserModel.h"

@interface CommunityFocusCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CommunityFocusCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _avatarImgView.layer.cornerRadius = 17.5;
    _avatarImgView.layer.masksToBounds = YES;
}

- (void)setRecommendUserModel:(UserModel *)recommendUserModel
{
    _recommendUserModel = recommendUserModel;
    [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:recommendUserModel.head]
    placeholderImage:[UIImage imageNamed:@"avatar"]];
    _nameLabel.text = recommendUserModel.nickName;
}

- (IBAction)focusBtnClicked:(id)sender {
    _focusBtn.hidden = YES;
}

@end
