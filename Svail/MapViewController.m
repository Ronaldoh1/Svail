///  MapViewController.m
//  Svail
//
//  Created by Mert Akanay on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "EventLocationDownloader.h"
#import "Service.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UserProfileViewController.h"
#import "CustomPointAnnotation.h"
#import "ReviewReservationViewController.h"
#import "PurchaseHistoryViewController.h"
#import "CustomViewUtilities.h"
#import "EditProfileViewController.h"
#import "CustomImageView.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property CLLocationManager *locationManager;
@property CustomPointAnnotation *providerPoint;
@property CustomPointAnnotation *draggedAnnotation;
@property NSMutableArray *eventsArray;
@property NSMutableArray *searchResults;
@property NSMutableArray *filterArray;
@property NSArray *resultsArray;
@property NSArray *annotationArray;
@property NSMutableArray *serviceParticipants;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property BOOL didGetUserLocation;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupProfileButton];

    //initially we should set the didGetUserLocation to false;

    self.didGetUserLocation = false;


    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;

    CLLocation *currentLocation = self.locationManager.location;

    

    self.segmentedControl.tintColor = //setup color tint
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:20];
    titleView.text = @"SVAIL";
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];

    //setting today's date and the next days of the week for segmented control's titles
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd"];
    NSString *theDate = [dateFormat stringFromDate:currentDate];
    [self.segmentedControl setTitle:theDate forSegmentAtIndex:0];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [NSDateComponents new];

//    self.currentLocationButton.layer.cornerRadius = self.currentLocationButton.frame.size.height / 2;
//    self.currentLocationButton.layer.masksToBounds = YES;
//    self.currentLocationButton.layer.borderWidth = 1.0;
//    self.currentLocationButton.layer.borderColor = [UIColor grayColor];
//    self.currentLocationButton.clipsToBounds = YES;


    for (int i = 1; i < 7; i++) {
        dayComponent.day = i;
        NSDate *nextDay = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
        NSString *nextDayDate = [dateFormat stringFromDate:nextDay];
        [self.segmentedControl setTitle:nextDayDate forSegmentAtIndex:i];
    }

    //change tint for the map view controller
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    //making segmentedcontrol selected when the view loads
    self.segmentedControl.selected = YES;

    //dismissing keyboard when tapped outside searchBar
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    //download Services from Parse and filter it according to today's event
    [EventLocationDownloader downloadEventLocationForLocation:currentLocation withCompletion:^(NSArray *array)
     {
         self.eventsArray = [NSMutableArray arrayWithArray:array];
         [self filterEventsForDate:self.segmentedControl];
     }];
}

-(void)viewWillAppear:(BOOL)animated
{



    //zooming map to current location at startup
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:true];


}
-(void)viewDidAppear:(BOOL)animated{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:true];
    // [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f))];

}


- (void)setupProfileButton
{
    [[User currentUser].profileImage getDataInBackgroundWithBlock:^(NSData *data,
                                                                  NSError *error)
     {
         if (!error) {
             UIImage *profileImage = [UIImage imageWithData:data];
            CGRect buttonFrame = CGRectMake(0, 0, 40., 40.);
            UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
             
            [CustomViewUtilities transformToCircleViewFromSquareView:button];

//            [button addTarget:self action:@selector(onProfileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:profileImage forState:UIControlStateNormal];

             UIView *profileButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
             profileButtonView.bounds = CGRectOffset(profileButtonView.bounds, 10, 0);
             [profileButtonView addSubview:button];
             UIBarButtonItem *profileButtonItem= [[UIBarButtonItem alloc] initWithCustomView:profileButtonView];
             profileButtonItem.enabled = NO;
             self.navigationItem.leftBarButtonItem=profileButtonItem;

         }
     }];
}

#pragma Mark - Dismiss Keyboard Method

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
    [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma Mark - Helper Method to add Annotations on Map

-(void)addAnnotationToMapFromArray:(NSArray *)array
{
    //converting GeoPoint stored on Parse to coordinate and adding the annotation on map
    for (Service *aService in array) {

        PFGeoPoint *serviceGeoPoint = [aService objectForKey:@"theServiceGeoPoint"];
        double latitude = serviceGeoPoint.latitude;
        double longtitude = serviceGeoPoint.longitude;
        CLLocationCoordinate2D serviceCoordinate = CLLocationCoordinate2DMake(latitude, longtitude);
        CustomPointAnnotation *newAnnotation = [[CustomPointAnnotation alloc] init];
        newAnnotation.title = [aService objectForKey:@"title"];
        newAnnotation.coordinate = serviceCoordinate;
        newAnnotation.service = aService;

        if (self.serviceParticipants.count < [newAnnotation.service.capacity integerValue]/2)
        {
            newAnnotation.color = [UIColor colorWithRed:58/255.0 green:185/255.0 blue:255/255.0 alpha:1.0];
            newAnnotation.type = ZSPinAnnotationTypeTag;
        }
        else if (self.serviceParticipants.count >= [newAnnotation.service.capacity integerValue]/2 && self.serviceParticipants.count < [newAnnotation.service.capacity integerValue])
        {
            newAnnotation.color = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1.0];
            newAnnotation.type = ZSPinAnnotationTypeTag;
        }
        else if (self.serviceParticipants.count == [newAnnotation.service.capacity integerValue])
        {
            newAnnotation.color = [UIColor redColor];
            newAnnotation.type = ZSPinAnnotationTypeTag;
        }

        [self.mapView addAnnotation:newAnnotation];

    }
}

#pragma Mark - Helper Method to zoom to a defined span on Map

-(void)zoom:(double *)latitude :(double *)logitude
{
//    double delayInSeconds = 0.5;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//        {
            MKCoordinateRegion region;
            region.center.latitude = *latitude;
            region.center.longitude = *logitude;
            region.span.latitudeDelta = 0.05;
            region.span.longitudeDelta = 0.05;
            region = [self.mapView regionThatFits:region];
            [self.mapView setRegion:region animated:YES];
//        });
}

#pragma Mark - MKMapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    CustomPointAnnotation *customAnnotation = (CustomPointAnnotation *)annotation;

    ZSPinAnnotation *pinAnnotation = [[ZSPinAnnotation alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    if (annotation == mapView.userLocation) {
        return nil;
    }

    //making the pinAnnotation of user's location draggable
    //    if (annotation == mapView.userLocation || annotation == self.draggedAnnotation) {
    //        pinAnnotation.pinColor = MKPinAnnotationColorPurple;
    //        pinAnnotation.draggable = YES;
    //    }

    pinAnnotation.canShowCallout = YES;

    if (!(self.serviceParticipants.count == [customAnnotation.service.capacity integerValue]))
    {
        UIButton *requestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        requestButton.frame = CGRectMake(0, 0, 70, 20);
        [requestButton setTitle:@"Request" forState:UIControlStateNormal];
        [requestButton setTitleColor:[UIColor colorWithRed:100/255.0 green:233/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
        requestButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [requestButton.layer setBorderWidth:1];
        [requestButton.layer setBorderColor:[UIColor colorWithRed:100/255.0 green:233/255.0 blue:134/255.0 alpha:1.0].CGColor];
        pinAnnotation.rightCalloutAccessoryView = requestButton;
    }else if (self.serviceParticipants.count == [customAnnotation.service.capacity integerValue])
    {
        UILabel *fullLabel = [UILabel new];
        fullLabel.frame = CGRectMake(0, 0, 30, 20);
        fullLabel.text = @"Full";
        fullLabel.textColor = [UIColor colorWithRed:247/255.0 green:94/255.0 blue:89/255.0 alpha:1.0];
        pinAnnotation.rightCalloutAccessoryView = fullLabel;
    }

    pinAnnotation.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinAnnotation.annotationType = ZSPinAnnotationTypeTagStroke;
    pinAnnotation.annotationColor = customAnnotation.color;

    if (customAnnotation.service.travel == true) {
        if (self.serviceParticipants.count < [customAnnotation.service.capacity integerValue]/2)
        {
            UIImage *carImage = [UIImage imageNamed:@"bluecar"];
            CGSize scaledSize = CGSizeMake(30, 20);
            UIGraphicsBeginImageContext(scaledSize);
            [carImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            pinAnnotation.image = scaledImage;
        }
        else if (self.serviceParticipants.count >= [customAnnotation.service.capacity integerValue]/2 && self.serviceParticipants.count < [customAnnotation.service.capacity integerValue])
        {
            UIImage *carImage = [UIImage imageNamed:@"yellowcar"];
            CGSize scaledSize = CGSizeMake(30, 20);
            UIGraphicsBeginImageContext(scaledSize);
            [carImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            pinAnnotation.image = scaledImage;

        }
        else if (self.serviceParticipants.count == [customAnnotation.service.capacity integerValue])
        {
            UIImage *carImage = [UIImage imageNamed:@"redcar"];
            CGSize scaledSize = CGSizeMake(30, 20);
            UIGraphicsBeginImageContext(scaledSize);
            [carImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            pinAnnotation.image = scaledImage;
        }
    }

    PFQuery *serviceQuery = [Service query];
    [serviceQuery includeKey:@"provider"];
    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceQuery getObjectInBackgroundWithId:customAnnotation.service.objectId block:^(PFObject *object, NSError *error) {
        
        if (error) {
            return;
        }
        
        Service *service = (Service *)object;
        User *provider = service.provider;


        if (!(provider.profileImage == nil) || !(provider == nil)) {

            [provider.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    CGSize scaledSize = CGSizeMake(40, 40);
                    UIGraphicsBeginImageContext(scaledSize);
                    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
                    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    CustomImageView *imageView = [[CustomImageView alloc]initWithImage:scaledImage];
                    imageView.layer.cornerRadius = imageView.frame.size.height / 2;
                    imageView.layer.masksToBounds = YES;
                    imageView.layer.borderWidth = 1.5;
                    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
                    imageView.clipsToBounds = YES;
                    imageView.userInteractionEnabled = YES;
//                    imageView.service = service;
                    imageView.user = service.provider;
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onProfileImageTapped:)];
                    tapGesture.delegate = self;
                    [imageView addGestureRecognizer:tapGesture];
                    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
                    //    imageView.image = scaledImage;
                    pinAnnotation.leftCalloutAccessoryView = imageView;
                }
            }];

        }else
        {
            UIImage *image = [UIImage imageNamed:@"defaultimage"];
            CGSize scaledSize = CGSizeMake(40, 40);
            UIGraphicsBeginImageContext(scaledSize);
            [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CustomImageView *imageView = [[CustomImageView alloc]initWithImage:scaledImage];
            imageView.layer.cornerRadius = imageView.frame.size.height / 2;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 1.5;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
//            imageView.service = service;
            imageView.user = service.provider;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onProfileImageTapped:)];
            tapGesture.delegate = self;
            [imageView addGestureRecognizer:tapGesture];
            //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
            //    imageView.image = scaledImage;
            pinAnnotation.leftCalloutAccessoryView = imageView;
        }
    }];

    return pinAnnotation;

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    //getting new coordinate from dragged pin annotation
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D newCoordinate = view.annotation.coordinate;
        NSLog(@"dropped at %f,%f", newCoordinate.latitude, newCoordinate.longitude);
        self.draggedAnnotation = [CustomPointAnnotation new];
        self.draggedAnnotation.coordinate = newCoordinate;
        self.mapView.showsUserLocation = NO;
        [self.mapView addAnnotation:self.draggedAnnotation];

    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self.locationManager startUpdatingLocation];

}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(!self.didGetUserLocation){

    //zooming map to current location at startup
        
    double latitude = self.locationManager.location.coordinate.latitude;
    double longitude = self.locationManager.location.coordinate.longitude;
    [self.locationManager stopUpdatingLocation];

    [self zoom:&latitude :&longitude];

        self.didGetUserLocation = true;
    }
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

    CustomPointAnnotation *annotation = view.annotation;
//    if ([annotation.service objectForKey:@"participants"] == nil)
//    {
//        self.serviceParticipants = [NSMutableArray new];
//        annotation.service.participants = self.serviceParticipants;
//        [annotation.service saveInBackground];
//        
//    }
//    else
//    {
//        self.serviceParticipants = [annotation.service objectForKey:@"participants"];
//    }

    if (control == view.rightCalloutAccessoryView)
    {
        //THIS PART WILL CHANGE AFTER PURCHASE

//        [self.serviceParticipants addObject:[User currentUser]];
//        [annotation.service saveInBackground];
        UIStoryboard *reservationStoryboard = [UIStoryboard storyboardWithName:@"Reservation" bundle:nil];
        UIViewController *reviewReservationNavVC = [reservationStoryboard instantiateViewControllerWithIdentifier:@"ReviewReservationNavVC"];
        ReviewReservationViewController *reviewReservationVC = reviewReservationNavVC.childViewControllers[0];
        reviewReservationVC.serviceId = annotation.service.objectId;
        [self presentViewController:reviewReservationNavVC animated:TRUE completion:nil];
    }
}

#pragma Mark - Methods to filter Services with SegmentedControl and SearchBar

- (IBAction)segmentSelected:(UISegmentedControl *)sender
{
    [self filterEventsForDate:sender];
}

-(void)filterEventsForDate:(UISegmentedControl *)sender
{
    //removing all annotations from map
    self.annotationArray = self.mapView.annotations;
    [self.mapView removeAnnotations:self.annotationArray];

    self.filterArray = [NSMutableArray new];

    NSString *currentDate = [self.segmentedControl titleForSegmentAtIndex:sender.selectedSegmentIndex];

    for (Service *aService in self.eventsArray) {

        //changing the date format for date on Parse and storing it as a string
        NSDate *serviceDate = [aService objectForKey:@"startDate"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormat setDateFormat:@"MM/dd"];
        NSString *serviceDateString = [dateFormat stringFromDate:serviceDate];

        if ([serviceDateString isEqualToString:currentDate])
        {
            [self.filterArray addObject:aService];

            if ([self.searchBar.text isEqualToString:@""]) {
                [self addAnnotationToMapFromArray:self.filterArray];
            }
        }
    }
    [self.mapView reloadInputViews];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //removing all annotations from map
    self.annotationArray = self.mapView.annotations;
    [self.mapView removeAnnotations:self.annotationArray];

    self.searchResults = [NSMutableArray new];

    if (![searchBar.text isEqualToString:@""]) {

        for (Service *aService in self.filterArray) {
            if ([[aService objectForKey:@"title"] containsString:searchBar.text]) {

                [self.searchResults addObject:aService];
            }
        }
    }else{
        self.searchResults = self.filterArray;
    }
    [self addAnnotationToMapFromArray:self.searchResults];

    [searchBar resignFirstResponder];
}


#pragma Mark - Segue to Post Service View Controller

- (IBAction)onAddServiceButtonTapped:(UIBarButtonItem *)sender
{
    //        UIStoryboard *postStoryBoard = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    //        UIViewController *postVC = [postStoryBoard instantiateViewControllerWithIdentifier:@"PostNavBar"];
    //        [self presentViewController:postVC animated:true completion:nil];

    if ([User currentUser] != nil){

        //if the user has 14 or less posts allow him to post.
        if(([User currentUser].numberOfPosts <= 14) || ([User currentUser].isPremium == true)){


            NSLog(@"%d number of posts", [User currentUser].numberOfPosts);



        NSLog(@"the user is loggged in");

        UIStoryboard *postStoryBoard = [UIStoryboard storyboardWithName:@"Post" bundle:nil];

        UIViewController *postVC = [postStoryBoard instantiateViewControllerWithIdentifier:@"PostNavBar"];

        [self presentViewController:postVC animated:true completion:nil];


        }else{
        //else if the user has more than 14 posts - then present an alert view controller and allow him to purchase paid version of our app.
              [self displayNeedPremiumAlert];


        }

    }else {

        //        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];

        //        UIViewController *loginVC = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginNavVC"];

        //        [self presentViewController:loginVC animated:true completion:nil];

        [self presentActionSheetForLogInOrSignUp];


    }

}

- (IBAction)onCurrentLocationButtonTapped:(UIButton *)sender
{
    [self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
}


//- (IBAction)onProfileButtonTapped:(UIBarButtonItem *)sender
//{
//    UIStoryboard *editProfileStoryBoard = [UIStoryboard storyboardWithName:@"EditProfile" bundle:nil];
//    UIViewController *editProfileVC = [editProfileStoryBoard instantiateViewControllerWithIdentifier:@"editProfileNavVC"];
//    [self presentViewController:editProfileVC animated:true completion:nil];
//}

- (void)onProfileImageTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIStoryboard *userProfileStoryBoard = [UIStoryboard storyboardWithName:@"UserProfile" bundle:nil];
    UIViewController *userProfileNavVC = [userProfileStoryBoard instantiateViewControllerWithIdentifier:@"profileNavVC"];
    UserProfileViewController *userProfileVC = userProfileNavVC.childViewControllers[0];
    [self presentViewController:userProfileNavVC animated:true completion:nil];
    CustomImageView *imageView = (CustomImageView *)tapGestureRecognizer.view;
//    userProfileVC.selectedUser = imageView.service.provider;
    userProfileVC.selectedUser = imageView.user;

}


#pragma Mark - Unwind Segues

-(IBAction)unwindSegueFromLogInViewController:(UIStoryboardSegue *)segue

{

}

-(IBAction)unwindSegueFromRegisterViewController:(UIStoryboardSegue *)segue

{

}


#pragma Marks - Helper Methods

//actionSheets - this will handle the user's actions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{



    if (buttonIndex == 0) {

        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];

        UIViewController *loginVC = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginNavVC"];

        [self presentViewController:loginVC animated:true completion:nil];



    } else if(buttonIndex == 1){

        UIStoryboard *signUpStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];

        UIViewController *signUpVC = [signUpStoryBoard instantiateViewControllerWithIdentifier:@"SignUpNavVC"];

        [self presentViewController:signUpVC animated:true completion:nil];



    }else{

        NSArray *permissionsArray = @[ @"email", @"public_profile"];

        [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");

                //Present an alert when the user cancels the login

                NSString *alertMessage = @"There was a problem logging in. You must Svail to use your facebook account to log you in";

                NSString *alertTitle =@"Oops - Facebook Login was canceled";

                [[[UIAlertView alloc] initWithTitle:alertTitle

                                            message:alertMessage

                                           delegate:nil

                                  cancelButtonTitle:@"OK"

                                  otherButtonTitles:nil] show];

            } else if (user.isNew) {
                //if the user is new want to get his/her data and store it in parse.
                [self getFacebookUserData];

                //we also need to retrieve his profile picture.

                [self.navigationController reloadInputViews];
           


//                UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName:@"EditProfile" bundle:nil];
//                EditProfileViewController *editProfileVC = [profileStoryBoard instantiateViewControllerWithIdentifier:@"editProfileNavVC"];
//                [self presentViewController:editProfileVC animated:true completion:nil];



                NSLog(@"User signed up and logged in through Facebook!");




                NSLog(@"%@", user);
            } else {
                NSLog(@"User logged in through Facebook!");
            }
        }];



    }

}

//this helper method is used to retrieve the facebook data from the user and store in parse.
-(void)getFacebookUserData{

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // handle response
        [User currentUser].name = result[@"name"];
        [User currentUser].email = result[@"email"];
        [User currentUser].isFbUser = true;
        [[User currentUser] saveInBackground];


        [self getFbUserProfileImage:result[@"id"]];

    }];
}

//helper method to retrieve user's profile image from facebook..

-(void)getFbUserProfileImage:(id)facebookID{


    // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

    // Run network request asynchronously
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError == nil && data != nil) {
             // Set the image in the imageView
             // UIImage *image = [UIImage imageWithData:data];

             PFFile *file = [ PFFile fileWithData:data];

             [User currentUser].profileImage = file;

             [[User currentUser] saveInBackground];


             NSLog(@"%@", data);
         }
     }];
    
}

-(void)presentActionSheetForLogInOrSignUp{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sign in or Sign Up"
                                  
                                                             delegate:self
                                  
                                                    cancelButtonTitle:@"Cancel"destructiveButtonTitle:nil otherButtonTitles:@"Sign in", @"Sign Up", @"Login With Facebook", nil];

    //present the action sheet.
    [actionSheet showInView:self.view];
    
}
//Helper method to display error to user.
-(void)displayNeedPremiumAlert{


    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Your have posted 14 services for free" message:@"Would you like to keep posting? Go Premium!" delegate:self cancelButtonTitle:@"No, Thank You" otherButtonTitles:@"Let's Do it", nil];

    [alertView show];
    
}

//actionsheet delegate method.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == [alertView cancelButtonIndex]){

    }else{
        UIStoryboard *purchaseStoryBoard = [UIStoryboard storyboardWithName:@"Purchase" bundle:nil];
        UIViewController *confirmPurchase = [purchaseStoryBoard instantiateViewControllerWithIdentifier:@"purchasePremiumNavVC"];
        [self presentViewController:confirmPurchase animated:true completion:nil];
    }

}



@end
