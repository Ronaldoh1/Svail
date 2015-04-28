//
//  TabBarViewController.m
//  Svail
//
//  Created by Mert Akanay on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIStoryboard *editProfileStoryboard = [UIStoryboard storyboardWithName:@"EditProfile" bundle:nil];
    UIViewController *editProfileVC = [editProfileStoryboard instantiateViewControllerWithIdentifier:@"editProfileNavVC"];
    [self.tabBarController addChildViewController:editProfileVC];
    UITabBarItem *editProfileItem = self.tabBarController.tabBar.items[1];
    editProfileItem.image = [UIImage imageNamed:@"defaultimage"];

    [self.tabBarController reloadInputViews];
    
}
@end
