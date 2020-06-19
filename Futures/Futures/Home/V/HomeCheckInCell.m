//
//  HomeCheckInCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeCheckInCell.h"

@implementation HomeCheckInCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)checkInBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(homeCheckInCellDidClickCheckInBtn:)])
    {
        [self.delegate homeCheckInCellDidClickCheckInBtn:self];
    }
}


@end
