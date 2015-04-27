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

@interface RatingViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *providerImageView;
@property (weak, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton *starButton in self.starButtons) {
        starButton.alpha = 0.2;
    }
    
    PFQuery *serviceQuery = [Service query];
    [serviceQuery includeKey:@"provider"];
    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceQuery getObjectInBackgroundWithId:self.service.objectId
                                        block:^(PFObject *object, NSError *error)
     {
         self.service = (Service *)object;
         if (!error) {
             [self.service.provider.profileImage getDataInBackgroundWithBlock:^(NSData *data,
                                                                                NSError *error)
              {
                  if (!error) {
                      [CustomViewUtilities setupProfileImageView:self.providerImageView WithImage:[UIImage imageWithData:data]];
                  }
              }];
             self.providerNameLabel.text = self.service.provider.name;
             self.titleLabel.text = self.service.title;
             
             NSDateFormatter *dateFormatter = [NSDateFormatter new];
             [dateFormatter setDateFormat:@"MM/dd/yy HH:mm"];
             self.timeLabel.text = [NSString stringWithFormat:@"%@ --- %@",
                                           [dateFormatter stringFromDate:self.service.startDate],
                                           [dateFormatter stringFromDate:self.service.endDate]];
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
    rating.ratee = self.service.provider;
    rating.value = indexOfTappedStar + 1;
    [rating saveInBackground];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Thanks!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 0) {
        UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
        UIViewController *mapTabVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
        [self presentViewController:mapTabVC animated:false completion:nil];
    }
}


@end
