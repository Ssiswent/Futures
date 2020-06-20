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
//    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
//    
//    CGPoint successViewPoint = [self convertPoint:point toView:self];
//    if([self pointInside:successViewPoint withEvent:event])
//    {
//        return view;
//    }
//    return [super hitTest:point withEvent:event];
//}
//
//- (void)dealloc
//{
//    NSLog(@"销毁了");
//}

@end
