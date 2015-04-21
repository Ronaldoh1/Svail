//
//  EditProfileViewController.m
//  Svail
//
//  Created by Mert Akanay on 4/18/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "EditProfileViewController.h"
#import "User.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "Verification.h"

@interface EditProfileViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FBSDKGraphRequestConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fullnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *specialtyTextField;
@property (weak, nonatomic) IBOutlet UITextField *occupationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property User *currentUser;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];

    self.fullnameTextField.text = self.currentUser.name;
    self.emailTextField.text = self.currentUser.username;
    self.passwordTextField.text = self.currentUser.password;
    self.cityTextField.text = self.currentUser.city;
    self.stateTextField.text = self.currentUser.state;
    self.specialtyTextField.text = self.currentUser.specialty;
    self.occupationTextField.text = self.currentUser.occupation;
    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.profileImage.image = image;
        }
    }];
}

- (IBAction)onChangeImageButtonPressed:(UIButton *)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Select Image for Profile" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From library", @"From Camera", nil];

    [action showInView:self.view];
}

#pragma Mark - Choosing Image
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ) {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerView animated:YES completion:nil];

    }else if( buttonIndex == 1 ) {

        UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerView animated:YES completion:nil];
//    }else if( buttonIndex == 2 ) {

//        FBSDKGraphRequest *request

    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    [self dismissViewControllerAnimated:picker completion:nil];

    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];

    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    self.profileImage.image = image;
    self.currentUser.profileImage = imageFile;
    [self.currentUser.profileImage saveInBackground];
    
}
- (IBAction)onSaveButtonPressed:(UIButton *)sender
{
    self.currentUser.username = self.emailTextField.text;
    self.currentUser.name = self.fullnameTextField.text;
    self.currentUser.city = self.cityTextField.text;
    self.currentUser.state = self.stateTextField.text;
    self.currentUser.specialty = self.specialtyTextField.text;
    self.currentUser.occupation = self.occupationTextField.text;

    [self.currentUser saveInBackground];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onVeriButtonTapped:(UIButton *)sender
{
    
    UIStoryboard *veriStoryboard = [UIStoryboard storyboardWithName:@"Verification" bundle:nil];
    UIViewController *veriNavVC = [veriStoryboard instantiateViewControllerWithIdentifier:@"VeriNavVC"];
    [self presentViewController:veriNavVC animated:YES completion:nil];
}
- (IBAction)onCancelButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
