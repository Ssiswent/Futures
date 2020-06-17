//
//  MineLikeChildBVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineLikeChildBVC.h"
#import "MineLikeCell.h"
#import "CustomTBC.h"

@interface MineLikeChildBVC ()
@property (weak, nonatomic) IBOutlet UITableView *likeTableView;

@end

@implementation MineLikeChildBVC

NSString *MineLikeCellID1 = @"MineLikeCell1";

- (void)viewDidLoad {
    [self.likeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineLikeCell class]) bundle:nil] forCellReuseIdentifier:MineLikeCellID1];
//    self.likeTableView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

-(UIView *)listView{
    return self.view;
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineLikeCell *likeCell = [tableView dequeueReusableCellWithIdentifier:MineLikeCellID1];
    likeCell.actionLabel.text = @"赞了TA";
    likeCell.likeBtn.selected = YES;
    return likeCell;
}

@end
