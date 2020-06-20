//
//  CommunityFocusVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/4.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "CommunityFocusVC.h"

#import "CommunityDynamicCell.h"

#import "CommunityDynamicModel.h"
#import "CommentModel.h"

#import "DynamicDetaiVC.h"
#import "PublishVC.h"

@interface CommunityFocusVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *focusTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;

@property (strong , nonatomic) NSArray *dynamicsArray;
@property (strong , nonatomic) NSArray *allCommentsArray;

@end

@implementation CommunityFocusVC

NSString *CommunityDynamicCellID1 = @"CommunityDynamicCell1";

- (void)viewDidLoad {
    [self.focusTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommunityDynamicCell class]) bundle:nil] forCellReuseIdentifier:CommunityDynamicCellID1];
    [self getDynamics];
    [self getComments];
    [self initialSetup];
}

-(UIView *)listView{
    return self.view;
}

- (void)initialSetup
{
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,0);
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.shadowRadius = 36;
}

- (IBAction)publishBtnClicked:(id)sender {
    PublishVC *publishVC = [PublishVC new];
    YPNavigationController *navC = [[YPNavigationController alloc]initWithRootViewController:publishVC];
    //    PublishVC.delegate = self;
    navC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navC animated:YES completion:nil];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dynamicsArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommunityDynamicCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:CommunityDynamicCellID1];
    dynamicCell.dynamicModel = self.dynamicsArray[indexPath.row];
    return dynamicCell;
    
}

#pragma mark - TableViewDelegate

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
    
    DynamicDetaiVC *dynamicDetaiVC = DynamicDetaiVC.new;
    dynamicDetaiVC.dynamicModel = dynamicModel;
    [self.navigationController pushViewController:dynamicDetaiVC animated:YES];
    
}

#pragma mark - API

- (void)getDynamics{
    WEAKSELF
    [ENDNetWorkManager getWithPathUrl:@"/user/talk/getRecommandTalk" parameters:nil queryParams:nil Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.dynamicsArray = [MTLJSONAdapter modelsOfClass:[CommunityDynamicModel class] fromJSONArray:result[@"data"][@"list"] error:&error];
        [weakSelf.focusTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求热门动态失败" afterHideTime:DELAYTiME];
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

@end
