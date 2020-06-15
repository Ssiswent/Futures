//
//  HomeCalendarColletionCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/15.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeCalendarColletionCell.h"

@interface HomeCalendarColletionCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImgView;

@end

@implementation HomeCalendarColletionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *string = _contentLabel.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    _contentLabel.attributedText = attributedString;
    
    _flagImgView.layer.cornerRadius = 3;
    _flagImgView.layer.masksToBounds = YES;
}

@end
