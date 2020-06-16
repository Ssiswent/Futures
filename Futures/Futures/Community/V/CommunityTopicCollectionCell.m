//
//  CommunityTopicCollectionCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityTopicCollectionCell.h"

#import "UIImage+Image.h"

#import "HomeNewsModel.h"

@interface CommunityTopicCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CommunityTopicCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *btnBgNormalColor = [UIColor whiteColor];
    UIImage *btnBgNormalImg = [UIImage imageWithColor:btnBgNormalColor];
    UIColor *btnBgSelectedColor = [UIColor colorWithHexString:@"#E9E9E9"];
    UIImage *btnBgSelectedImg = [UIImage imageWithColor:btnBgSelectedColor];
    [self.focusBtn setBackgroundImage:btnBgNormalImg forState:UIControlStateNormal];
    [self.focusBtn setBackgroundImage:btnBgSelectedImg forState:UIControlStateSelected];
    self.focusBtn.layer.cornerRadius = 10;
    self.focusBtn.layer.masksToBounds = YES;
}

- (void)setTopicModel:(HomeNewsModel *)topicModel
{
    _topicModel = topicModel;
    _contentLabel.text = topicModel.content;
}

- (IBAction)focusBtnClicked:(id)sender {
    _focusBtn.selected = !_focusBtn.selected;
}

@end
