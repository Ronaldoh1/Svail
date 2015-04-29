//
//  RootTabBarController.m
//  Svail
//
//  Created by zhenduo zhu on 4/28/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "RootTabBarController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UITabBarController *mapNavVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MapNavVC"];
    [self addChildViewController:mapNavVC];
    mapNavVC.tabBarItem.image =  [self imageWithImage:[UIImage imageNamed:@"mapicon"] scaledToSize:CGSizeMake(35, 35)];
    

    
    UIStoryboard *editProfileStoryboard = [UIStoryboard storyboardWithName:@"EditProfile" bundle:nil];
    UIViewController *editProfileVC = [editProfileStoryboard instantiateViewControllerWithIdentifier:@"editProfileNavVC"];
    [self addChildViewController:editProfileVC];
    editProfileVC.tabBarItem.image =  [self imageWithImage:[UIImage imageNamed:@"profile3"] scaledToSize:CGSizeMake(35, 35)];


    UIStoryboard *historyStoryboard = [UIStoryboard storyboardWithName:@"History" bundle:nil];
    UIViewController *historyVC = [historyStoryboard instantiateViewControllerWithIdentifier:@"HistoryNavVC"];
    [self addChildViewController:historyVC];
    historyVC.tabBarItem.image =  [self imageWithImage:[UIImage imageNamed:@"history2"] scaledToSize:CGSizeMake(35, 35)];
    
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 1, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
