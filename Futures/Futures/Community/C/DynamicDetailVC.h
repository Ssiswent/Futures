//
//  DynamicDetailVC.h
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CommunityDynamicModel,DynamicDetailVC;

@protocol DynamicDetailVCDelegate <NSObject>

@optional

- (void)DynamicDetailVCDidClickShieldBtn:(DynamicDetailVC *)dynamicDetailVC shieldNum:(NSInteger)shieldNum;

@end

@interface DynamicDetailVC : UIViewController

@property (strong, nonatomic) CommunityDynamicModel *dynamicModel;

@property (assign, nonatomic) NSInteger cellNum;

@property (nonatomic, weak)id<DynamicDetailVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
