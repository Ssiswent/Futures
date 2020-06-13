//
//  LoginVC.h
//  Futures
//
//  Created by Ssiswent on 2020/6/9.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LoginVC;

@protocol LoginVCDelegate <NSObject>

@optional

- (void)LoginVCDidGetUser:(LoginVC *)loginVC;

@end

@interface LoginVC : UIViewController

@property (nonatomic, weak)id<LoginVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
