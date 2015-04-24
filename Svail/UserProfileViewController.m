//
//  UserProfileViewController.m
//  Svail
//
//  Created by Mert Akanay on 4/18/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Verification.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *safetyLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fullnameLabel.text = self.selectedUser.name;
    self.emailLabel.text = self.selectedUser.username;

    self.phoneLabel.text = self.selectedUser.phoneNumber;
    self.phoneLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *onPhoneNumberTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhoneNumber)];
    [self.phoneLabel addGestureRecognizer:onPhoneNumberTapped];

    self.cityLabel.text = self.selectedUser.city;
    self.stateLabel.text = self.selectedUser.state;
    self.specialtyLabel.text = self.selectedUser.specialty;
    self.occupationLabel.text = self.selectedUser.occupation;
    self.safetyLevelLabel.text = [NSString stringWithFormat:@"Safety level:%ld",(long)self.selectedUser.verification.safetyLevel];
    [self.selectedUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image = image;
        }
    }];

}

-(void)callPhoneNumber
{
    NSString *phoneNumber = self.selectedUser.phoneNumber;
    NSString *phoneString = [NSString stringWithFormat:@"telprompt://%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
}


@end
