//
//  OCExampleViewController.h
//  JXPagingView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "DynamicListVC.h"
#import <JXCategoryTitleView.h>

#import "MineDynamicHeaderView.h"

static const CGFloat JXTableHeaderViewHeight = 150;
static const CGFloat JXheightForHeaderInSection = 40;

@interface MineDynamicVC : UIViewController <JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) MineDynamicHeaderView *userHeaderView;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
- (JXPagerView *)preferredPagingView;

@end
