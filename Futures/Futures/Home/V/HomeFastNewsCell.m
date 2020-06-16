//
//  HomeFastNewsCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeFastNewsCell.h"

#import "HomeNewsModel.h"

@interface HomeFastNewsCell()

@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation HomeFastNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _circleView.layer.borderColor = [UIColor colorWithHexString:@"#543EE4"].CGColor;
    _circleView.layer.borderWidth = 1;
    _circleView.layer.cornerRadius = 3;
    _circleView.layer.masksToBounds = YES;
}

- (void)setFastNewsModel:(HomeNewsModel *)fastNewsModel
{
    _fastNewsModel = fastNewsModel;
    _contentLabel.text = fastNewsModel.content;
    _timeLabel.text = [self getTimeToTimeStr:fastNewsModel.time];
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
