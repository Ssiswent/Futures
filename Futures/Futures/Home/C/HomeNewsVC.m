//
//  HomeNewsVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/15.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeNewsVC.h"

#import "CustomTBC.h"

#import "UIImage+Image.h"

#import "HomeNewsBannerCell.h"
#import "HomeNewsTimeCell.h"
#import "HomeFastNewsCell.h"

#import "HomeNewsModel.h"

@interface HomeNewsVC ()
@property (weak, nonatomic) IBOutlet UIButton *tag1Btn;
@property (weak, nonatomic) IBOutlet UIButton *tag2Btn;
@property (weak, nonatomic) IBOutlet UIButton *tag3Btn;
@property (weak, nonatomic) IBOutlet UIButton *tag4Btn;
@property (weak, nonatomic) IBOutlet UIButton *tag5Btn;

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@property (strong , nonatomic) NSArray *fastNewsArray;

@end

@implementation HomeNewsVC

NSString *HomeNewsBannerCellID = @"HomeNewsBannerCell";
NSString *HomeNewsTimeCellID = @"HomeNewsTimeCell";
NSString *HomeFastNewsCellID = @"HomeFastNewsCell";

- (void)viewDidLoad {
    [self initialSetUp];
    [self getTopics];
}

- (void)initialSetUp
{
    [self setTagBtn:_tag1Btn];
    [self setTagBtn:_tag2Btn];
    [self setTagBtn:_tag3Btn];
    [self setTagBtn:_tag4Btn];
    [self setTagBtn:_tag5Btn];
    
    [self.newsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeNewsBannerCell class]) bundle:nil] forCellReuseIdentifier:HomeNewsBannerCellID];
    [self.newsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeNewsTimeCell class]) bundle:nil] forCellReuseIdentifier:HomeNewsTimeCellID];
    [self.newsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeFastNewsCell class]) bundle:nil] forCellReuseIdentifier:HomeFastNewsCellID];
}

- (void)setTagBtn:(UIButton *)tagBtn
{
    UIColor *btnBgNormalColor = [UIColor colorWithHexString:@"#E1E2F9"];
    UIImage *btnBgNormalImg = [UIImage imageWithColor:btnBgNormalColor];
    UIColor *btnBgSelectedColor = [UIColor colorWithHexString:@"#2A3AFF"];
    UIImage *btnBgSelectedImg = [UIImage imageWithColor:btnBgSelectedColor];
    [tagBtn setBackgroundImage:btnBgNormalImg forState:UIControlStateNormal];
    [tagBtn setBackgroundImage:btnBgSelectedImg forState:UIControlStateSelected];
    tagBtn.layer.cornerRadius = 4;
    tagBtn.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

-(UIView *)listView{
    return self.view;
}

- (IBAction)tagBtnClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            _tag1Btn.selected = YES;
            _tag2Btn.selected = NO;
            _tag3Btn.selected = NO;
            _tag4Btn.selected = NO;
            _tag5Btn.selected = NO;
            break;
        case 2:
            _tag1Btn.selected = NO;
            _tag2Btn.selected = YES;
            _tag3Btn.selected = NO;
            _tag4Btn.selected = NO;
            _tag5Btn.selected = NO;
            break;
        case 3:
            _tag1Btn.selected = NO;
            _tag2Btn.selected = NO;
            _tag3Btn.selected = YES;
            _tag4Btn.selected = NO;
            _tag5Btn.selected = NO;
            break;
        case 4:
            _tag1Btn.selected = NO;
            _tag2Btn.selected = NO;
            _tag3Btn.selected = NO;
            _tag4Btn.selected = YES;
            _tag5Btn.selected = NO;
            break;
        default:
            _tag1Btn.selected = NO;
            _tag2Btn.selected = NO;
            _tag3Btn.selected = NO;
            _tag4Btn.selected = NO;
            _tag5Btn.selected = YES;
            break;
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 1;
    }
    else
    {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        HomeNewsBannerCell *newsBannerCell = [tableView dequeueReusableCellWithIdentifier:HomeNewsBannerCellID];
        return newsBannerCell;
    }
    else if(indexPath.section == 1)
    {
        HomeNewsTimeCell *newsTimeCell = [tableView dequeueReusableCellWithIdentifier:HomeNewsTimeCellID];
        return newsTimeCell;
    }
    else
    {
        HomeFastNewsCell *fastNewsCell = [tableView dequeueReusableCellWithIdentifier:HomeFastNewsCellID];
        fastNewsCell.fastNewsModel = self.fastNewsArray[indexPath.row];
        if(indexPath.row == 0)
        {
            fastNewsCell.topLineView.hidden = YES;
        }
        switch (indexPath.row % 4) {
            case 0:
                fastNewsCell.tagLabel.text = @"股市";
                break;
            case 1:
                fastNewsCell.tagLabel.text = @"观点";
                break;
            case 2:
                fastNewsCell.tagLabel.text = @"国际";
                break;
            default:
                fastNewsCell.tagLabel.text = @"宏观";
                break;
        }
        return fastNewsCell;
    }
}

#pragma mark - API

- (void)getTopics{
    WEAKSELF
    NSDate *todayDate = [NSDate date];
    NSDictionary *dic = @{@"date":todayDate};
    [ENDNetWorkManager getWithPathUrl:@"/admin/getFinanceAffairs" parameters:nil queryParams:dic Header:nil success:^(BOOL success, id result) {
        NSError *error;
        weakSelf.fastNewsArray = [MTLJSONAdapter modelsOfClass:[HomeNewsModel class] fromJSONArray:result[@"data"] error:&error];
        [weakSelf.newsTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"请求新闻失败" afterHideTime:DELAYTiME];
    }];
}

@end
