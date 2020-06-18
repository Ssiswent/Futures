//
//  DynamicDetailContentCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "DynamicDetailContentCell.h"
#import "UIImage+Image.h"

#import "CommunityDynamicModel.h"
#import "UserModel.h"

@interface DynamicDetailContentCell()

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgViewTop;


@end

@implementation DynamicDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialSetup];
}

- (void)initialSetup
{
    UIColor *btnBgNormalColor = [UIColor colorWithHexString:@"#293AFF"];
    UIImage *btnBgNormalImg = [UIImage imageWithColor:btnBgNormalColor];
    UIColor *btnBgSelectedColor = [UIColor colorWithHexString:@"#E9E9E9"];
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

- (void)setDynamicModel:(CommunityDynamicModel *)dynamicModel
{
    _dynamicModel = dynamicModel;
    
    UserModel *userModel = dynamicModel.user;
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head]
                          placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.nameLabel.text = userModel.nickName;
    self.contentLabel.text = dynamicModel.content;
    
    if(dynamicModel.picture)
    {
        self.contentImgView.hidden = NO;
        self.contentImgViewHeight.constant = 200;
        self.contentImgViewTop.constant = 12.5;
        [self.contentImgView sd_setImageWithURL:[NSURL URLWithString:dynamicModel.picture]
                               placeholderImage:[UIImage imageNamed:@"contentImg"]];
    }
    else
    {
        self.contentImgView.hidden = YES;
        self.contentImgViewHeight.constant = 0;
        self.contentImgViewTop.constant = 0;
    }
    
    _timeLabel.text = [self getTimeToTimeStr:dynamicModel.publishTime];
    _dateLabel.text = [self getTimeToDateStr:dynamicModel.publishTime];
}

- (NSString *)getTimeToTimeStr:(double)time{
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [dateFormatter stringFromDate:publishDate];
    return timeStr;
}

- (NSString *)getTimeToDateStr:(double)time{
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:publishDate];
    return dateStr;
}

@end
