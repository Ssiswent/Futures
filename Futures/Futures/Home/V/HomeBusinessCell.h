//
//  HomeBusinessCell.h
//  Futures
//
//  Created by Ssiswent on 2020/6/16.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeNewsModel;

@interface HomeBusinessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *businessImgView;

@property (strong, nonatomic) HomeNewsModel *businessModel;

@end

NS_ASSUME_NONNULL_END
