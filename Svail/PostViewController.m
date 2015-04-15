//
//  PostViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PostViewController.h"
#import "Image.h"
#import <Parse/Parse.h>
#import "Service.h"
#import "User.h"



@interface PostViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *serviceTitle;
@property (weak, nonatomic) IBOutlet UITextField *serviceDescription;
@property (weak, nonatomic) IBOutlet UITextField *serviceCategory;
@property (weak, nonatomic) IBOutlet UITextField *serviceCapacity;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *availability;

@property Service *service;

@property (weak, nonatomic) IBOutlet UIDatePicker *startPickerDate;

@property (weak, nonatomic) IBOutlet UIDatePicker *endPickerDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlPicker;

@property User *currentUser;


@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.service = [Service new];
    self.startPickerDate.transform = CGAffineTransformMakeScale(0.65, 0.5);
    self.endPickerDate.transform = CGAffineTransformMakeScale(0.65, 0.5);


}

- (IBAction)onBackButtonTapped:(UIBarButtonItem *)sender {
    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UIViewController *mapTabVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mapTabVC animated:true completion:nil];
}




- (IBAction)onPostButtonTapped:(UIBarButtonItem *)sender {

    NSString *errorMessage = @"Error in from. Please note - All fields are required";

    // if ([self.serviceTitle.text isEqualToString:@""] || [self.serviceDescription.text isEqualToString:@""] || [self.serviceCategory.text isEqualToString:@""] || [self.serviceCapacity.text isEqualToString:@""] || [self.location.text isEqualToString:@""]) {
    //
    //        [self displayErrorAlert:errorMessage];
    //
    //
    //    }else{

    //MARK - Save Service information
    //    self.currentUser = [User new];
    //    self.currentUser.username = @"bitchesBeLike";
    //[self.currentUser setSessionToken:@"fsafsafafa"];

    //  [self.currentUser save];
    self.service.provider = @"Ronaldoh1";
    self.service.title = self.serviceTitle.text;
    self.service.description = self.serviceDescription.text;
    self.service.category = self.serviceCategory.text;
    self.service.capacity = ((NSNumber *)self.serviceCapacity.text);
    self.service.location = self.location.text;
    if (self.segmentedControlPicker.selectedSegmentIndex == 0) {
        self.service.travel = false;
    }else if (self.segmentedControlPicker.selectedSegmentIndex == 1){
        self.service.travel = true;
    }

    //Indicator starts annimating when signing up.
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.color = [UIColor colorWithRed:102 green:0 blue:255 alpha:1];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];

    [activityIndicator startAnimating];
    [self.service saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        //stop actiivity indication from annimating.
        [activityIndicator stopAnimating];


        if (!error) {
            [self displaySuccessMessage:@"You Service has been posted"];

            [self performSegueWithIdentifier:@"toSelectImageVC" sender:self];
        }else{
            [self displayErrorAlert:error.localizedDescription];




        }
    }];



}



//hide keyboard when user touches outside.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



//Helper method to display error to user.
-(void)displayErrorAlert:(NSString *)error{


    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error in form" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [alertView show];

}

//Helper method to display success message to user.
-(void)displaySuccessMessage:(NSString *)text{


    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success!" message:text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}





@end
