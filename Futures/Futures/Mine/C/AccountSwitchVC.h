//
//  AccountSwitchVC.h
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AccountSwitchVC;

@protocol AccountSwitchVCDelegate <NSObject>

@optional

- (void)accountSwitchVCDidGetUser:(AccountSwitchVC *)accountSwitchVC;

@end

@interface AccountSwitchVC : UIViewController

@property (nonatomic, weak)id<AccountSwitchVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
