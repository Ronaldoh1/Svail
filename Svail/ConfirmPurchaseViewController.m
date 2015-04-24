//
//  ConfirmPurchaseViewController.m
//  Svail
//
//  Created by zhenduo zhu on 4/22/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "ConfirmPurchaseViewController.h"
#import "PTKView.h"
#import "Stripe+ApplePay.h"
#import <Parse/Parse.h>


@interface ConfirmPurchaseViewController () <PTKViewDelegate, PKPaymentAuthorizationViewControllerDelegate>
@property (nonatomic) PTKView *paymentView;

@end

@implementation ConfirmPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [super viewDidLoad];


    self.paymentView = [[PTKView alloc] initWithFrame:CGRectMake(15,20,290,55)];
    self.paymentView.center = self.view.center;
    self.paymentView.delegate = self;
    [self.view addSubview:self.paymentView];
    
}

- (IBAction)save:(id)sender
{
    STPCard *card = [[STPCard alloc] init];
    card.number = self.paymentView.card.number;
    card.expMonth = self.paymentView.card.expMonth;
    card.expYear = self.paymentView.card.expYear;
    card.cvc = self.paymentView.card.cvc;

    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {

                                              if (error) {
                                                  NSLog(@"%@",error);

                                                  [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                              message:error.localizedDescription                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil] show];

                                              } else {
                                                  NSString *myVal = token.tokenId;
                                                  NSLog(@"%@",token);
                                                  [PFCloud callFunctionInBackground:@"hello" withParameters:@{@"token":myVal}
                                                                              block:^(NSString *result, NSError *error) {
                                                                                  if (!error) {
                                                                                      NSLog(@"from Cloud Code Res: %@",result);
                                                                                  }
                                                                                  else
                                                                                  {
                                                                                      NSLog(@"from Cloud Code: %@",error);
                                                                                  }

                                                                              }];
                                                  
                                              };
                                          }];
    
    
}
- (IBAction)purchaseWithApplePayButton:(UIButton *)sender {



    PKPaymentRequest *request = [Stripe
                            paymentRequestWithMerchantIdentifier:@"merchant.com.Svail.Svail"];

    //TO-DO - NEED TO SET THE TITLE OF SERVICE HERE.
    NSString *label = @"Item for purchase "; //This text will be displayed in the Apple Pay authentication view after the word "Pay"
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"1.00"]; //Can change to any amount
    request.paymentSummaryItems = @[
                                    [PKPaymentSummaryItem summaryItemWithLabel:label
                                                                        amount:amount]
                                    ];

    if ([Stripe canSubmitPaymentRequest:request]) {
        PKPaymentAuthorizationViewController *auth = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        auth.delegate = self;

        [self presentViewController:auth animated:YES completion:nil];
    }

}

- (void)handlePaymentAuthorizationWithPayment:(PKPayment *)payment
                                   completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    [[STPAPIClient sharedClient] createTokenWithPayment:payment
                                             completion:^(STPToken *token, NSError *error) {
                                                 if (error) {
                                                     completion(PKPaymentAuthorizationStatusFailure);



                                                     return;
                                                 }
                                                 /*
                                                  We'll implement this below in "Sending the token to your server".
                                                  Notice that we're passing the completion block through.
                                                  See the above comment in didAuthorizePayment to learn why.

                                                  */

                                                 NSString *someToken = [NSString stringWithFormat:@"%@",token.tokenId];
                                                  NSDictionary *chargeParams = @{@"token": someToken};

                                                 [PFCloud callFunctionInBackground:@"hello"
                                                                    withParameters:chargeParams
                                                                             block:^(id object, NSError *error) {
                                                                                 if (!error) {
                                                                                       NSLog(@"%@", object);
                                                                                     completion(PKPaymentAuthorizationStatusSuccess);


                                                                                 }

                                                                             }];
                                             }];

}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    /*
     We'll implement this method below in 'Creating a single-use token'.
     Note that we've also been given a block that takes a
     PKPaymentAuthorizationStatus. We'll call this function with either
     PKPaymentAuthorizationStatusSuccess or PKPaymentAuthorizationStatusFailure
     after all of our asynchronous code is finished executing. This is how the
     PKPaymentAuthorizationViewController knows when and how to update its UI.
     */
    [self handlePaymentAuthorizationWithPayment:payment completion:completion];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
