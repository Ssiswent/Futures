//
//  OCExampleViewController.h
//  JXPagingView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "PagingViewTableHeaderView.h"
#import "ListViewController1.h"
#import "JXCategoryTitleView.h"

#import "MineDynamicHeaderView.h"

static const CGFloat JXTableHeaderViewHeight = 150;
static const CGFloat JXheightForHeaderInSection = 40;

@interface PagingViewController : UIViewController <JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) MineDynamicHeaderView *userHeaderView;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
- (JXPagerView *)preferredPagingView;

@end
