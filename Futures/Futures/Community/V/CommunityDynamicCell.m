//
//  CommunityDynamicCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityDynamicCell.h"

#import "CommunityDynamicModel.h"
#import "UserModel.h"

#import "UIImage+Image.h"

@interface CommunityDynamicCell()

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImgView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewTop;

@end

@implementation CommunityDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialSetup];
    [self addLikeViewGes];
}

- (void)initialSetup
{
    UIColor *btnBgNormalColor = [UIColor colorWithHexString:@"#293AFF"];
    UIImage *btnBgNormalImg = [UIImage imageWithColor:btnBgNormalColor];
    UIColor *btnBgSelectedColor = [UIColor systemGray4Color];
    UIImage *btnBgSelectedImg = [UIImage imageWithColor:btnBgSelectedColor];
    [self.focusBtn setBackgroundImage:btnBgNormalImg forState:UIControlStateNormal];
    [self.focusBtn setBackgroundImage:btnBgSelectedImg forState:UIControlStateSelected];
    self.focusBtn.layer.cornerRadius = 5;
    self.focusBtn.layer.masksToBounds = YES;
    
    _avatarImgView.layer.cornerRadius = 15;
    _avatarImgView.layer.masksToBounds = YES;
    
    _contentImgView.layer.cornerRadius = 10;
    _contentImgView.layer.masksToBounds = YES;
}

- (IBAction)focusBtnClicked:(id)sender {
    _focusBtn.selected = !_focusBtn.selected;
}

 - (void)addLikeViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeViewClicked)];
    [_likeView addGestureRecognizer:tap];
}

- (void)likeViewClicked
{
    self.dynamicModel.dynamicLiked = !self.dynamicModel.dynamicLiked;
    if(self.dynamicModel.dynamicLiked)
    {
        self.dynamicModel.zanCount ++;
        _likeImgView.image = [UIImage imageNamed:@"like_high"];
        _likeCountLabel.textColor = [UIColor colorWithHexString:@"#293AFF"];
        _likeCountLabel.text = @"18";
    }
    else
    {
        self.dynamicModel.zanCount --;
        _likeImgView.image = [UIImage imageNamed:@"like_nor"];
        _likeCountLabel.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
        _likeCountLabel.text = @"17";
    }
    _likeCountLabel.text =  [NSString stringWithFormat:@"%ld",(long)self.dynamicModel.zanCount];
}

- (void)setDynamicModel:(CommunityDynamicModel *)dynamicModel
{
    _dynamicModel = dynamicModel;
    
    UserModel *userModel = dynamicModel.user;
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head]
    placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.nameLabel.text = userModel.nickName;

//    NSArray *contentArray = [dynamicModel.content componentsSeparatedByString:@"\r\n\r\n"];
//    self.titleLabel.text = contentArray[0];
//    self.contentLabel.text = contentArray[1];
    self.contentLabel.text = dynamicModel.content;
    
    if(dynamicModel.picture)
    {
        self.contentImgView.hidden = NO;
        self.contentImgViewHeight.constant = 200;
        self.contentImgViewTop.constant = 5;
        [self.contentImgView sd_setImageWithURL:[NSURL URLWithString:dynamicModel.picture]
        placeholderImage:[UIImage imageNamed:@"contentImg"]];
    }
    else
    {
        self.contentImgView.hidden = YES;
        self.contentImgViewHeight.constant = 0;
        self.contentImgViewTop.constant = 0;
    }
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:dynamicModel.publishTime / 1000];
    NSDate *todayDate = [NSDate date];
    NSTimeInterval doubleDistance = [todayDate timeIntervalSinceDate:publishDate];
    NSInteger integerDistance = doubleDistance;
    NSInteger secondsInAnHour = 3600;
    NSInteger secondsInAMinitue = 60;
    NSInteger hoursBetweenDates = integerDistance / secondsInAnHour;
    NSInteger minutesBetweenDates = integerDistance % secondsInAnHour / secondsInAMinitue;
    
    NSString *timeStr1 = [NSString stringWithFormat:@"%ld小时%ld分钟前更新",(long)hoursBetweenDates,(long)minutesBetweenDates];
    NSString *timeStr2 = [NSString stringWithFormat:@"%ld分钟前更新",(long)minutesBetweenDates];
    
    if(hoursBetweenDates > 0)
    {
        self.timeLabel.text = timeStr1;
    }
    else
    {
        self.timeLabel.text = timeStr2;
    }
    
    _likeCountLabel.text =  [NSString stringWithFormat:@"%ld",(long)dynamicModel.zanCount];
    if(self.dynamicModel.dynamicLiked)
    {
        _likeImgView.image = [UIImage imageNamed:@"like_high"];
        _likeCountLabel.textColor = [UIColor colorWithHexString:@"#293AFF"];
    }
    else
    {
        _likeImgView.image = [UIImage imageNamed:@"like_nor"];
        _likeCountLabel.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    }
    
    _commentCountLabel.text =  [NSString stringWithFormat:@"%ld",(long)dynamicModel.commentCount];
}

@end
