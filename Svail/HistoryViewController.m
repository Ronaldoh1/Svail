//
//  HistoryViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/28/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "HistoryViewController.h"
#import "PostHistoryViewController.h"
#import "ReservationHistoryViewController.h"

@interface HistoryViewController ()

@property (nonatomic) PostHistoryViewController *postHistoryVC;
@property (nonatomic) ReservationHistoryViewController *reservationHistoryVC;
@property (nonatomic) UIViewController *currentVC;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation HistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:20];
    titleView.text = @"History";
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];
    
    
//    self.postHistoryVC = self.childViewControllers.lastObject;
    self.postHistoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostHistoryVC"];
   
    self.reservationHistoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReservationHistoryVC"];
    
    self.currentVC = self.postHistoryVC;


    
}

//-(void)viewWillAppear:(BOOL)animated
//{
////    [super viewWillAppear:true];
//    [self.currentVC viewWillAppear:true];
//}

-(void)viewDidAppear:(BOOL)animated
{
    [self addChildViewController:self.currentVC];
    [self.containerView addSubview:self.currentVC.view];
}



- (IBAction)onSegmentsTapped:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self addChildViewController:self.postHistoryVC];
            [self moveToNewController:self.postHistoryVC];
            break;
        case 1:
            [self addChildViewController:self.reservationHistoryVC];
            [self moveToNewController:self.reservationHistoryVC];
            break;
        default:
            break;
    }
    
}

-(void)moveToNewController:(UIViewController *)newController
{
    [self.currentVC willMoveToParentViewController:nil];
    [self transitionFromViewController:self.currentVC toViewController:newController duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil
                            completion:^(BOOL finished) {
                                [self.currentVC removeFromParentViewController];
                                [newController didMoveToParentViewController:self];
                                self.currentVC = newController;
                            }];
}

@end
