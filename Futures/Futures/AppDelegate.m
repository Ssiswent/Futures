//
//  AppDelegate.m
//  Futures
//
//  Created by Ssiswent on 2020/6/3.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "AppDelegate.h"

#import <IQKeyboardManager.h>

#import "HomeVC.h"
#import "CommunityVC.h"
#import "MineVC.h"

@interface AppDelegate ()

@property(nonatomic, strong)UITabBarController *tabBarC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [IQKeyboardManager sharedManager];
    //点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self setTabBarC];
    self.window.rootViewController = _tabBarC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setTabBarC
{
    UITabBarController *tabBarC = UITabBarController.new;
    //去掉原生tabbar分割线
    [tabBarC.tabBar setShadowImage:[UIImage new]];
    [tabBarC.tabBar setBackgroundImage:[UIImage new]];
    
    tabBarC.tabBar.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    tabBarC.tabBar.tintColor = [UIColor colorWithHexString:@"#293AFF"];
    tabBarC.tabBar.unselectedItemTintColor = [UIColor colorWithHexString:@"#BEC3FF"];
    
    self.tabBarC = tabBarC;
    
    HomeVC *homeVC = [[HomeVC alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(kScaleFrom_iPhone8_Width(20), 0);
    
    [self addChildVC:homeNav title:@"首页" imgName:@"ic_shouye_del" selectedImgName:@"ic_shouye_sel"];
    
    CommunityVC *communityVC = [[CommunityVC alloc]init];
    UINavigationController *communityNav = [[UINavigationController alloc] initWithRootViewController:communityVC];
    [self addChildVC:communityNav title: @"社区" imgName:@"ic_shequ_del" selectedImgName:@"ic_shequ_sel"];

    MineVC *mineVC = [[MineVC alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    [self addChildVC:mineNav title:@"我的" imgName:@"ic_mine_del" selectedImgName:@"ic_mine_sel"];
    mineNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(kScaleFrom_iPhone8_Width(-20), 0);
}

- (void)addChildVC:(UINavigationController *)nav title:(NSString *)title imgName:(NSString *)imgName selectedImgName:(NSString *)selectedImgName
{
    nav.tabBarItem.title = title;
    [nav.tabBarItem setImage:[UIImage originalImageWithName:imgName]];
    [nav.tabBarItem setSelectedImage:[UIImage originalImageWithName:selectedImgName]];
    [self.tabBarC addChildViewController:nav];
}

@end
