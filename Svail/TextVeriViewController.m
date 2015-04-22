//
//  TextVeriViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "TextVeriViewController.h"
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import "Verification.h"
#import "User.h"

@interface TextVeriViewController () <MFMessageComposeViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cellPhoneTextField1;
@property (weak, nonatomic) IBOutlet UITextField *cellPhoneTextField2;
@property (weak, nonatomic) IBOutlet UITextField *cellPhoneTextField3;

@end

@implementation TextVeriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellPhoneTextField1.placeholder = @"Enter cell phone number";
    self.cellPhoneTextField2.placeholder = @"Enter cell phone number";
    self.cellPhoneTextField3.placeholder = @"Enter cell phone number";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onSendRequestButtonTapped:(UIButton *)sender
{
    NSMutableArray *phoneNumbers = [NSMutableArray new];
    
    if (![self.cellPhoneTextField1.text isEqualToString:@""]) {
        [phoneNumbers addObject:self.cellPhoneTextField1.text];
    }
    
    if (![self.cellPhoneTextField2.text isEqualToString:@""]) {
        [phoneNumbers addObject:self.cellPhoneTextField2.text];
    }
    
    if (![self.cellPhoneTextField3.text isEqualToString:@""]) {
        [phoneNumbers addObject:self.cellPhoneTextField3.text];
    }
    
    
    NSString *message = [NSString stringWithFormat:@"Could you help your friend %@ complete a simple safety level check for using Svail?", [User currentUser].name];
    [self sendSMSFromParseWithToNumber:phoneNumbers[0] message:message];
    

    
//    [self showSMSWithMessage:message phoneNumbers:phoneNumbers];
}

- (void)showSMSWithMessage:(NSString*)message phoneNumbers:(NSArray *)phoneNumbers {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = phoneNumbers;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    
//        [PFCloud callFunctionInBackground:@"test"
//                       withParameters:nil
//                                block:^(NSString *result, NSError *error) {
//                                    if (!error) {
//                                        // result is @"Hello world!"
//                                        NSLog(@"%@",result);
//                                    }
//                                }];

}


- (IBAction)onSkipButtonTapped:(UIButton *)sender
{
    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UIViewController *mapVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MapNavVC"];
    [self presentViewController:mapVC animated:true completion:nil];
}

@end
