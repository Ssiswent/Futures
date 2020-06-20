//
//  CoverView.m
//  Futures
//
//  Created by Ssiswent on 2020/6/20.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CoverView.h"
#import "CheckInSuccessView.h"

@implementation CoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _successView = [CheckInSuccessView checkInSuccessView];
        [self addSubview:_successView];
    }
    return self;
}

- (void)layoutSubviews
{
        [_successView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * (253.5 / 309.5)));
        }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint successViewPoint = [self convertPoint:point toView:_successView];
    if([_successView pointInside:successViewPoint withEvent:event])
    {
        return nil;
    }
    return  [super hitTest:point withEvent:event];
}

@end
