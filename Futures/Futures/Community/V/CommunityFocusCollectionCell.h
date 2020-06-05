//
//  CommunityFocusCollectionCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UserModel;

@interface CommunityFocusCollectionCell : UICollectionViewCell

@property (nonatomic, strong)UserModel *recommendUserModel;

@end

NS_ASSUME_NONNULL_END
