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



@interface SocialVeriViewController () <UITextFieldDelegate>

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
     self.currentUser = [User currentUser];
    
    self.view.hidden = YES;
    [self.fbVerifyButton setNeedsDisplay];
    [self.ttVerifyButton setNeedsDisplay];
    [self.lkVerifyButton setNeedsDisplay];
    
    if (!self.currentUser.verification) {
        self.view.hidden = NO;
        self.currentUser.verification = [Verification object];
        [self.currentUser saveInBackground];
        [self showFBItems:NO];
        [self showTTItems:NO];
        [self showLKItems:NO];
            
        [self showPhoneNumberItems];
        [self showSafetyLevelItems];
           
    } else {
        PFQuery *query = [User query];
        [query includeKey:@"verification.references"];
        [query getObjectInBackgroundWithId:self.currentUser.objectId block:^(PFObject *user, NSError *error)
        {
            self.view.hidden = NO;
            self.currentUser = (User *)user;
            NSLog(@"%li",self.currentUser.verification.fbLevel);
            NSLog(@"%li",self.currentUser.verification.ttLevel);
            NSLog(@"%li",self.currentUser.verification.lkLevel);
            NSLog(@"%li",self.currentUser.verification.references.count);
            [self showFBItems:self.currentUser.verification.fbLevel > 0];
            [self showTTItems:self.currentUser.verification.ttLevel > 0];
            [self showLKItems:self.currentUser.verification.lkLevel > 0];
            
            [self showPhoneNumberItems];
            [self showSafetyLevelItems];
        }];
    }
}


-(void)showSafetyLevelItems
{
    if (self.currentUser.verification.hasReachedSafeLevel) {
        self.safetyCheckmark.alpha = 1.0;
    } else {
        self.safetyCheckmark.alpha = kAlphaForSafetyCheckmarkUnqualified;
    }
    
    Verification *verification = self.currentUser.verification;
    verification.safetyLevel = [verification calculateSafetyLevel];
     [verification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (succeeded) {
             NSLog(@"%li",verification.safetyLevel);
         } else {
             NSLog(@"%li",verification.safetyLevel);
         }
     }];
    
    self.levelLabel.text = [NSString stringWithFormat:@"Verification Level : %li", self.currentUser.verification.safetyLevel];
    [verification saveInBackground];
}

-(void)showFBItems:(BOOL)isVerified
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

-(void)showTTItems:(BOOL)isVerified
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

-(void)showLKItems:(BOOL)isVerified
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

-(void)showPhoneNumberItems
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSUInteger index = [self.phoneNumberTextFields indexOfObject:textField];
    return ((UIImageView *)self.phoneNumberCheckmarks[index]).isHidden;
}

- (IBAction)onRequestButtonTapped:(UIButton *)sender
{
    
    NSString *message = [NSString stringWithFormat:@"Could you help your friend %@ complete a simple safety level check for using Svail?", [User currentUser].name];
    
    for (int i = 0; i < 3 - self.currentUser.verification.references.count; i++) {
        UITextField *textField = self.phoneNumberTextFields[i];
        if (![textField.text isEqualToString:@""]) {
            [self sendSMSFromParseWithToNumber:textField.text message:message];
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
                                        NSLog(@"%@",result);
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
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSUInteger friendsCount = [result[@"summary"][@"total_count"] integerValue];
                             NSLog(@"facebook friends count : %li", friendsCount);
                             self.currentUser.verification.fbLevel = [Verification getFBLevelWithNumOfFriends:friendsCount];
                             [self.currentUser saveInBackground];
                             [self showFBItems:self.currentUser.verification.fbLevel > 0];
                             [self showSafetyLevelItems];
                            
                         }
                     }];
                }
            }
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
                 NSLog(@"Twitter followers count : %li",followersCount);
                 self.currentUser.verification.ttLevel = [Verification getTTLevelWithNumOfFollowers:followersCount];
                 [self.currentUser saveInBackground];
                 [self showTTItems:self.currentUser.verification.ttLevel > 0];
                 [self showSafetyLevelItems];

             }
             else {
                 NSLog(@"Error: %@", connectionError);
             }
         }];
    } else {
        NSLog(@"Error: %@", clientError);
    }
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
    NSString *queryURLString = @"https://api.linkedin.com/v1/people/~:(num-connections)";
    [self.linkedIn GET:[NSString stringWithFormat:@"%@?oauth2_access_token=%@&format=json",queryURLString, accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result)
    {
        NSLog(@"LinkedIn connection count : %@", result[@"numConnections"]);
        NSInteger numOfConnections = [result[@"numConnections"] integerValue];
        self.currentUser.verification.lkLevel = [Verification getTTLevelWithNumOfFollowers:numOfConnections];
        [self.currentUser saveInBackground];
        [self showLKItems:self.currentUser.verification.lkLevel > 0];
        [self showSafetyLevelItems];
        
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
                                   grantedAccess:@[@"r_fullprofile", @"r_network"]];
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:self];
}

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender
{
    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UIViewController *mapVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MapNavVC"];
    [self presentViewController:mapVC animated:true completion:nil];
    
}

@end
