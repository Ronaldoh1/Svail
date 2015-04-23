//
//  PaymentViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/17/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


//    PKPaymentRequest *request = [Stripe
//                                 paymentRequestWithMerchantIdentifier:@"merchant.com.Svail"];
//    // Configure your request here.
    NSString *label = @"Premium Turkish Food";
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"10.00"];
//    request.paymentSummaryItems = @[
//                                    [PKPaymentSummaryItem summaryItemWithLabel:label
//                                                                        amount:amount]
//                                    ];
//
//    if ([Stripe canSubmitPaymentRequest:request]) {

//    } else {
        // Show the user your own credit card form (see options 2 or 3)
//    }



}
// ViewController.m

//- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
//                       didAuthorizePayment:(PKPayment *)payment
//                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {
//    /*
//     We'll implement this method below in 'Creating a single-use token'.
//     Note that we've also been given a block that takes a
//     PKPaymentAuthorizationStatus. We'll call this function with either
//     PKPaymentAuthorizationStatusSuccess or PKPaymentAuthorizationStatusFailure
//     after all of our asynchronous code is finished executing. This is how the
//     PKPaymentAuthorizationViewController knows when and how to update its UI.
//     */
//    //[self handlePaymentAuthorizationWithPayment:payment completion:completion];
//}

//- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


@end
