//
//  MineLikeChildAVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineLikeChildAVC.h"
#import "MineLikeCell.h"
#import "CustomTBC.h"

@interface MineLikeChildAVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *likeTableView;

@end

@implementation MineLikeChildAVC

NSString *MineLikeCellID = @"MineLikeCell";

- (void)viewDidLoad {
    [self.likeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineLikeCell class]) bundle:nil] forCellReuseIdentifier:MineLikeCellID];
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
    MineLikeCell *likeCell = [tableView dequeueReusableCellWithIdentifier:MineLikeCellID];
    likeCell.actionLabel.text = @"赞了我";
    return likeCell;
}

@end
