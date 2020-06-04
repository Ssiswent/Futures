//
//  HomeNewsCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeNewsCell.h"

#import "HomeNewsModel.h"

@interface HomeNewsCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation HomeNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setNewsModel:(HomeNewsModel *)newsModel
{
    _newsModel = newsModel;
    _contentLabel.text = newsModel.content;
    _countryLabel.text = newsModel.country;
    _timeLabel.text = [self getTimeToTimeStr:newsModel.time];
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
