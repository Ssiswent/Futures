//
//  CommunityPopularVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityPopularVC.h"

#import "CommunityHeaderCell.h"

@interface CommunityPopularVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *popularTableView;

@end

@implementation CommunityPopularVC

NSString *CommunityHeaderCellID = @"CommunityHeaderCell";

- (void)viewDidLoad {
    [self registTableView];
}

-(UIView *)listView{
    return self.view;
}

- (void)registTableView
{
    [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityHeaderCell class]) bundle:nil] forCellReuseIdentifier:CommunityHeaderCellID];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 3;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:CommunityHeaderCellID];
    
    switch (indexPath.section) {
        case 0:
            return headerCell;
            break;
        case 1:
            return headerCell;
            break;
        case 2:
            return headerCell;
            break;
        default:
            return headerCell;
            break;
    }
}

@end
