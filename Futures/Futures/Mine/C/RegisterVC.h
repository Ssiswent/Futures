//
//  RegisterVC.h
//  Futures
//
//  Created by Ssiswent on 2020/6/10.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RegisterVC;

@protocol RegisterVCDelegate <NSObject>

@optional

- (void)RegisterVCDidGetUser:(RegisterVC *)registerVC;

@end

@interface RegisterVC : UIViewController

@property (nonatomic, weak)id<RegisterVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
