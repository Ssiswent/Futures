//
//  HomeVC.m
//  Futures
//
//  Created by Ssiswent on 2020/6/3.
//  Copyright © 2020 Ssiswent. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if(SCREEN_HEIGHT >= 812)
    {
        _topViewHeight.constant = 88;
    }
    
    _searchBar.layer.cornerRadius = 12.5;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.searchTextField.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#E9E9E9"];
    
    [self setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

- (void)setImage:(nullable UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state;
{
    
}

@end
