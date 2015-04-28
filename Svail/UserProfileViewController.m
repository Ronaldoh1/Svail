//
//  UserProfileViewController.m
//  Svail
//
//  Created by Mert Akanay on 4/18/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Verification.h"

@interface UserProfileViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *safetyImageView;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:248/255.0 blue:255/255.0 alpha:1.0];

    self.fullnameLabel.text = self.selectedUser.name;
    self.emailLabel.text = self.selectedUser.username;

    self.phoneLabel.text = self.selectedUser.phoneNumber;
//    self.phoneLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *onPhoneNumberTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhoneNumber)];
//    [self.phoneLabel addGestureRecognizer:onPhoneNumberTapped];

    self.stateLabel.text = self.selectedUser.state;
    self.occupationLabel.text = self.selectedUser.occupation;

    PFQuery *providerQuery = [User query];
    [providerQuery includeKey:@"verification"];
    [providerQuery getObjectInBackgroundWithId:self.selectedUser.objectId block:^(PFObject *user, NSError *error)
     {
         if (!error) {
             User *selectedUser = (User *)user;
             if ([[selectedUser.verification objectForKey:@"safetyLevel"] integerValue] >= 5) {
                 self.safetyImageView.hidden = false;
             } else {
                 self.safetyImageView.hidden = true;
             }
         } else {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
         }
     }];

    [self.selectedUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image = image;
            self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
            self.imageView.layer.masksToBounds = YES;
            self.imageView.layer.borderWidth = 1.5;
            self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            self.imageView.clipsToBounds = YES;
        }
    }];
}

-(void)callPhoneNumber
{
    NSString *phoneNumber = self.selectedUser.phoneNumber;
    NSString *phoneString = [NSString stringWithFormat:@"telprompt://%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
}
- (IBAction)onPhoneButtonPressed:(UIButton *)sender
{

    [self callPhoneNumber];
}

- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
