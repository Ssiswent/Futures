//
//  DynamicDetailCommentCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "DynamicDetailCommentCell.h"

#import "UIImage+Image.h"

#import "CommentModel.h"
#import "UserModel.h"

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

- (void)setCommentModel:(CommentModel *)commentModel
{
    _commentModel = commentModel;
    
    _commentLabel.text = commentModel.content;
    
    UserModel *userModel = commentModel.user;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head]
                          placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.nameLabel.text = userModel.nickName;
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:commentModel.publishTime / 1000];
    NSDate *todayDate = [NSDate date];
    NSTimeInterval doubleDistance = [todayDate timeIntervalSinceDate:publishDate];
    NSInteger integerDistance = doubleDistance;
    NSInteger secondsInAnHour = 3600;
    NSInteger secondsInAMinitue = 60;
    NSInteger hoursInADay = 24;
    NSInteger hoursBetweenDates = integerDistance / secondsInAnHour;
    NSInteger minutesBetweenDates = integerDistance % secondsInAnHour / secondsInAMinitue;
    NSInteger daysBetweenDates = hoursBetweenDates / hoursInADay;
    
    NSString *timeStr1 = [NSString stringWithFormat:@"%ld小时%ld分钟前",(long)hoursBetweenDates,(long)minutesBetweenDates];
    NSString *timeStr2 = [NSString stringWithFormat:@"%ld分钟前",(long)minutesBetweenDates];
    NSString *timeStr3 = [NSString stringWithFormat:@"%ld天前",(long)daysBetweenDates];
    
    if(hoursBetweenDates <= 0)
    {
        self.timeLabel.text = timeStr2;
    }
    else if (hoursBetweenDates > 0 && hoursBetweenDates < 24)
    {
        self.timeLabel.text = timeStr1;
    }
    else
    {
        self.timeLabel.text = timeStr3;
    }
}

@end
