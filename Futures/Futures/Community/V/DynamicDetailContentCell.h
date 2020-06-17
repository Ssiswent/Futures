//
//  DynamicDetailContentCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CommunityDynamicModel;

@interface DynamicDetailContentCell : UITableViewCell

@property (strong, nonatomic) CommunityDynamicModel *dynamicModel;

@end

NS_ASSUME_NONNULL_END
