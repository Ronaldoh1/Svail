//
//  SelectLocationFromMapViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/15/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "SelectLocationFromMapViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Service.h"


@interface SelectLocationFromMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *servicePoint;
@property BOOL isAnnotationSet;
@property PFGeoPoint *serviceGeoPoint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property NSString *latLong;
@property BOOL didGetUserLocation;

@end

@implementation SelectLocationFromMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //initial setup
    [self initialSetUp];



}
-(void)viewDidAppear:(BOOL)animated{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:true];
   // [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f))];

    //zooming map to current location at startup
    double latitude = self.locationManager.location.coordinate.latitude;
    double longitude = self.locationManager.location.coordinate.longitude;

    [self zoom:&latitude :&longitude];
}

//Helper method for initial set up
-(void)initialSetUp{

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:15];
    titleView.text = @"Press & Hold to Set Location";
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];

    //initially we should set the didGetUserLocation to false;
    self.didGetUserLocation = false;

    //setup color tint and title color
    self.navigationController.navigationBar.tintColor = //setup color tint
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];



    if (self.editModeLocation == true) {
        //self.editModeLocation = false;

        self.doneBarButton.enabled = false;
        self.doneBarButton.tintColor = [UIColor clearColor];


        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.mapView.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        self.mapView.showsUserLocation = true;

        //set to true so that user cannot add another pin... he will only be able to drag.
        self.isAnnotationSet = true;

        [self.mapView addAnnotation:self.servicePoint];


        PFQuery *query = [Service query];

        [query getObjectInBackgroundWithId:@"OnGxGqBfwI" block:^(PFObject *object, NSError *error) {
            NSLog(@"%@", ((Service* )object));
        }];

        // self.serviceGeoPointToEdit = [PFGeoPoint new];

        CLLocationCoordinate2D coordinate  = CLLocationCoordinate2DMake(self.serviceGeoPointToEdit.latitude, self.serviceGeoPointToEdit.longitude);

        MKPointAnnotation *someAnnotation = [MKPointAnnotation new];
        someAnnotation.coordinate = coordinate;
        someAnnotation.title = @"Old Location";


        [self.mapView addAnnotation:someAnnotation];

    } else if(self.editModeLocation == false){




        //set the current annotation to false
        self.isAnnotationSet = false;

        // Do any additional setup after loading the view.


        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.mapView.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        self.mapView.showsUserLocation = true;




        [self.mapView addAnnotation:self.servicePoint];

        //set the goepoint
        self.serviceGeoPoint = [PFGeoPoint new];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        longPressRecognizer.minimumPressDuration = 1.0;
        [self.mapView addGestureRecognizer:longPressRecognizer];
        
    }
}
//helper method to zoom in

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

//helper method to recognize the user's tap.

-(void)tapAction:(UIGestureRecognizer*)gestureRec{


    if (self.isAnnotationSet == false) {
        self.isAnnotationSet = true;
    //get the location where the user taps.
    CGPoint touchPoint = [gestureRec locationInView:self.mapView];
    CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    MKPointAnnotation *someAnnotation = [MKPointAnnotation new];
    someAnnotation.coordinate = newCoordinate;
    someAnnotation.title = @"Press & Hold to Move";

        self.serviceGeoPointFromMap = [PFGeoPoint new];
        self.serviceGeoPointFromMap.latitude = newCoordinate.latitude;
        self.serviceGeoPointFromMap.longitude = newCoordinate.longitude;
        
        [self.mapView addAnnotation:someAnnotation];


        NSString *latLong = [NSString stringWithFormat:@"%f,%f", newCoordinate.latitude, newCoordinate.longitude];


       self.userLocation = [self getAddressFromLatLong:latLong];

    }

}


-(NSString*)getAddressFromLatLong : (NSString *)latLng {
    //  NSString *string = [[Address.text stringByAppendingFormat:@"+%@",cityTxt.text] stringByAppendingFormat:@"+%@",addressText];
    NSString *esc_addr =  [latLng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    NSMutableDictionary *data = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *dataArray = (NSMutableArray *)[data valueForKey:@"results" ];
    if (dataArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter a valid address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        for (id firstTime in dataArray) {
            NSString *jsonStr1 = [firstTime valueForKey:@"formatted_address"];
            return jsonStr1;
        }
    }

    return nil;
}

#pragma Mark - MapView Delegate Methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if(!self.didGetUserLocation){

        //zooming map to current location at startup
        double latitude = self.locationManager.location.coordinate.latitude;
        double longitude = self.locationManager.location.coordinate.longitude;
        [self.locationManager stopUpdatingLocation];

        [self zoom:&latitude :&longitude];

        self.didGetUserLocation = true;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }



    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    pinAnnotation.canShowCallout = YES;
    pinAnnotation.draggable = YES;
    //pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pinAnnotation;
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self.locationManager startUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {


        CLLocationCoordinate2D newCoordinate = view.annotation.coordinate;
        NSLog(@"dropped at %f,%f", newCoordinate.latitude, newCoordinate.longitude);


        self.latLong = [NSString stringWithFormat:@"%f,%f", newCoordinate.latitude, newCoordinate.longitude];

        self.serviceGeoPointToEdit = [PFGeoPoint new];
        self.serviceGeoPointToEdit.latitude = newCoordinate.latitude;
        self.serviceGeoPointToEdit.longitude = newCoordinate.longitude;
        self.userLocation = [self getAddressFromLatLong:self.latLong];
    }
}







@end
