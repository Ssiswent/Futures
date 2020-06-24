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
#import "LoginVC.h"

#import "MineUserModel.h"
#import "UserModel.h"

@interface DynamicDetailVC ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, FeedbackVCDelegate, LoginVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dynamicDetailTableView;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UITextView *replyTextView;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyViewBottom;

@property (nonatomic, strong)NSNumber *userId;

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
    
    [self getUserDefault];
}

- (void)getUserDefault
{
    //获取用户偏好
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //读取userId
    NSNumber *userId = [userDefault objectForKey:@"userId"];
    _userId = userId;
    
    if(_userId != nil)
    {
        [self getUser];
    }
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
    
    if(_rightBarBtnShow)
    {
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:reportButton, shieldButton, nil]];
        
    }
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.dynamicDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicDetailContentCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailContentCellID];
    [self.dynamicDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:DynamicDetailCommentCellID];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, SCREEN_WIDTH, 128) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20,20)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _replyView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    _replyView.layer.mask = maskLayer;
    
    _replyTextView.layer.cornerRadius = 10;
    _replyView.layer.masksToBounds = YES;
    
    _replyBtn.layer.cornerRadius = 10;
    _replyBtn.layer.masksToBounds = YES;
    
    [self addClickViewGes];
}

- (void)shieldBtnClick{
    if(_userId != nil)
    {
        if([self.delegate respondsToSelector:@selector(DynamicDetailVCDidClickShieldBtn:shieldNum:)])
        {
            [self.delegate DynamicDetailVCDidClickShieldBtn:self shieldNum:_cellNum];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        loginVC.delegate = self;
        //    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
}

- (void)reportBtnClick{
    if(_userId != nil)
    {
        FeedbackVC *feedbackVC = [[FeedbackVC alloc]init];
        feedbackVC.delegate = self;
        feedbackVC.titleStr = @"举报";
        feedbackVC.tag1Str = @"涉黄";
        feedbackVC.tag2Str = @"垃圾内容";
        feedbackVC.talkId = _dynamicModel.talkId;
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
    else
    {
        LoginVC *loginVC = [LoginVC new];
        loginVC.delegate = self;
        //    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
        [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
    }
    
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)replyBtnClicked:(id)sender {
    CommentModel *commentModel = CommentModel.new;
    commentModel.content = _replyTextView.text;
    NSDate *todayDate = [NSDate date];
    NSTimeInterval publishTime = [todayDate timeIntervalSince1970];
    commentModel.publishTime = publishTime * 1000;
    MineUserModel *user = [MineUserModel sharedMineUserModel];
    commentModel.user = user;
    NSMutableArray *commentsArray = NSMutableArray.new;
    for (CommentModel *model in _dynamicModel.commentArray) {
        [commentsArray addObject:model];
    }
    [commentsArray addObject:commentModel];
    _dynamicModel.commentArray = commentsArray;
    [self.dynamicDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    _replyViewBottom.constant = - 108;
    [_replyTextView resignFirstResponder];
    [self postComment];
}

- (void)addClickViewGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClicked)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewClicked
{
    [_replyTextView resignFirstResponder];
    _replyViewBottom.constant = - 108;
}

#pragma mark - FeedbackVCDelegate
- (void)FeedbackVCDidSuccessFeedback:(FeedbackVC *)feedbackVC
{
    [Toast makeText:self.view Message:@"举报成功" afterHideTime:DELAYTiME];
}

#pragma mark - LoginVCDelegate

- (void)LoginVCDidGetUser:(LoginVC *)loginVC
{
    [self getUserDefault];
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
        return _dynamicModel.commentArray.count;
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
        if(indexPath.row <= 1)
        {
            commentCell.commentModel = _dynamicModel.commentArray[commentNum];
        }
        else
        {
            commentCell.commentModel = _dynamicModel.commentArray[indexPath.row];
        }
        return commentCell;
    }
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        DynamicDetailHeaderView *detailHeaderView = [DynamicDetailHeaderView dynamicDetailHeaderView];
        WEAKSELF
        detailHeaderView.block = ^{
            if(weakSelf.userId != nil)
            {
//                CGRect showFrame = weakSelf.replyView.frame;
//                CGFloat showY = 100;
//                showFrame.origin.y = showY;
//                [UIView animateWithDuration:0.5 animations:^{
//                    WEAKSELF
//                    weakSelf.replyView.frame = showFrame;
//                }];
                _replyViewBottom.constant = 0;
            }
            else
            {
                LoginVC *loginVC = [LoginVC new];
                loginVC.delegate = self;
                //    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:loginVC animated:YES completion:nil];
                [Toast makeText:loginVC.view Message:@"请先注册或登录" afterHideTime:DELAYTiME];
            }
        };
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    CGRect showFrame = _replyView.frame;
    CGFloat showY = 468;
    //8(SE2)
    if(SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667)
    {
        showY = 495;
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
    
    CGRect hideFrame = _replyView.frame;
    hideFrame.origin.y = SCREEN_HEIGHT;
    //下滑
    NSLog(@"`````%f",translation.y);
        if (translation.y>0)
        {
//            [UIView animateWithDuration:0.5 animations:^{
//                WEAKSELF
//                weakSelf.replyView.frame = showFrame;
//            }];
//            _replyViewBottom.constant = 0;
        }
    //上滑
    if(translation.y<0)
    {
//        [UIView animateWithDuration:0.5 animations:^{
//            WEAKSELF
//            weakSelf.replyView.frame = hideFrame;
//        }];
//        _replyViewBottom.constant = - 108;
    }
}

// MARK: API

- (void)postComment{
    WEAKSELF
    NSDictionary *dic = @{
        @"userId":_userId,
        @"talkId":_dynamicModel.talkId,
        @"content":_replyTextView.text
    };
    [ENDNetWorkManager postWithPathUrl:@"/user/talk/commentTalk" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        [Toast makeText:weakSelf.view Message:@"评论成功" afterHideTime:DELAYTiME];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"评论失败" afterHideTime:DELAYTiME];
    }];
}

- (void)getUser{
    WEAKSELF
    NSDictionary *dic = @{@"userId":_userId};
    [ENDNetWorkManager postWithPathUrl:@"/user/personal/queryUser" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        MineUserModel *mineUser = [MineUserModel sharedMineUserModel];
        UserModel *user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:result[@"data"] error:&error];
        mineUser.nickName = user.nickName;
        mineUser.head = user.head;
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求用户数据失败" afterHideTime:DELAYTiME];
    }];
}

@end
