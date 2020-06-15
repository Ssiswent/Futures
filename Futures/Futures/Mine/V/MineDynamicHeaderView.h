//
//  MineDynamicHeaderView.h
//  Futures
//
//  Created by Ssiswent on 2020/6/11.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineUserModel;

@interface MineDynamicHeaderView : UIView

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;

@property (strong, nonatomic) MineUserModel *mineUser;

@end

NS_ASSUME_NONNULL_END
