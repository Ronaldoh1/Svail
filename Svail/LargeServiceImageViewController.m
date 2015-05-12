//
//  LargeServiceImageViewController.m
//  Svail
//
//  Created by zhenduo zhu on 5/11/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "LargeServiceImageViewController.h"

@interface LargeServiceImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;

@end

@implementation LargeServiceImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:15];
    titleView.text = self.title;
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];
    
    self.serviceImageView.image = self.serviceImage;
}


- (IBAction)onCloseButtonTapped:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
