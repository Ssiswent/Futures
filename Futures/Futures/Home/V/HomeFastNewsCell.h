//
//  HomeFastNewsCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeNewsModel;

@interface HomeFastNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (strong, nonatomic) HomeNewsModel *fastNewsModel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

NS_ASSUME_NONNULL_END
