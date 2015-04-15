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


@interface SocialVeriViewController ()

@end

@implementation SocialVeriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
//        // play with Twitter session
//    }];
//    logInButton.center = self.view.center;
//    [self.view addSubview:logInButton];
    
    TWTRLogInButton* logInButton =  [TWTRLogInButton
         buttonWithLogInCompletion:
         ^(TWTRSession* session, NSError* error) {
             if (session) {
                 NSLog(@"signed in as %@", [session userName]);
                 NSString *twitterUserID = [[Twitter sharedInstance] session].userID;
//                 NSURLRequest *followersQueryRequest = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:followersQueryURL parameters:followersQueryParameters error:nil];
//                 
                 
             } else {
                 NSLog(@"error: %@", [error localizedDescription]);
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
         }];

    
    logInButton.center = self.view.center;
    [self.view addSubview:logInButton];
//    
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
//    
   

}

- (IBAction)twitterVerifyButton:(UIButton *)sender
{
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         if (session) {
             NSLog(@"signed in as %@", [session userName]);
         } else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}

@end
