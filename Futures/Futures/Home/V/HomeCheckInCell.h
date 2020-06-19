//
//  HomeCheckInCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeCheckInCell;

@protocol HomeCheckInCellDelegate <NSObject>

@optional

- (void)homeCheckInCellDidClickCheckInBtn:(HomeCheckInCell *)homeCheckInCell;

@end

@interface HomeCheckInCell : UITableViewCell

@property (nonatomic, weak)id<HomeCheckInCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
