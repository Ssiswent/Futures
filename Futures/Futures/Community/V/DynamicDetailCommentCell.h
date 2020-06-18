//
//  DynamicDetailCommentCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CommentModel;

@interface DynamicDetailCommentCell : UITableViewCell

@property (strong, nonatomic) CommentModel *commentModel;

@end

NS_ASSUME_NONNULL_END
