//
//  MineInformationView.h
//  futures
//
//  Created by Ssiswent on 2020/5/25.
//  Copyright © 2020 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineInformationSignatureView;

@protocol MineInformationSignatureViewDelegate <NSObject>

@optional

- (void)mineInformationSignatureViewDidClickCancelBtn:(MineInformationSignatureView *)mineInformationSignatureView;
- (void)mineInformationSignatureViewDidClickConfirmBtn:(MineInformationSignatureView *)mineInformationSignatureView changedSignature:(NSString *)changedSignature;

@end

@interface MineInformationSignatureView : UIView

@property (nonatomic, weak)id<MineInformationSignatureViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
