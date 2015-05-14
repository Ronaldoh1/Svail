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

@interface EditProfileViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate, FBSDKGraphRequestConnectionDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *fullnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *occupationTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *changeImageButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOutButton;
@property (weak, nonatomic) IBOutlet UILabel *pleaseSignInLabel;

@property User *currentUser;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:20];
    titleView.text = @"Profile";
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];

    [self initialSetUp];


//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];

}
-(void)initialSetUp{

    //set the delegate for each textfield to self.
    [self setDelegatesForTextFields];


    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor orangeColor]forKey:NSForegroundColorAttributeName];

    if ([User currentUser] == nil)
    {
        self.signInButton.enabled = YES;
        self.signInButton.hidden = NO;
        self.signUpButton.enabled = YES;
        self.signUpButton.hidden = NO;
        self.pleaseSignInLabel.hidden = NO;

        self.saveButton.enabled = NO;
        self.saveButton.hidden = YES;
        self.verifyButton.enabled = NO;
        self.verifyButton.hidden = YES;
        self.changeImageButton.enabled = NO;
        self.changeImageButton.hidden = YES;
        self.logOutButton.enabled = NO;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
        self.fullnameTextField.hidden = YES;
        self.emailTextField.hidden = YES;
        self.passwordTextField.hidden = YES;
        self.stateTextField.hidden = YES;
        self.occupationTextField.hidden = YES;
        self.phoneTextField.hidden = YES;
        self.profileImage.hidden = YES;
    }else
    {
        self.signInButton.enabled = NO;
        self.signInButton.hidden = YES;
        self.signUpButton.enabled = NO;
        self.signUpButton.hidden = YES;
        self.pleaseSignInLabel.hidden = YES;

        self.saveButton.enabled = YES;
        self.saveButton.hidden = NO;
        self.verifyButton.enabled = YES;
        self.verifyButton.hidden = NO;
        self.changeImageButton.enabled = YES;
        self.changeImageButton.hidden = NO;
        self.logOutButton.enabled = YES;
        self.fullnameTextField.hidden = NO;
        self.emailTextField.hidden = NO;
        self.passwordTextField.hidden = NO;
        self.stateTextField.hidden = NO;
        self.occupationTextField.hidden = NO;
        self.phoneTextField.hidden = NO;
        self.profileImage.hidden = NO;
    }

    self.verifyButton.clipsToBounds = true;
    self.verifyButton.layer.cornerRadius = 40/2.0;
    self.verifyButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];
    self.saveButton.clipsToBounds = true;
    self.saveButton.layer.cornerRadius = 40/2.0;
    self.saveButton.backgroundColor = [UIColor colorWithRed:59/255.0 green:185/255.0 blue:255/255.0 alpha:1.0];
    self.signInButton.clipsToBounds = true;
    self.signInButton.layer.cornerRadius = 60/2.0;
    self.signInButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];
    self.signUpButton.clipsToBounds = true;
    self.signUpButton.layer.cornerRadius = 60/2.0;
    self.signUpButton.backgroundColor = [UIColor colorWithRed:59/255.0 green:185/255.0 blue:255/255.0 alpha:1.0];

    self.currentUser = [User currentUser];

    //    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:248/255.0 blue:255/255.0 alpha:1.0];

    self.fullnameTextField.text = self.currentUser.name;

    if (self.currentUser.isFbUser == YES) {

        self.passwordTextField.hidden = YES;

    }else{

        self.passwordTextField.text = self.currentUser.password;
    }
    self.emailTextField.text = self.currentUser.email;
    self.stateTextField.text = self.currentUser.state;
    self.occupationTextField.text = self.currentUser.occupation;
    self.phoneTextField.text = self.currentUser.phoneNumber;
    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.profileImage.image = image;
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
            self.profileImage.layer.masksToBounds = YES;
            self.profileImage.layer.borderWidth = 1.5;
            self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
            self.profileImage.clipsToBounds = YES;
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
    self.currentUser.state = self.stateTextField.text;
//    self.currentUser.phoneNumber = self.phoneTextField.text;
    self.currentUser.occupation = self.occupationTextField.text;
    [self.currentUser saveInBackground];
    
    if (self.phoneTextField.text.length != 10){
        UIAlertView  *wrongDigitsAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter 10 digits phone number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [wrongDigitsAlert show];
    } else if (![self.phoneTextField.text
                 isEqualToString:self.currentUser.phoneNumber]) {
        [User checkIfPhoneNumber:self.phoneTextField.text
                    hasBeenUsedWithCompletion:^(User *userWithThisNumber, NSError *error)
        {
            if (!error) {
                if (userWithThisNumber == nil) {
                    [self.currentUser.verification sendVerifyCodeToPhoneNumber:self.phoneTextField.text];
                    UIAlertView *veriCodeAlert = [[UIAlertView alloc]initWithTitle:@"Enter verification code" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    veriCodeAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    veriCodeAlert.tag = 1;
                    [veriCodeAlert show];
                
                } else {
                    UIAlertView  *numberUsedAlert = [[UIAlertView alloc]initWithTitle:nil message:@"This number has been taken." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [numberUsedAlert show];
                }
            } else {
                 UIAlertView  *errorAlert = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlert show];
            }

        }];
        
    }

}


- (IBAction)onVeriButtonTapped:(UIButton *)sender
{
    
    UIStoryboard *veriStoryboard = [UIStoryboard storyboardWithName:@"Verification" bundle:nil];
    UIViewController *veriNavVC = [veriStoryboard instantiateViewControllerWithIdentifier:@"VeriNavVC"];
    [self presentViewController:veriNavVC animated:YES completion:nil];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 0) {
        UITextField *verifyCodeTextField = [alertView textFieldAtIndex:0];
        if ([self.currentUser.verification verifyPhoneNumber:self.phoneTextField.text withVerifyCode:verifyCodeTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Successful!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            alert.tag = 2;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Wrong code." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            alert.tag = 3;
            [alert show];
        }
        
    }
    
    if (alertView.tag == 2 && buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

-(void)setDelegatesForTextFields{

    self.fullnameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.stateTextField.delegate = self;
    self.occupationTextField.delegate = self;
    self.phoneTextField.delegate = self;


}
- (IBAction)logOUtButtonPressed:(UIBarButtonItem *)sender
{
    [User logOut];

    //Disable the tab for history
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];


    self.fullnameTextField.text = [NSString stringWithFormat:@""];
    self.emailTextField.text = [NSString stringWithFormat:@""];
    self.passwordTextField.text = [NSString stringWithFormat:@""];
    self.stateTextField.text = [NSString stringWithFormat:@""];
    self.occupationTextField.text = [NSString stringWithFormat:@""];
    self.phoneTextField.text = [NSString stringWithFormat:@""];
    self.profileImage.image = [UIImage imageNamed:@"defaultimage"];
    self.signInButton.enabled = YES;
    self.signInButton.hidden = NO;
    self.signUpButton.enabled = YES;
    self.signUpButton.hidden = NO;
    self.pleaseSignInLabel.hidden = NO;

    self.saveButton.enabled = NO;
    self.saveButton.hidden = YES;
    self.verifyButton.enabled = NO;
    self.verifyButton.hidden = YES;
    self.changeImageButton.enabled = NO;
    self.changeImageButton.hidden = YES;
    self.logOutButton.enabled = NO;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    self.fullnameTextField.hidden = YES;
    self.emailTextField.hidden = YES;
    self.passwordTextField.hidden = YES;
    self.stateTextField.hidden = YES;
    self.occupationTextField.hidden = YES;
    self.phoneTextField.hidden = YES;
    self.profileImage.hidden = YES;
    [self.view reloadInputViews];

}
- (IBAction)onSignInButtonPressed:(UIButton *)sender
{
    UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];

    UIViewController *loginVC = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginNavVC"];

    [self presentViewController:loginVC animated:true completion:nil];
}

- (IBAction)onSignUpButtonPressed:(UIButton *)sender
{
    UIStoryboard *signUpStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];

    UIViewController *signUpVC = [signUpStoryBoard instantiateViewControllerWithIdentifier:@"SignUpNavVC"];

    [self presentViewController:signUpVC animated:true completion:nil];
}

#pragma Marks - hiding keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    [self.view endEditing:true];
    return true;
}
//hide keyboard when user touches outside.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
