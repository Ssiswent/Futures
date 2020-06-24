//
//  DynamicDetailHeaderView.h
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CommentBtnClickedBlock)(void);

@interface DynamicDetailHeaderView : UIView

+ (instancetype)dynamicDetailHeaderView;

@property (nonatomic, copy) CommentBtnClickedBlock block;

@end

NS_ASSUME_NONNULL_END
