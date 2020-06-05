//
//  CommunityTopicCollectionCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeNewsModel;

@interface CommunityTopicCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@property (strong, nonatomic) HomeNewsModel *topicModel;

@end

NS_ASSUME_NONNULL_END
