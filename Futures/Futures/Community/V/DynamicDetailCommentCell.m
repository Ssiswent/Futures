//
//  DynamicDetailCommentCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "DynamicDetailCommentCell.h"

#import "UIImage+Image.h"

@interface DynamicDetailCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeAllBtn;

@end

@implementation DynamicDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialSetup];
}

- (void)initialSetup
{
    
    UIColor *btnBgNormalColor = [UIColor colorWithHexString:@"#E9E9E9"];
    UIImage *btnBgNormalImg = [UIImage imageWithColor:btnBgNormalColor];
    [_seeAllBtn setBackgroundImage:btnBgNormalImg forState:UIControlStateNormal];
    _seeAllBtn.layer.cornerRadius = 5;
    _seeAllBtn.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius = 15;
    _avatarImgView.layer.masksToBounds = YES;
    
//    [_seeAllBtn setTitle:@"查看全部999条回复" forState:UIControlStateNormal];
}

@end
