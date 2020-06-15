//
//  CommunityTopicCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityTopicCell.h"

#import "CommunityTopicCollectionCell.h"

#import "HomeNewsModel.h"

#import <TYCyclePagerView.h>

@interface CommunityTopicCell()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (weak, nonatomic) IBOutlet TYCyclePagerView *communityTopicPagerView;

@property (assign, nonatomic) CGRect topicPagerViewFrame;

@property (nonatomic, strong) NSArray *newsArray;


@end

@implementation CommunityTopicCell

NSString *CommunityTopicCollectionCellID = @"CommunityTopicCollectionCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGRect topicPagerViewFrame = _communityTopicPagerView.frame;
    _topicPagerViewFrame = topicPagerViewFrame;
    
    [self addPagerView];
    [self getTopics];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _communityTopicPagerView.frame =  CGRectMake(5, _topicPagerViewFrame.origin.y, CGRectGetWidth(_topicPagerViewFrame), CGRectGetHeight(_topicPagerViewFrame));
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.isInfiniteLoop = NO;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [pagerView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityTopicCollectionCell class])bundle:nil] forCellWithReuseIdentifier:CommunityTopicCollectionCellID];
    [self addSubview:pagerView];
    _communityTopicPagerView = pagerView;
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.newsArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    CommunityTopicCollectionCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:CommunityTopicCollectionCellID forIndex:index];
    cell.topicModel = self.newsArray[index];
    switch (index % 2) {
        case 0:
            cell.bgImgView.image = [UIImage imageNamed:@"bg1"];
            [cell.focusBtn setTitleColor:[UIColor colorWithHexString:@"#FF4747"] forState:UIControlStateNormal];
            break;
        default:
            cell.bgImgView.image = [UIImage imageNamed:@"bg2"];
            [cell.focusBtn setTitleColor:[UIColor colorWithHexString:@"#293AFF"] forState:UIControlStateNormal];
            break;
    }
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(183, 140.5);
    layout.itemSpacing = 0;
    layout.layoutType = normal;
//    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

#pragma mark - API

- (void)getTopics{
    WEAKSELF
    NSDate *todayDate = [NSDate date];
    NSDictionary *dic = @{@"date":todayDate};
    [ENDNetWorkManager getWithPathUrl:@"/admin/getFinanceAffairs" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.newsArray = [MTLJSONAdapter modelsOfClass:[HomeNewsModel class] fromJSONArray:result[@"data"] error:&error];
        [weakSelf.communityTopicPagerView reloadData];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf Message:@"请求话题失败" afterHideTime:DELAYTiME];
    }];
}


@end
