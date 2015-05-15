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




    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0]];
    
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
    historyVC.tabBarItem.enabled = false;
    
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasBeenRun"];


}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 1, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma Mark - Unwind Segues

-(IBAction)unwindSegueFromLogInViewController:(UIStoryboardSegue *)segue

{

}

-(IBAction)unwindSegueFromRegisterViewController:(UIStoryboardSegue *)segue

{
    
}


@end
