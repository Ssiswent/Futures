//
//  HomeNewsTimeCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeNewsTimeCell.h"

@interface HomeNewsTimeCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation HomeNewsTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"M月d日"];
    NSString *timeStr = [dateFormatter stringFromDate:todayDate];
    _dateLabel.text = timeStr;
}



@end
