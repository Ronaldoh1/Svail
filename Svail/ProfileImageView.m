//
//  CustomImageView.m
//  Svail
//
//  Created by Mert Akanay on 4/26/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "ProfileImageView.h"
#import "CustomViewUtilities.h"
#import "UserProfileViewController.h"

@implementation ProfileImageView


-(void)setUser:(User *)user
{
    _user = user;
    self.userInteractionEnabled = true;
    [[User query] getObjectInBackgroundWithId:_user.objectId block:^(PFObject *object, NSError *error)
    {
        if (!error) {
            User *fetchedUser = (User *)object;
            [fetchedUser.profileImage getDataInBackgroundWithBlock:^(NSData *data,
                                                                 NSError *error)
             {
                  if (!error) {
                      self.image = [UIImage imageWithData:data];
                  } else {
                      self.image = [UIImage imageNamed:@"profile"];
                  }
                [CustomViewUtilities transformToCircleViewFromSquareView:self];
                UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapOnProfileImageView:)];
                tapGesture.numberOfTapsRequired = 1;
                
                [self addGestureRecognizer:tapGesture];

             }];
         }
        
        
    }];
}

-(void)handleTapOnProfileImageView:(UITapGestureRecognizer *)tapGesture
{
   
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"UserProfile" bundle:nil];
    UINavigationController *userProfileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
    UserProfileViewController *userProfileVC = userProfileNavVC.childViewControllers[0];
    userProfileVC.selectedUser = self.user;
    [self.vc presentViewController:userProfileNavVC animated:true completion:nil];
}

@end
