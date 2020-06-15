//
//  HomeBannerCell.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeBannerCell.h"

#import "HomeBannerCollectionCell.h"

#import <TYCyclePagerView.h>
#import <TYPageControl.h>

@interface HomeBannerCell()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (weak, nonatomic) IBOutlet TYCyclePagerView *homePagerView;
@property (nonatomic, strong) TYPageControl *pageControl;

@property (nonatomic, strong) NSArray *bannerImgsArray;


@end

@implementation HomeBannerCell

- (NSArray *)bannerImgsArray
{
    if(_bannerImgsArray == nil)
    {
        NSArray *temp = [NSArray arrayWithObjects:@"banner1", @"banner2", @"banner3", nil];
        _bannerImgsArray = temp;
    }
    return _bannerImgsArray;
}

NSString *HomeBannerCollectionCellID = @"HomeBannerCollectionCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addPagerView];
    [self addPageControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _homePagerView.frame =  CGRectMake(0, 21, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 21);
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_homePagerView.frame) - 10.5, CGRectGetWidth(_homePagerView.frame), 5);
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.isInfiniteLoop = NO;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [pagerView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeBannerCollectionCell class])bundle:nil] forCellWithReuseIdentifier:HomeBannerCollectionCellID];
    [self addSubview:pagerView];
    _homePagerView = pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.currentPageIndicatorSize = CGSizeMake(15, 5);
    pageControl.pageIndicatorSize = CGSizeMake(15, 5);
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#AFAEB0"];
    [_homePagerView addSubview:pageControl];
    _pageControl = pageControl;
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    _pageControl.numberOfPages = self.bannerImgsArray.count;
    return self.bannerImgsArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    HomeBannerCollectionCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:HomeBannerCollectionCellID forIndex:index];
    cell.bannerImgView.image = [UIImage imageNamed:self.bannerImgsArray[index]];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(345, 140);
    layout.itemSpacing = 30;
    layout.layoutType = normal;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

@end
