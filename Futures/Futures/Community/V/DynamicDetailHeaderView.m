//
//  DynamicDetailHeaderView.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "DynamicDetailHeaderView.h"

@interface DynamicDetailHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation DynamicDetailHeaderView

+ (instancetype)dynamicDetailHeaderView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DynamicDetailHeaderView class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _lineView.layer.cornerRadius = 1.5;
    _lineView.layer.masksToBounds = YES;
    
    //随机转发、点赞数
    int count1 = arc4random() % 21;
    int count2 = arc4random() % 21;
    _shareCountLabel.text = [NSString stringWithFormat:@"%d",count1];
    _likeCountLabel.text = [NSString stringWithFormat:@"%d",count2];
}

- (IBAction)commentBtnClicked:(id)sender {
    _commentBtn.selected = YES;
    _shareBtn.selected = NO;
    _likeBtn.selected = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        WEAKSELF
        CGPoint center = weakSelf.lineView.center;
        center.x = weakSelf.commentBtn.center.x;
        weakSelf.lineView.center = center;
    }];
}

- (IBAction)shareBtnClicked:(id)sender {
    _commentBtn.selected = NO;
    _shareBtn.selected = YES;
    _likeBtn.selected = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        WEAKSELF
        CGPoint center = weakSelf.lineView.center;
        center.x = weakSelf.shareBtn.center.x;
        weakSelf.lineView.center = center;
    }];
}

- (IBAction)likeBtnClicked:(id)sender {
    _commentBtn.selected = NO;
    _shareBtn.selected = NO;
    _likeBtn.selected = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        WEAKSELF
        CGPoint center = weakSelf.lineView.center;
        center.x = weakSelf.likeBtn.center.x;
        weakSelf.lineView.center = center;
    }];
}


@end
