//
//  HomeNewsCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeNewsModel;

@interface HomeNewsCell : UITableViewCell

@property (strong, nonatomic) HomeNewsModel *newsModel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImgView;

@end

NS_ASSUME_NONNULL_END
