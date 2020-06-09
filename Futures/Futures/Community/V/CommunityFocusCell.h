//
//  CommunityFocusCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CommunityFocusCell;

@protocol CommunityFocusCellDelegate <NSObject>

@optional

- (void)communityFocusCellDidClickRemoveBtn:(CommunityFocusCell *)communityFocusCell;

@end

@interface CommunityFocusCell : UITableViewCell

@property (nonatomic, weak)id<CommunityFocusCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
