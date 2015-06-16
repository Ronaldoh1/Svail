//
//  PurchaseViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 6/15/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PurchaseViewController.h"
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "SubscriptionViewController.h"
@interface PurchaseViewController ()
@property (strong, nonatomic) SubscriptionViewController *homeVC;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)onCancelButtonTapped:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onBuyButtonTapped:(id)sender {


}
- (IBAction)onRestoreButtonTapped:(id)sender {



}

-(void)getProductID:(UIViewController *)viewController{

    //here we are getting a reference to our homeVC (this is the subscriptionsVC).
    self.homeVC = (SubscriptionViewController *)viewController;
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productID]];
        request.delegate = self;

        [request start];

    }else{
        self.productDescriptionText.text = @"Please enable in app purchase in your settings";

    }

}


#pragma mark _
#pragma mark SKProductRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{

    NSArray *products = response.products;
    NSLog(@"%@", response.products);
    if (products.count != 0) {
        self.product= products[0];
        self.productTitle.text = self.product.localizedTitle;
        self.productDescriptionText.text = self.product.localizedDescription;
    }else{
        self.productTitle.text = @"Product not found";

    }

    products = response.invalidProductIdentifiers;


    for (SKProduct *product in products) {
        NSLog(@" product not found: %@", product);
    }

}
@end
