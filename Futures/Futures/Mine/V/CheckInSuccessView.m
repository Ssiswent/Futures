//
//  CheckInSuccessView.m
//  Futures
//
//  Created by Ssiswent on 2020/6/19.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CheckInSuccessView.h"

@implementation CheckInSuccessView

+ (instancetype)checkInSuccessView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CheckInSuccessView class]) owner:nil options:nil] firstObject];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGPoint successViewPoint = [self convertPoint:point toView:self];
//    if([self pointInside:successViewPoint withEvent:event])
//    {
//        return nil;
//    }
//    return  [super hitTest:point withEvent:event];
//}

@end
