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

@property (nonatomic) BOOL isUserVerified;


@end

@implementation SocialVeriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}






- (IBAction)onTwitterVerifyButtonTapped:(UIButton *)sender
{
    
    if ([[Twitter sharedInstance] session]) {
        [self getTwitterFollowersCount];
        [self checkIsTwitterUserVerified];
        [[Twitter sharedInstance] logOut];
        
    } else {
        [[Twitter sharedInstance] logInWithCompletion:^
         (TWTRSession *session, NSError *error) {
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
}

-(void)checkIsTwitterUserVerified
{
    NSString *twitterUserID = [[Twitter sharedInstance] session].userID;
    [[[Twitter sharedInstance] APIClient] loadUserWithID:twitterUserID completion:^(TWTRUser *user, NSError *error) {
        if (!user.isVerified) {
            NSLog(@"User is not verified");
        } else {
            NSLog(@"User is verified");
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
         completion:^(NSURLResponse *response,
                      NSData *data,
                      NSError *connectionError) {
             if (data) {
                 // handle the response data e.g.
                 NSError *jsonError;
                 NSDictionary *json = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:0
                                       error:&jsonError];
                 NSArray *followerIDs = json[@"ids"];
                 NSLog(@"%li",followerIDs.count);
             }
             else {
                 NSLog(@"Error: %@", connectionError);
             }
         }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
}



- (IBAction)onLinkedInVerifyButtonTapped:(UIButton *)sender
{
}


@end
