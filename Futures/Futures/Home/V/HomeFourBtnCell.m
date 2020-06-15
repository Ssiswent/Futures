//
//  HomeFourBtnCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeFourBtnCell.h"

@interface HomeFourBtnCell()

@property (weak, nonatomic) IBOutlet UIView *quotationView;
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIView *businessView;
@property (weak, nonatomic) IBOutlet UIView *newsView;

@end

@implementation HomeFourBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addClickQuotationViewGes];
    [self addClickCalendarViewGes];
    [self addClickBusinessViewGes];
    [self addClickNewsViewGes];
}

- (void)addClickQuotationViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(quotationViewClicked)];
    [_quotationView addGestureRecognizer:tap];
}

- (void)quotationViewClicked
{
    if([self.delegate respondsToSelector:@selector(HomeFourBtnCellDidClickBtnView:Tag:)])
    {
        [self.delegate HomeFourBtnCellDidClickBtnView:self Tag:0];
    }
}

- (void)addClickCalendarViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(calendarViewClicked)];
    [_calendarView addGestureRecognizer:tap];
}

- (void)calendarViewClicked
{
    if([self.delegate respondsToSelector:@selector(HomeFourBtnCellDidClickBtnView:Tag:)])
    {
        [self.delegate HomeFourBtnCellDidClickBtnView:self Tag:1];
    }
}

- (void)addClickBusinessViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(businessViewClicked)];
    [_businessView addGestureRecognizer:tap];
}

- (void)businessViewClicked
{
    if([self.delegate respondsToSelector:@selector(HomeFourBtnCellDidClickBtnView:Tag:)])
    {
        [self.delegate HomeFourBtnCellDidClickBtnView:self Tag:2];
    }
}

- (void)addClickNewsViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newsViewClicked)];
    [_newsView addGestureRecognizer:tap];
}

- (void)newsViewClicked
{
    if([self.delegate respondsToSelector:@selector(HomeFourBtnCellDidClickBtnView:Tag:)])
    {
        [self.delegate HomeFourBtnCellDidClickBtnView:self Tag:3];
    }
}

@end
