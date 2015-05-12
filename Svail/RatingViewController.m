//
//  RatingViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/26/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "RatingViewController.h"
#import "Rating.h"
#import "CustomViewUtilities.h"
#import "ProfileImageView.h"

@interface RatingViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet ProfileImageView *providerImageView;
@property (weak, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //setup color tint
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:20];
    titleView.text = @"Rating";
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];
    
    
    for (UIButton *starButton in self.starButtons) {
        starButton.alpha = 0.2;
    }
    
    PFQuery *serviceQuery = [ServiceSlot query];
    [serviceQuery includeKey:@"service.provider"];
    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceQuery getObjectInBackgroundWithId:self.serviceSlot.objectId
                                        block:^(PFObject *object, NSError *error)
     {
         self.serviceSlot = (ServiceSlot *)object;
         if (!error) {
             self.providerImageView.user = self.serviceSlot.service.provider;
             self.providerImageView.vc = self;
             self.providerNameLabel.text = self.serviceSlot.service.provider.name;
             self.titleLabel.text = self.serviceSlot.service.title;
             
             NSDateFormatter *dateFormatter = [NSDateFormatter new];
             [dateFormatter setDateFormat:@"MM/dd/yy"];
             self.timeLabel.text = [dateFormatter stringFromDate:self.serviceSlot.service.startDate];
             self.timeLabel.text = [NSString stringWithFormat:@"%@   %@", self.timeLabel.text,[self.serviceSlot getTimeSlotString]];
             
        }
    }];
    
    
}

- (IBAction)onStarButtonTapped:(UIButton *)sender
{
    NSUInteger indexOfTappedStar = [self.starButtons indexOfObject:sender];
    for (int i = 0; i <= indexOfTappedStar; i++) {
        ((UIButton *)self.starButtons[i]).alpha = 1.0;
    }
    
    Rating *rating = [Rating object];
    rating.rater = [User currentUser];
    rating.serviceSlot = self.serviceSlot;
    rating.value = indexOfTappedStar + 1;
    [rating saveInBackground];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Thanks!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 0) {
//        UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
//        UIViewController *mapTabVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
//        [self presentViewController:mapTabVC animated:false completion:nil];
        [self.vc dismissViewControllerAnimated:true completion:nil];
    }
}


@end
