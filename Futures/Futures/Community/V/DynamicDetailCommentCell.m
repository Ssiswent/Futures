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
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@end

@implementation DynamicDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialSetup];
}

- (void)initialSetup
{
    _replyView.layer.cornerRadius = 5;
    _replyView.layer.masksToBounds = YES;
    
    _avatarImgView.layer.cornerRadius = 15;
    _avatarImgView.layer.masksToBounds = YES;
    
    //    [_seeAllBtn setTitle:@"查看全部999条回复" forState:UIControlStateNormal];
    
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:@"squall回复@价值荣耀：我估计，肯定有效，不过， 如果，换成其他人，出于人道主义，就给了，遇..."];
    // 改变文字颜色
    [attributedText setAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithHexString:@"#293AFF"]} range:NSMakeRange(0, 6)];
    // 改变文字颜色
    [attributedText setAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithHexString:@"#293AFF"]} range:NSMakeRange(8, 5)];
    _replyLabel.attributedText = attributedText;
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
