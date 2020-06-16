//
//  HomeBusinessCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeBusinessCell.h"

#import "HomeNewsModel.h"

@interface HomeBusinessCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation HomeBusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
}

- (void)setBusinessModel:(HomeNewsModel *)businessModel
{
    _businessModel = businessModel;
    _contentLabel.text = businessModel.content;
    _timeLabel.text = [self getTimeToTimeStr:businessModel.time];
}

- (NSString *)getTimeToTimeStr:(NSNumber *)time{
    NSInteger integerTime = time.integerValue;
    CGFloat iOSTime = integerTime/1000.0;
    NSDate * detailDate = [NSDate dateWithTimeIntervalSince1970:iOSTime];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [dateFormatter stringFromDate:detailDate];
    return timeStr;
}

@end
