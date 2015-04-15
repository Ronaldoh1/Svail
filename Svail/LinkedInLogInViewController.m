//
//  LinkedInLogInViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "LinkedInLogInViewController.h"

@interface LinkedInLogInViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LinkedInLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://www.linkedin.com/uas/oauth2/authorization?client_id=75696l29jqbq3l&redirect_uri=https://localhost&response_type=code&state=mert"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


@end
