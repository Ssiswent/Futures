//
//  HomeFourBtnCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeFourBtnCell;

@protocol HomeFourBtnCellDelegate <NSObject>

@optional

- (void)HomeFourBtnCellDidClickBtnView:(HomeFourBtnCell *)homeFourBtnCell Tag:(NSInteger)tag;

@end

@interface HomeFourBtnCell : UITableViewCell

@property (nonatomic, weak)id<HomeFourBtnCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
