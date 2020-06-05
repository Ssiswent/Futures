//
//  CommunityDynamicModel.h
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UserModel;

@interface CommunityDynamicModel : BaseModel

@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *picture;
@property (nonatomic, assign)double publishTime;
@property (nonatomic, assign)NSInteger zanCount;
@property (nonatomic, assign)NSInteger commentCount;
@property (nonatomic, strong)UserModel *user;

@property (nonatomic, assign, getter=isDynamicLiked)BOOL dynamicLiked;

@end

NS_ASSUME_NONNULL_END
