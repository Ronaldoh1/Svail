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

@end

@implementation SelectLocationFromMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //setup color tint and title color
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor orangeColor]forKey:NSForegroundColorAttributeName];


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

//    //zoom to region
//    
//    MKMapPoint annotationPoint = MKMapPointForCoordinate(self.mapView.userLocation.location.coordinate);
//    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.5, 0.5);
//    [self.mapView setVisibleMapRect:zoomRect animated:false];
//
//

//    CLLocationCoordinate2D centerPointOfMap = CLLocationCoordinate2DMake(52.5, 13.4);
//    MKCoordinateSpan sizeOfMapToShow = MKCoordinateSpanMake(30, 30);
//    MKCoordinateRegion showMapRegion = MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate, sizeOfMapToShow);
//
//    [self.mapView setRegion:showMapRegion animated:YES];

//    MKCoordinateRegion region;
//    region.center = self.mapView.userLocation.location.coordinate;
//    MKCoordinateSpan span;
//    span.latitudeDelta  = 1;
//    span.longitudeDelta = 1;
//    region.span = span;
//    [self.mapView setRegion:region animated:YES];


}
-(void)viewDidAppear:(BOOL)animated{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:true];

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
    someAnnotation.title = @"Service Location";

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
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f))];

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
