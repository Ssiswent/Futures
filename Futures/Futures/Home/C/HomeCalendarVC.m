//
//  HomeCalendarVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/15.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeCalendarVC.h"

#import "HomeCalendarColletionCell.h"

#import "CustomTBC.h"

@interface HomeCalendarVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HomeCalendarVC

NSString *HomeCalendarColletionCellID = @"HomeCalendarColletionCell";

- (void)viewDidLoad {
    [self setCollectonView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

-(UIView *)listView{
    return self.view;
}

- (void)setCollectonView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    CGFloat itemW = (SCREEN_WIDTH - 20) / 2;
//    CGFloat itemH = itemW * 256 / 180;
    layout.itemSize = CGSizeMake(180, 180);
    layout.sectionInset = UIEdgeInsetsMake(0, 7.5, 0, 7.5);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _calendarCollectionView.collectionViewLayout = layout;
    _calendarCollectionView.backgroundColor = [UIColor whiteColor];
    _calendarCollectionView.delegate = self;
    _calendarCollectionView.dataSource = self;
    [_calendarCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCalendarColletionCell class]) bundle:nil] forCellWithReuseIdentifier:HomeCalendarColletionCellID];
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCalendarColletionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCalendarColletionCellID forIndexPath:indexPath];
    return cell;
}

@end
