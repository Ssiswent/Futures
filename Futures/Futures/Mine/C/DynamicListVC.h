//
//  ListViewController.h
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@class CommunityDynamicModel;

@interface DynamicListVC : UIViewController <JXPagerViewListViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CommunityDynamicModel *> *dataSource;

@end

NS_ASSUME_NONNULL_END
