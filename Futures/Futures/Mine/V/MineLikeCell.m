//
//  MineLikeCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineLikeCell.h"

@implementation MineLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)likeBtnClicked:(id)sender {
    _likeBtn.selected = !_likeBtn.selected;
}


@end
