//
//  CommunityFocusCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/5.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityFocusCell.h"

#import "CommunityFocusCollectionCell.h"

#import "UserModel.h"

#import <TYCyclePagerView.h>

@interface CommunityFocusCell()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (weak, nonatomic) IBOutlet TYCyclePagerView *communityFocusPagerView;

@property (assign, nonatomic) CGRect focusPagerViewFrame;

@property (nonatomic, strong) NSArray *recommendUsersArray;

@end

@implementation CommunityFocusCell

NSString *CommunityFocusCollectionCellID = @"CommunityFocusCollectionCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGRect focusPagerViewFrame = _communityFocusPagerView.frame;
    _focusPagerViewFrame = focusPagerViewFrame;
    
    [self addPagerView];
    [self getRecommendUsers];
}

- (IBAction)removeBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(communityFocusCellDidClickRemoveBtn:)])
    {
        [self.delegate communityFocusCellDidClickRemoveBtn:self];
    }
}

- (IBAction)changeBtnClicked:(id)sender {
    [self getRecommendUsers];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _communityFocusPagerView.frame =  CGRectMake(19.5, _focusPagerViewFrame.origin.y, CGRectGetWidth(_focusPagerViewFrame), CGRectGetHeight(_focusPagerViewFrame));
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.isInfiniteLoop = NO;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [pagerView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityFocusCollectionCell class])bundle:nil] forCellWithReuseIdentifier:CommunityFocusCollectionCellID];
    [self addSubview:pagerView];
    _communityFocusPagerView = pagerView;
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.recommendUsersArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    CommunityFocusCollectionCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:CommunityFocusCollectionCellID forIndex:index];
    cell.recommendUserModel = self.recommendUsersArray[index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(35, 49.5);
    layout.itemSpacing = 25;
    layout.layoutType = normal;
//    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

#pragma mark - API

-(void)getRecommendUsers{
    WEAKSELF
    [ENDNetWorkManager getWithPathUrl:@"/user/follow/getRecommandUserList" parameters:nil queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.recommendUsersArray = [MTLJSONAdapter modelsOfClass:[UserModel class] fromJSONArray:result[@"data"] error:&error];
        [weakSelf.communityFocusPagerView reloadData];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf Message:@"请求推荐关注失败" afterHideTime:DELAYTiME];
    }];
}

@end
