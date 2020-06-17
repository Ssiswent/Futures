//
//  HomeFocusAndFansCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineFocusAndFansCell.h"

#import "UIImage+Image.h"

#import "UserModel.h"

@interface MineFocusAndFansCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation MineFocusAndFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIColor *btnBgNormalColor = [UIColor colorWithHexString:@"#293AFF"];
    UIImage *btnBgNormalImg = [UIImage imageWithColor:btnBgNormalColor];
    UIColor *btnBgSelectedColor = [UIColor colorWithHexString:@"#E9E9E9"];
    UIImage *btnBgSelectedImg = [UIImage imageWithColor:btnBgSelectedColor];
    [self.focusBtn setBackgroundImage:btnBgNormalImg forState:UIControlStateNormal];
    [self.focusBtn setBackgroundImage:btnBgSelectedImg forState:UIControlStateSelected];
    self.focusBtn.layer.cornerRadius = 5;
    self.focusBtn.layer.masksToBounds = YES;
    
    _avatarImgView.layer.cornerRadius = 30;
    _avatarImgView.layer.masksToBounds = YES;
}

- (IBAction)focusBtnClicked:(id)sender {
    _focusBtn.selected = !_focusBtn.selected;
}

- (void)setModel:(UserModel *)model
{
    _model = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.head]
    placeholderImage:[UIImage imageNamed:@"head"]];
    _nameLabel.text = model.nickName;
}

@end
