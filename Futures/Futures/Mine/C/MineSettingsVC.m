//
//  MineSettingsVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/9.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "MineSettingsVC.h"

#import "LoginVC.h"

#import "MineSettingsCell.h"

#import "CustomTBC.h"

@interface MineSettingsVC ()<UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end

@implementation MineSettingsVC

NSString *MineSettingsCellID = @"MineSettingsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    [self.settingsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineSettingsCell class]) bundle:nil] forCellReuseIdentifier:MineSettingsCellID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)initialSetup
{
    self.title = @"设置";
    
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

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineSettingsCell *settingsCell = [tableView dequeueReusableCellWithIdentifier:MineSettingsCellID];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    settingsCell.leftTitle.text = @"切换账号";
                    return settingsCell;
                    break;
                case 1:
                    settingsCell.leftTitle.text = @"编辑资料";
                    return settingsCell;
                    break;
                default:
                    settingsCell.leftTitle.text = @"反馈中心";
                    return settingsCell;
                    break;
            }
        case 1:
            switch (indexPath.row) {
                case 0:
                    settingsCell.leftTitle.text = @"关于我们";
                    return settingsCell;
                    break;
                default:
                    settingsCell.leftTitle.text = @"退出登录";
                    return settingsCell;
                    break;
            }
        default:
            settingsCell.leftTitle.text = @"清除所有数据";
            settingsCell.leftTitle.textColor = [UIColor colorWithHexString:@"#FF4747"];
            return settingsCell;
            break;
    }
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1)
    {
        return 40;
    }
    else
    {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            LoginVC *loginVC = LoginVC.new;
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }
    if(indexPath.section == 1)
    {
        if(indexPath.row == 1)
        {
            //清空userId
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:nil forKey:@"userId"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
