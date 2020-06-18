//
//  DynamicDetaiVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "DynamicDetaiVC.h"
#import "DynamicDetailContentCell.h"
#import "DynamicDetailCommentCell.h"

#import "CustomTBC.h"

#import "CommunityDynamicModel.h"
#import "CommentModel.h"

#import "DynamicDetailHeaderView.h"

@interface DynamicDetaiVC ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dynamicDetailTableView;

@end

@implementation DynamicDetaiVC

NSString *DynamicDetailContentCellID = @"DynamicDetailContentCell";
NSString *DynamicDetailCommentCellID = @"DynamicDetailCommentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)initialSetup
{
    self.title = @"动态详情";
    
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
    
    [self.dynamicDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicDetailContentCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailContentCellID];
    [self.dynamicDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailCommentCellID];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        DynamicDetailContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:DynamicDetailContentCellID];
        contentCell.dynamicModel = _dynamicModel;
        return contentCell;
    }
    else
    {
        NSInteger commentNum = indexPath.row % 2;
        DynamicDetailCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:DynamicDetailCommentCellID];
        commentCell.commentModel = _dynamicModel.commentArray[commentNum];
        return commentCell;
    }
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        DynamicDetailHeaderView *detailHeaderView = [DynamicDetailHeaderView dynamicDetailHeaderView];
        return detailHeaderView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0.001;
    }
    else
    {
        return 44;
    }
}

@end
