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
#import "CommentModel.h"
#import "CommunityDynamicListModel.h"

#import "DynamicDetailVC.h"
#import "PublishVC.h"

#import <MJRefresh.h>

@interface CommunityPopularVC ()<UITableViewDataSource, UITableViewDelegate, CommunityFocusCellDelegate, DynamicDetailVCDelegate>

@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet UITableView *popularTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong , nonatomic) NSMutableArray *dynamicsArray;
@property (strong , nonatomic) NSArray *allCommentsArray;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CommunityDynamicListModel *listModel;

@property (assign, nonatomic) NSInteger pageNumber;
@property (nonatomic, assign) BOOL loadMore;

@property (assign, nonatomic) NSInteger numberOfSections;

@property (strong, nonatomic) NSNumber *shieldId;
@property (strong, nonatomic) NSNumber *userId;

@end

@implementation CommunityPopularVC

- (NSMutableArray *)dynamicsArray
{
    if(_dynamicsArray == nil)
    {
        NSMutableArray *temp = NSMutableArray.new;
        _dynamicsArray = temp;
    }
    return _dynamicsArray;
}

NSString *CommunityHeaderCellID = @"CommunityHeaderCell";
NSString *CommunityTopicCellID = @"CommunityTopicCell";
NSString *CommunityFocusCellID = @"CommunityFocusCell";
NSString *CommunityDynamicCellID = @"CommunityDynamicCell";

- (void)viewDidLoad {
    [self getUserDefault];
    [self registerTableView];
    [self getDynamics];
    [self getComments];
    [self initialSetup];
    
    [self setMJRefresh];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
}

- (void)setMJRefresh
{
    //下拉刷新
    _popularTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            WEAKSELF
            weakSelf.loadMore = NO;
            weakSelf.pageNumber = 1;
    //        [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf getDynamics];
        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _popularTableView.mj_header.automaticallyChangeAlpha = NO;
        
        // 上拉加载
        _popularTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            WEAKSELF
            weakSelf.loadMore = YES;
            weakSelf.pageNumber ++;
    //        [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf getDynamics];
        }];
        
        [_popularTableView.mj_header beginRefreshing];
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

- (IBAction)publishBtnClicked:(id)sender {
   PublishVC *publishVC = [PublishVC new];
    YPNavigationController *navC = [[YPNavigationController alloc]initWithRootViewController:publishVC];
    //    PublishVC.delegate = self;
    navC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navC animated:YES completion:nil];
}


#pragma mark - CommunityFocusCellDelegate

- (void)communityFocusCellDidClickRemoveBtn:(CommunityFocusCell *)communityFocusCell
{
    _numberOfSections = 3;
    [self.popularTableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - DynamicDetailVCDelegate

- (void)DynamicDetailVCDidClickShieldBtn:(DynamicDetailVC *)dynamicDetailVC shieldNum:(NSInteger)shieldNum
{
    CommunityDynamicModel *blockDynamicModel = self.dynamicsArray[shieldNum];
    _shieldId = blockDynamicModel.talkId;
    if(_userId != nil)
    {
        [self blockDynamic];
    }
    [self.dynamicsArray removeObjectAtIndex:shieldNum];
    if(_numberOfSections == 4)
    {
        [self.popularTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:shieldNum inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self.popularTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:shieldNum inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
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
        showY = 555;
    }
    //8 Plus
    else if (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736)
    {
        showY = 537;
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
    if(_numberOfSections == 4)
    {
        if(indexPath.section == 3)
        {
            NSInteger count = self.allCommentsArray.count;
            if(count % 2 != 0)
            {
                count --;
            }
            NSInteger commentsNum1 = indexPath.row % (count / 2) * 2;
            NSInteger commentsNum2 = commentsNum1 + 1;
            NSMutableArray *temp = NSMutableArray.new;
            [temp addObject: self.allCommentsArray[commentsNum1]];
            [temp addObject: self.allCommentsArray[commentsNum2]];
            
            CommunityDynamicModel *dynamicModel = self.dynamicsArray[indexPath.row];
            dynamicModel.commentArray = temp;
            
            DynamicDetailVC *dynamicDetailVC = DynamicDetailVC.new;
            dynamicDetailVC.dynamicModel = dynamicModel;
            dynamicDetailVC.delegate = self;
            dynamicDetailVC.cellNum = indexPath.row;
            [self.navigationController pushViewController:dynamicDetailVC animated:YES];
        }
    }
    else
    {
        if(indexPath.section == 2)
        {
            NSInteger count = self.allCommentsArray.count;
            if(count % 2 != 0)
            {
                count --;
            }
            NSInteger commentsNum1 = indexPath.row % (count / 2) * 2;
            NSInteger commentsNum2 = commentsNum1 + 1;
            NSMutableArray *temp = NSMutableArray.new;
            [temp addObject: self.allCommentsArray[commentsNum1]];
            [temp addObject: self.allCommentsArray[commentsNum2]];
            
            CommunityDynamicModel *dynamicModel = self.dynamicsArray[indexPath.row];
            dynamicModel.commentArray = temp;
            
            DynamicDetailVC *dynamicDetailVC = DynamicDetailVC.new;
            dynamicDetailVC.dynamicModel = dynamicModel;
            dynamicDetailVC.cellNum = indexPath.row;
            dynamicDetailVC.delegate = self;
            [self.navigationController pushViewController:dynamicDetailVC animated:YES];
        }
    }
    
}

#pragma mark - API

-(void)getDynamics{
    WEAKSELF
    NSDictionary *dic = @{@"pageNumber":@(_pageNumber)};
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getRecommandTalk" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.listModel = [MTLJSONAdapter modelOfClass:[CommunityDynamicListModel class] fromJSONDictionary:result[@"data"] error:&error];
        if (!weakSelf.loadMore) {
            [weakSelf.dynamicsArray removeAllObjects];
        }
        [weakSelf.dynamicsArray addObjectsFromArray:weakSelf.listModel.dynamicsArray];
        [weakSelf.popularTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (!weakSelf.loadMore) {
            [weakSelf.popularTableView.mj_header endRefreshing];
        }
        else
        {
            if (weakSelf.listModel.hasMore)
            {
                [weakSelf.popularTableView.mj_footer endRefreshing];
            }
            else
            {
                [weakSelf.popularTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        if (weakSelf.loadMore) {
            if (weakSelf.pageNumber >2) {
                weakSelf.pageNumber --;
            }
        }
        [weakSelf.popularTableView.mj_header endRefreshing];
        [weakSelf.popularTableView.mj_footer endRefreshing];
        [Toast makeText:weakSelf.view Message:@"请求热门说说失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getComments{
    WEAKSELF
    NSDictionary *dic = @{@"userId":@4161};
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getDiscussByUserId" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.allCommentsArray = [MTLJSONAdapter modelsOfClass:[CommentModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求评论失败" afterHideTime:DELAYTiME];
    }];
}

- (void)blockDynamic{
    WEAKSELF
    NSDictionary *dic = @{
        @"userId":_userId,
        @"data":_shieldId,
        @"type":@2
    };
    [ENDNetWorkManager postWithPathUrl:@"/user/personal/block" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"屏蔽失败" afterHideTime:DELAYTiME];
    }];
}

@end
