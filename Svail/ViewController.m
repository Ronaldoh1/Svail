//
//  ViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/12/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {

    UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *loginVC = [loginStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
    [self presentViewController:loginVC animated:true completion:nil];

    
}
- (IBAction)toMap:(id)sender {


    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];

    UITabBarController *tabBarVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];



    UIStoryboard *serviceListStoryBoard = [UIStoryboard storyboardWithName:@"Service" bundle:nil];

    UITabBarController *serviceNavVC = [serviceListStoryBoard instantiateViewControllerWithIdentifier:@"ServiceListNavVC"];


    [tabBarVC addChildViewController:serviceNavVC];

    serviceNavVC.tabBarItem.image = [UIImage imageNamed:@"heartz.png"];

   // ((UITabBarItem*)[tabBarVC.tabBarItem.image])

    [self presentViewController:tabBarVC animated:true completion:nil];
}

@end
