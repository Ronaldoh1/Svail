//
//  SocialVeriViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "SocialVeriViewController.h"
#import <TwitterKit/TwitterKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"

#import "User.h"
#import "Verification.h"
#import "Image.h"
#import "Reference.h"


@interface SocialVeriViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic) BOOL isUserVerified;
@property (nonatomic) LIALinkedInHttpClient *linkedIn;
@property (weak, nonatomic) IBOutlet UIImageView *fbCheckmark;
@property (weak, nonatomic) IBOutlet UIImageView *ttCheckmark;
@property (weak, nonatomic) IBOutlet UIImageView *lkCheckmark;
@property (weak, nonatomic) IBOutlet UIImageView *safetyCheckmark;
@property (weak, nonatomic) IBOutlet UIButton *fbVerifyButton;
@property (weak, nonatomic) IBOutlet UIButton *ttVerifyButton;
@property (weak, nonatomic) IBOutlet UIButton *lkVerifyButton;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *phoneNumberTextFields;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *phoneNumberCheckmarks;


@property (nonatomic) User *currentUser;


@end

@implementation SocialVeriViewController

static float const kAlphaForButtonsIfVerified = 0.1;
static float const kAlphaForSafetyCheckmarkUnqualified = 0.1;
static float const kAlphaForButtonsIfNotVerified = 1.0;


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setUpDelegatesForTextFields];


    //setup color tint
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:20];
    titleView.text = @"Verification";
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];

    self.fbCheckmark.hidden = true;
    self.ttCheckmark.hidden = true;
    self.lkCheckmark.hidden = true;
    self.safetyCheckmark.alpha = kAlphaForSafetyCheckmarkUnqualified;
    self.levelLabel.text = [NSString stringWithFormat:@"Verification Level : 0"];
    for (UIImageView *phoneNumberCheckMark in self.phoneNumberCheckmarks) {
        phoneNumberCheckMark.hidden = true;
    }

    self.currentUser = [User currentUser];
    
    [self.currentUser getVerificationInfoWithCompletion:^(NSError *error)
    {
        if (!error) {

            [self setupFBItems:self.currentUser.verification.fbLevel > 0];
            [self setupTTItems:self.currentUser.verification.ttLevel > 0];
            [self setupLKItems:self.currentUser.verification.lkLevel > 0];
            [self setupPhoneNumberItems];
            [self setupSafetyLevelItems];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alert show];
        }
    }];
}


-(void)setupSafetyLevelItems
{
    
    Verification *verification = self.currentUser.verification;
    verification.safetyLevel = [verification calculateSafetyLevel];
    [verification saveInBackground];
    
    if (self.currentUser.verification.hasReachedSafeLevel) {
        self.safetyCheckmark.alpha = 1.0;
    } else {
        self.safetyCheckmark.alpha = kAlphaForSafetyCheckmarkUnqualified;
    }
    
    
    self.levelLabel.text = [NSString stringWithFormat:@"Verification Level : %lu",(long)(self.currentUser.verification.safetyLevel)];
    [verification saveInBackground];
}

-(void)setupFBItems:(BOOL)isVerified
{
    if (isVerified) {
        self.fbCheckmark.hidden = NO;
        self.fbVerifyButton.imageView.alpha = kAlphaForButtonsIfVerified;
        self.fbVerifyButton.userInteractionEnabled = NO;
    } else {
        self.fbCheckmark.hidden = YES;
        self.fbVerifyButton.imageView.alpha = kAlphaForButtonsIfNotVerified;
        self.fbVerifyButton.userInteractionEnabled = YES;
    }
}

-(void)setupTTItems:(BOOL)isVerified
{
    if (isVerified) {
        self.ttCheckmark.hidden = NO;
        self.ttVerifyButton.imageView.alpha = kAlphaForButtonsIfVerified;
        self.ttVerifyButton.userInteractionEnabled = NO;
    } else {
        self.ttCheckmark.hidden = YES;
        self.ttVerifyButton.imageView.alpha = kAlphaForButtonsIfNotVerified;
        self.ttVerifyButton.userInteractionEnabled = YES;
    }
}

-(void)setupLKItems:(BOOL)isVerified
{
    if (isVerified) {
        self.lkCheckmark.hidden = NO;
        self.lkVerifyButton.imageView.alpha = kAlphaForButtonsIfVerified;
        self.lkVerifyButton.userInteractionEnabled = NO;
    } else {
        self.lkCheckmark.hidden = YES;
        self.lkVerifyButton.imageView.alpha = kAlphaForButtonsIfNotVerified;
        self.lkVerifyButton.userInteractionEnabled = YES;
    }
}

-(void)setupPhoneNumberItems
{
    for (UIImageView *phoneNumberCheckmark in self.phoneNumberCheckmarks) {
        phoneNumberCheckmark.hidden = YES;
    }
    NSArray *references = self.currentUser.verification.references;
    for (int i = 0; i < references.count; i++) {
        ((UIImageView *)self.phoneNumberCheckmarks[i]).hidden = NO;
        UITextField *phoneNumberTextField = self.phoneNumberTextFields[i];
        Reference *reference = references[i];
        phoneNumberTextField.text = reference.fromPhoneNumber;
    }
}



- (IBAction)onRequestButtonTapped:(UIButton *)sender
{
    
//    NSString *message = [NSString stringWithFormat:@"Please help your friend %@ complete a simple safety check for using Svail.", [User currentUser].name];
    if (!self.currentUser.phoneNumber || [self.currentUser.phoneNumber isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please add your cell phone number to your profile before sending request." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"Please help your friend %@ complete a simple safety check in order to use Svail. If you think %@ is a trustworthy person, please reply this message with %@'s 10-digit cell phone number. Do not use any any punctuations eg. dashes, periods, parenthesis etc. If you think otherwise, please don't reply. Thank you!", [User currentUser].name, [User currentUser].name, [User currentUser].name];
    for (int i = (int)(self.currentUser.verification.references.count); i < 3; i++) {
        UITextField *textField = self.phoneNumberTextFields[i];
        if (![textField.text isEqualToString:@""]) {
            if (![textField.text isEqualToString:self.currentUser.phoneNumber]) {
                [self sendSMSFromParseWithToNumber:textField.text message:message];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter a phone number different than yours." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }

        }
    }

}


-(void)sendSMSFromParseWithToNumber:(NSString *)toNumber message:(NSString *)message
{
    [PFCloud callFunctionInBackground:@"sendSMS"
                       withParameters:@{@"toNumber":toNumber,
                                        @"message": message}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                        NSLog(@"%@",toNumber);
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message: [NSString stringWithFormat:@"Request has been sent to %@.",toNumber] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [alert show];
                                    }
                                }];

}




- (IBAction)onFacebookVerifyButtonTapped:(UIButton *)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"user_friends"]) {
                // Do work
                if ([FBSDKAccessToken currentAccessToken]) {
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             
                             NSString *fbId = result[@"id"];
                             [self setupFBLevelWithFBId:fbId];
                         }
                     }];
                }
            }
        }
    }];
}


-(void)setupFBLevelWithFBId:(NSString *)fbId
{
     [Verification checkIfFBId:fbId hasBeenUsedWithCompletion:^(Verification *verification, NSError *error)
     {
         if (!error) {
             if (verification == nil || verification.objectId == self.currentUser.verification.objectId) {
             
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             
                             NSUInteger friendsCount = [result[@"summary"][@"total_count"] integerValue];
                             NSLog(@"facebook %@ friends count : %lu",fbId, (long)friendsCount);
                             self.currentUser.verification.fbId = fbId;
                             self.currentUser.verification.fbLevel = [Verification getFBLevelWithNumOfFriends:friendsCount];
                             [self.currentUser saveInBackground];
                             [self setupFBItems:self.currentUser.verification.fbLevel > 0];
                             [self setupSafetyLevelItems];
                             if (self.currentUser.verification.fbLevel == 0) {
                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your facebook friends number is not enough." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                 [alert show];
                             }

                             
                         }
                     }];
             } else {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"This facebook account has been used to verify another user." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }
         } else {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
         }
         
     }];
    
}




- (IBAction)onTwitterVerifyButtonTapped:(UIButton *)sender
{
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error)
    {
         if (session) {
             NSLog(@"signed in as %@", [session userName]);
             [self getTwitterFollowersCount];
             [self checkIsTwitterUserVerified];
             [[Twitter sharedInstance] logOut];
         } else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}




-(void)checkIsTwitterUserVerified
{
    NSString *twitterUserID = [[Twitter sharedInstance] session].userID;
    [[[Twitter sharedInstance] APIClient] loadUserWithID:twitterUserID completion:^(TWTRUser *user, NSError *error) {
        if (!user.isVerified) {
            NSLog(@"Twitter user is not verified");
        } else {
            NSLog(@"Twitter user is verified");
        }
    }];
}


-(void)getTwitterFollowersCount
{
    NSString *twitterUserID = [[Twitter sharedInstance] session].userID;
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/followers/ids.json";
    NSDictionary *params = @{@"id" : twitterUserID};
    NSError *clientError;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                             URLRequestWithMethod:@"GET"
                             URL:statusesShowEndpoint
                             parameters:params
                             error:&clientError];

    if (request) {
        [[[Twitter sharedInstance] APIClient]
         sendTwitterRequest:request
         completion:^(NSURLResponse *response, NSData *data, NSError *connectionError)
        {
             if (data) {
                 // handle the response data e.g.
                 NSError *jsonError;
                 NSDictionary *json = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:0
                                       error:&jsonError];
                 NSUInteger followersCount = [json[@"ids"] count];
                 NSLog(@"Twitter followers count : %lu",(long)followersCount);
                 [self setupTTLevelWithTTId:twitterUserID followersCount:followersCount];

             }
             else {
                 NSLog(@"Error: %@", connectionError);
             }
         }];
    } else {
        NSLog(@"Error: %@", clientError);
    }
}

-(void)setupTTLevelWithTTId:(NSString *)ttId followersCount:(NSUInteger)followersCount
{
     [Verification checkIfTTId:ttId hasBeenUsedWithCompletion:^(Verification *verification, NSError *error)
     {
         if (!error) {
             if (verification == nil || verification.objectId == self.currentUser.verification.objectId) {


                 self.currentUser.verification.ttId = ttId;
                  self.currentUser.verification.ttLevel = [Verification getTTLevelWithNumOfFollowers:followersCount];
                 [self.currentUser saveInBackground];
                 [self setupTTItems:self.currentUser.verification.ttLevel > 0];
                 [self setupSafetyLevelItems];
                 if (self.currentUser.verification.ttLevel == 0) {
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your twitter followers number is not enough." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 
             } else {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"This twitter account has been used to verify another user." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }
         } else {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
         }
         
     }];
    
}


- (IBAction)onLinkedInVerifyButtonTapped:(UIButton *)sender
{
    [self.linkedIn getAuthorizationCode:^(NSString *code)
    {
        [self.linkedIn getAccessToken:code success:^(NSDictionary *accessTokenData)
        {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self getLinkedInConnectionCountWithToken:accessToken];
        }   failure:^(NSError *error)
        {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }   cancel:^
    {
        NSLog(@"Authorization was cancelled by user");
    }   failure:^(NSError *error)
    {
        NSLog(@"Authorization failed %@", error);
    }];
}


- (void)getLinkedInConnectionCountWithToken:(NSString *)accessToken {
    NSString *queryURLString = @"https://api.linkedin.com/v1/people/~:(id,num-connections)";
    [self.linkedIn GET:[NSString stringWithFormat:@"%@?oauth2_access_token=%@&format=json",queryURLString, accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result)
    {

        NSString *lkId = result[@"id"];
        NSInteger connectionCount = [result[@"numConnections"] integerValue];
        NSLog(@"LinkedIn %@ connection count : %lu",lkId,(long)connectionCount);
        [self setupLKLevelWithLKId:lkId  connectionCount:connectionCount];
        
    }   failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failed to fetch current user %@", error);
    }];
}

- (LIALinkedInHttpClient *)linkedIn {
    LIALinkedInApplication *application = [LIALinkedInApplication
                                   applicationWithRedirectURL:@"https://localhost"
                                   clientId: @"75696l29jqbq3l"
                                   clientSecret:@"YYBB2iDxC63LjOhU"
                                   state:@"f**kRonAndMert"
                                   grantedAccess:@[@"r_basicprofile"]];
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:self];
}



-(void)setupLKLevelWithLKId:(NSString *)lkId connectionCount:(NSUInteger)connectionCount
{
     [Verification checkIfLKId:lkId hasBeenUsedWithCompletion:^(Verification *verification, NSError *error)
     {
         if (!error) {
             if (verification == nil || verification.objectId == self.currentUser.verification.objectId) {


                 self.currentUser.verification.lkId = lkId;
                 self.currentUser.verification.lkLevel = [Verification getLKLevelWithNumOfConnections:connectionCount];
                [self.currentUser saveInBackground];
                [self setupLKItems:self.currentUser.verification.lkLevel > 0];
                [self setupSafetyLevelItems];
                if (self.currentUser.verification.lkLevel == 0) {
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your LinkedIn connections number is not enough." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                }
                 
             } else {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"This LinkedIn account has been used to verify another user." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }
         } else {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
         }
         
     }];
    
}

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainTabBarVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mainTabBarVC animated:true completion:nil];
    
}

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainTabBarVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mainTabBarVC animated:true completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 0) {
        UIStoryboard *editProfileStoryboard = [UIStoryboard storyboardWithName:@"EditProfile" bundle:nil];
        UINavigationController *editProfileNavVC = [editProfileStoryboard instantiateViewControllerWithIdentifier:@"editProfileNavVC"];
        [self presentViewController:editProfileNavVC animated:true completion:nil];
    }
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
-(void)setUpDelegatesForTextFields{

    for (UITextField *txtFd in self.phoneNumberTextFields) {
        txtFd.delegate = self;
    }
}

//Declare a delegate, assign your textField to the delegate and then include these methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //NSUInteger index = [self.phoneNumberTextFields indexOfObject:textField];
    //((UIImageView *)self.phoneNumberCheckmarks[index]).isHidden;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-110,320,500)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.

}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,320,600)];
}

@end
