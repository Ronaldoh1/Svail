//
//  PostDetailViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PostDetailViewController.h"
#import "SelectLocationFromMapViewController.h"
#import "PostHistoryViewController.h"

@interface PostDetailViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *EditSaveButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *startPickerDate;
@property (weak, nonatomic) IBOutlet UITextField *serviceDescription;
@property (weak, nonatomic) IBOutlet UITextField *serviceCategory;
@property (weak, nonatomic) IBOutlet UITextField *serviceCapacity;

@property (weak, nonatomic) IBOutlet UITextField *serviceLocation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *canHostSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *endDateView;

@property (weak, nonatomic) IBOutlet UIView *startDateView;
@property (weak, nonatomic) IBOutlet UITextField *serviceTitle;
@property (weak, nonatomic) IBOutlet UIDatePicker *endPickerDate;
@property (weak, nonatomic) IBOutlet UIButton *setLocationButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property Service *theServicefromParse;
@property PFGeoPoint *tempGeoPoint;
@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //self.service = [Service new];

    //transform the date pickers.
    self.startPickerDate.transform = CGAffineTransformMakeScale(0.80, 0.65);
    self.endPickerDate.transform = CGAffineTransformMakeScale(0.80, 0.65);

    //initially disable the textfields.

    self.serviceTitle.enabled = false;
    self.serviceDescription.enabled = false;
    self.serviceCategory.enabled = false;
    self.serviceCapacity.enabled = false;
    self.serviceLocation.enabled = false;
    self.canHostSegmentedControl.enabled = false;
    self.startPickerDate.enabled = false;
    self.endPickerDate.enabled = false;
    self.setLocationButton.enabled = false;
    self.doneButton.enabled = false;
    self.startDateView.userInteractionEnabled = false;
    self.endPickerDate.userInteractionEnabled = false;

    //initialize the service to view and edit.

    //self.theServiceomParse = [Service new];

    PFQuery *query = [Service query];

    //[query whereKeyExists:self.serviceToViewEdit.objectId];

    [query getObjectInBackgroundWithId:self.serviceToViewEdit.objectId block:^(PFObject *object, NSError *error) {

        self.theServicefromParse = ((Service *)object);

        //set the textfields to the values of the object from parse.
        self.serviceTitle.text = self.theServicefromParse.title;
        self.serviceDescription.text = self.theServicefromParse.serviceDescription;
        self.serviceCategory.text = self.theServicefromParse.category;
        self.serviceCapacity.text = [NSString stringWithFormat:@"%@", self.theServicefromParse.capacity];
        self.serviceLocation.text = self.theServicefromParse.serviceLocationAddress;

        self.tempGeoPoint = [PFGeoPoint new];
        self.tempGeoPoint = self.theServicefromParse.theServiceGeoPoint;


        //set the segmented controller
        if (self.theServicefromParse.travel == true) {
            [self.canHostSegmentedControl setSelectedSegmentIndex:1];
        }else{
            [self.canHostSegmentedControl setSelectedSegmentIndex:0];
        }
        //set date pickers.

        [self.startPickerDate setDate:self.theServicefromParse.startDate];
        [self.endPickerDate setDate:self.theServicefromParse.endDate];




        NSLog(@"%@", ((Service *)object).title);

    }];



    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@", self.serviceToViewEdit.title);
}
- (IBAction)EditSaveButton:(UIBarButtonItem *)sender {


    if ([sender.title isEqualToString:@"Edit"]) {
        sender.title = @"Save";

        self.serviceTitle.enabled = true;
        self.serviceDescription.enabled = true;
        self.serviceCategory.enabled = true;
        self.serviceCapacity.enabled = true;
        self.serviceLocation.enabled = true;
        self.canHostSegmentedControl.enabled = true;
        self.startPickerDate.enabled = true;
        self.endPickerDate.enabled = true;
        self.setLocationButton.enabled = true;
        self.doneButton.enabled = true;
        self.startDateView.userInteractionEnabled = true;
        self.endPickerDate.userInteractionEnabled = true;


       // self.service.provider = @"Ronaldoh1";
        self.theServicefromParse.title = self.serviceTitle.text;
        self.theServicefromParse.serviceDescription = self.serviceDescription.text;
        self.theServicefromParse.category = self.serviceCategory.text;
        self.theServicefromParse.capacity = ((NSNumber *)self.serviceCapacity.text);
        self.theServicefromParse.serviceLocationAddress = self.serviceLocation.text;
        self.theServicefromParse.startDate = [self.startPickerDate date];
        self.theServicefromParse.endDate = [self.endPickerDate date];

        if (self.canHostSegmentedControl.selectedSegmentIndex == 0) {
            self.theServicefromParse.travel = false;
        }else if (self.canHostSegmentedControl.selectedSegmentIndex == 1){
            self.theServicefromParse.travel = true;
        }

        [self.theServicefromParse saveInBackground];
        //save the geopoint

        //self.theServicefromParse.theServiceGeoPoint = self.serviceGeoPoint;





    }else{
        sender.title = @"Edit";
        self.serviceTitle.enabled = false;
        self.serviceDescription.enabled = false;
        self.serviceCategory.enabled = false;
        self.serviceCapacity.enabled = false;
        self.serviceLocation.enabled = false;
        self.canHostSegmentedControl.enabled = false;

        self.startPickerDate.enabled = false;
        self.endPickerDate.enabled = false;
        self.setLocationButton.enabled = false;
        self.doneButton.enabled = false;
        self.startDateView.userInteractionEnabled = false;
        self.endPickerDate.userInteractionEnabled = false;

        
    }

    if([sender.title isEqualToString:@"Edit"]){
        //Indicator starts annimating when signing up.


        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.color = [UIColor colorWithRed:102 green:0 blue:255 alpha:1];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.view addSubview: activityIndicator];

        [activityIndicator startAnimating];
        [self.theServicefromParse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

            //stop actiivity indication from annimating.
            [activityIndicator stopAnimating];


            if (!error) {
                ///[self displaySuccessMessage:@"You Service has been updated!"];

                // [self performSegueWithIdentifier:@"toSelectImageVC" sender:self];
            }else{
                [self displayErrorAlert:error.localizedDescription];


                
                
            }
        }];
    }
}

- (IBAction)setNewLocationButton:(UIButton *)sender {

//    [self performSegueWithIdentifier:@"toChangeLocationOfService" sender:self];
    
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    SelectLocationFromMapViewController *selectLocationVC = segue.destinationViewController;

   selectLocationVC.serviceGeoPointToEdit = self.tempGeoPoint;

    selectLocationVC.editModeLocation = true;



}


-(IBAction)unwindSegueFromSelectLocationToDetailVC:(UIStoryboardSegue *)segue{

    if ([segue.sourceViewController isKindOfClass:[SelectLocationFromMapViewController class]]) {
        SelectLocationFromMapViewController *selectLocationVC = [segue sourceViewController];
        // if the user clicked Cancel, we don't want to change the color
        //self.serviceGeoPoint = [PFGeoPoint new];

        PFGeoPoint *newGeoPoint = [PFGeoPoint new];
        newGeoPoint.latitude = selectLocationVC.serviceGeoPointToEdit.latitude;
        newGeoPoint.longitude = selectLocationVC.serviceGeoPointToEdit.longitude;

        NSLog(@"%f heerrreeeeeeeeee", selectLocationVC.serviceGeoPointToEdit.latitude);

        self.theServicefromParse.theServiceGeoPoint = newGeoPoint;
        self.serviceLocation.text = selectLocationVC.userLocation;

        self.theServicefromParse.serviceLocationAddress = self.serviceLocation.text;

        [self.theServicefromParse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"it saveddddddddd!");
            }
        }];

      //  NSLog(@"%f %f", self.serviceGeoPoint.longitude, self.serviceGeoPoint.latitude);
    }
}




@end
