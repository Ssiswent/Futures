//
//  CommunityPopularVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityPopularVC.h"

#import "CommunityHeaderCell.h"
#import "CommunityTopicCell.h"
#import "CommunityFocusCell.h"
#import "CommunityDynamicCell.h"

#import "CommunityDynamicHeaderView.h"

#import "CommunityDynamicModel.h"

#import "DynamicDetaiVC.h"

@interface CommunityPopularVC ()<UITableViewDataSource, UITableViewDelegate, CommunityFocusCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet UITableView *popularTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong , nonatomic) NSArray *dynamicsArray;

@property (assign, nonatomic) NSInteger numberOfSections;

@end

@implementation CommunityPopularVC

NSString *CommunityHeaderCellID = @"CommunityHeaderCell";
NSString *CommunityTopicCellID = @"CommunityTopicCell";
NSString *CommunityFocusCellID = @"CommunityFocusCell";
NSString *CommunityDynamicCellID = @"CommunityDynamicCell";

- (void)viewDidLoad {
    [self registerTableView];
    [self getDynamics];
    [self initialSetup];
}

-(UIView *)listView{
    return self.view;
}

- (void)registerTableView
{
    [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityHeaderCell class]) bundle:nil] forCellReuseIdentifier:CommunityHeaderCellID];
    [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityTopicCell class]) bundle:nil] forCellReuseIdentifier:CommunityTopicCellID];
     [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityFocusCell class]) bundle:nil] forCellReuseIdentifier:CommunityFocusCellID];
    [self.popularTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityDynamicCell class]) bundle:nil] forCellReuseIdentifier:CommunityDynamicCellID];
}

- (void)initialSetup
{
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,0);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 36;
    
    _numberOfSections = 4;
}

- (void)communityFocusCellDidClickRemoveBtn:(CommunityFocusCell *)communityFocusCell
{
    _numberOfSections = 3;
    [self.popularTableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_numberOfSections == 4)
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
                return self.dynamicsArray.count;
                break;
        }
    }
    else
    {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 1;
                break;
            default:
                return self.dynamicsArray.count;
                break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:CommunityHeaderCellID];
    CommunityTopicCell *topicCell = [tableView dequeueReusableCellWithIdentifier:CommunityTopicCellID];
    CommunityFocusCell *focusCell = [tableView dequeueReusableCellWithIdentifier:CommunityFocusCellID];
    CommunityDynamicCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:CommunityDynamicCellID];
    
    focusCell.delegate = self;
    
    if(_numberOfSections == 4)
    {
        switch (indexPath.section) {
            case 0:
                return headerCell;
                break;
            case 1:
                return topicCell;
                break;
            case 2:
                return focusCell;
                break;
            default:
                dynamicCell.dynamicModel = self.dynamicsArray[indexPath.row];
                return dynamicCell;
                break;
        }
    }
    else
    {
        switch (indexPath.section) {
            case 0:
                return headerCell;
                break;
            case 1:
                return topicCell;
                break;
            default:
                dynamicCell.dynamicModel = self.dynamicsArray[indexPath.row];
                return dynamicCell;
                break;
        }
    }
    
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_numberOfSections == 4)
    {
        if(section == 3)
        {
            CommunityDynamicHeaderView *dynamicHeaderView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CommunityDynamicHeaderView class]) owner:nil options:nil].firstObject;
            return dynamicHeaderView;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if(section == 2)
        {
            CommunityDynamicHeaderView *dynamicHeaderView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CommunityDynamicHeaderView class]) owner:nil options:nil].firstObject;
            return dynamicHeaderView;
        }
        else
        {
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_numberOfSections == 4)
    {
        if(section == 3)
        {
            return 36;
        }
        else
        {
            return 0.001;
        }
    }
    else
    {
        if(section == 2)
        {
            return 36;
        }
        else
        {
            return 0.001;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    CGRect showFrame = _publishBtn.frame;
    CGFloat showY = 468;
    //8(SE2)
    if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667)
    {
        showY = 468;
    }
    //11 Pro
    else if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812)
    {
        
    }
    //8 Plus
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736)
    {
        
    }
    //11 Pro Max
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 896)
    {
        showY = 639;
    }
    showFrame.origin.y = showY;
    
    CGRect hideFrame = _publishBtn.frame;
    hideFrame.origin.y = SCREEN_HEIGHT;
    //下滑
    if (translation.y>0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            WEAKSELF
            weakSelf.publishBtn.frame = showFrame;
        }];
    }
    //上滑
    else if(translation.y<0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            WEAKSELF
            weakSelf.publishBtn.frame = hideFrame;
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3)
    {
        DynamicDetaiVC *dynamicDetaiVC = DynamicDetaiVC.new;
        dynamicDetaiVC.dynamicModel = self.dynamicsArray[indexPath.row];
        [self.navigationController pushViewController:dynamicDetaiVC animated:YES];
    }
}

#pragma mark - API

- (void)getDynamics{
    WEAKSELF
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getRecommandTalk" parameters:nil queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.dynamicsArray = [MTLJSONAdapter modelsOfClass:[CommunityDynamicModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.popularTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求热门动态失败" afterHideTime:DELAYTiME];
    }];
}

@end
