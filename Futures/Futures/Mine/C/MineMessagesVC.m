//
//  HomeMessagesVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineMessagesVC.h"

#import "MineMessageCell.h"
#import "UIImage+OriginalImage.h"

#import "CustomTBC.h"

@interface MineMessagesVC ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;

@end

@implementation MineMessagesVC

NSString *HomeMessageCellID = @"HomeMessageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];

    [self.messagesTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineMessageCell class]) bundle:nil] forCellReuseIdentifier:HomeMessageCellID];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)initialSetUp
{
    self.title = _titleStr;
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeMessageCellID];
    switch (indexPath.row) {
        case 0:
            cell.actionLabel.text = @"@了我";
            break;
        case 1:
            cell.actionLabel.text = @"评论了我";
            break;
        default:
            cell.actionLabel.text = @"转发了我的动态";
            break;
    }
    return cell;
}

@end
