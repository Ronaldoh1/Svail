//
//  PurchaseViewController.m
//  
//
//  Created by Ronald Hernandez on 6/15/15.
//
//

#import "SubscriptionViewController.h"
#import "PurchaseViewController.h"

@interface SubscriptionViewController ()

@property (strong, nonatomic) PurchaseViewController *purchaseController;

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.disclosureLabel.font = [UIFont fontWithName:@"Noteworthy" size:20];
    self.disclosureLabel.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];


}


- (IBAction)onPurchaseButtonTapped:(UIButton *)sender {


    self.purchaseController = [[PurchaseViewController alloc] initWithNibName:nil bundle:nil];
    self.purchaseController.productID = @"com.svail.svail.premium";

    [[SKPaymentQueue defaultQueue]  addTransactionObserver:self.purchaseController];
    //then present the view controller
    [self presentViewController:self.purchaseController animated:YES completion:nil];

    [self.purchaseController getProductID:self];



}




@end
