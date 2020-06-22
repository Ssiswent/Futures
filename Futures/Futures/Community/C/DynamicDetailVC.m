//
//  DynamicDetailVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/17.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "DynamicDetailVC.h"
#import "DynamicDetailContentCell.h"
#import "DynamicDetailCommentCell.h"

#import "CustomTBC.h"

#import "CommunityDynamicModel.h"
#import "CommentModel.h"

#import "DynamicDetailHeaderView.h"

#import "FeedbackVC.h"

@interface DynamicDetailVC ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, FeedbackVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dynamicDetailTableView;

@end

@implementation DynamicDetailVC

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
    
    UIBarButtonItem *shieldButton = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_shield"] style:UIBarButtonItemStylePlain target:self action:@selector(shieldBtnClick)];
    
    UIBarButtonItem *reportButton = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_report"] style:UIBarButtonItemStylePlain target:self action:@selector(reportBtnClick)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:reportButton, shieldButton, nil]];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.dynamicDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicDetailContentCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailContentCellID];
    [self.dynamicDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailCommentCellID];
}

- (void)shieldBtnClick{
    if([self.delegate respondsToSelector:@selector(DynamicDetailVCDidClickShieldBtn:shieldNum:)])
    {
        [self.delegate DynamicDetailVCDidClickShieldBtn:self shieldNum:_cellNum];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reportBtnClick{
    FeedbackVC *feedbackVC = [[FeedbackVC alloc]init];
    feedbackVC.delegate = self;
    feedbackVC.titleStr = @"举报";
    feedbackVC.tag1Str = @"涉黄";
    feedbackVC.tag2Str = @"垃圾内容";
    feedbackVC.talkId = _dynamicModel.talkId;
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FeedbackVCDelegate
- (void)FeedbackVCDidSuccessFeedback:(FeedbackVC *)feedbackVC
{
    [Toast makeText:self.view Message:@"举报成功" afterHideTime:DELAYTiME];
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
