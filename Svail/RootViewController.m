//
//  ViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/12/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "RootViewController.h"
#import <TwitterKit/TwitterKit.h>
#import <Parse/Parse.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    // Create our Installation query
//    PFQuery *pushQuery = [PFInstallation query];
//    [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
//
//    // Send push notification to query
//    [PFPush sendPushMessageToQueryInBackground:pushQuery
//                                   withMessage:@"Hello World!"];

    //

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)presentSignInButton:(UIButton *)sender
{
        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginNavVC"];
        [self presentViewController:loginVC animated:true completion:nil];
}

- (IBAction)presentSignUpButton:(UIButton *)sender
{
    UIStoryboard *signUpStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *signUpVC = [signUpStoryBoard instantiateViewControllerWithIdentifier:@"SignUpNavVC"];
    [self presentViewController:signUpVC animated:true completion:nil];
}

-(IBAction)unwindSegueFromLogInViewController:(UIStoryboardSegue *)segue
{
    
}

-(IBAction)unwindSegueFromRegisterViewController:(UIStoryboardSegue *)segue
{
    
}






//- (IBAction)login:(id)sender {
//
//    UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    UIViewController *loginVC = [loginStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
//    [self presentViewController:loginVC animated:true completion:nil];
//
//    
//}
//- (IBAction)toMap:(id)sender {
//
//
//    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
//
//    UITabBarController *tabBarVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
//
//
//
//    UIStoryboard *serviceListStoryBoard = [UIStoryboard storyboardWithName:@"Service" bundle:nil];
//
//    UITabBarController *serviceNavVC = [serviceListStoryBoard instantiateViewControllerWithIdentifier:@"ServiceListNavVC"];
//
//
//    [tabBarVC addChildViewController:serviceNavVC];
//
//    serviceNavVC.tabBarItem.image = [UIImage imageNamed:@"heartz.png"];
//
//   // ((UITabBarItem*)[tabBarVC.tabBarItem.image])
//
//    [self presentViewController:tabBarVC animated:true completion:nil];
//}

@end
