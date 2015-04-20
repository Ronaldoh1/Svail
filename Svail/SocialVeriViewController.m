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



@interface SocialVeriViewController ()

@property (nonatomic) BOOL isUserVerified;
@property (nonatomic) LIALinkedInHttpClient *linkedIn;
@property (weak, nonatomic) IBOutlet UILabel *fbVeriLabel;
@property (weak, nonatomic) IBOutlet UILabel *ttVeriLabel;
@property (weak, nonatomic) IBOutlet UILabel *lkVeriLabel;
@property (nonatomic) User *currentUser;
@property (nonatomic) Verification *verification;


@end

@implementation SocialVeriViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fbVeriLabel.textColor = [UIColor lightGrayColor];
    self.fbVeriLabel.text = @"";
    self.ttVeriLabel.textColor = [UIColor lightGrayColor];
    self.ttVeriLabel.text = @"";
    self.lkVeriLabel.textColor = [UIColor lightGrayColor];
    self.lkVeriLabel.text = @"";
    
    self.currentUser = [User currentUser];
    if (!self.currentUser.verification) {
        self.currentUser.verification = [Verification object];
        [self.currentUser saveInBackground];
    }

    

    
    
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
                             if (self.currentUser.verification.fbLevel > 0) {
                                 self.fbVeriLabel.text = @"Pass";
                                 self.fbVeriLabel.textColor = [UIColor greenColor];
                             } else {
                                 self.fbVeriLabel.text = @"Not qualified";
                                 self.fbVeriLabel.textColor = [UIColor grayColor];
                             }
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
                 
                 if (self.currentUser.verification.ttLevel > 0) {
                     self.ttVeriLabel.text = @"Pass";
                     self.ttVeriLabel.textColor = [UIColor greenColor];
                 } else {
                     self.ttVeriLabel.text = @"Not qualified";
                     self.ttVeriLabel.textColor = [UIColor grayColor];
                 }

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
        
        if (self.currentUser.verification.lkLevel > 0) {
            self.lkVeriLabel.text = @"Pass";
            self.lkVeriLabel.textColor = [UIColor greenColor];
        } else {
            self.lkVeriLabel.text = @"Not qualified";
            self.lkVeriLabel.textColor = [UIColor grayColor];
        }
        
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



@end
