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

//PARTICIPANT NUMBER ADDED TO EVENT ? CHANGE PIN COLOR ACCORDINGLY
//SEARCH SERVICE ONLY AROUND THE CURRENT LOCATION OR DRAGGED LOCATION
//CALLOUT CUSTOMIZED

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *providerPoint;
@property MKPointAnnotation *draggedAnnotation;
@property NSMutableArray *eventsArray;
@property NSMutableArray *searchResults;
@property NSMutableArray *filterArray;
@property NSArray *resultsArray;
@property NSArray *annotationArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;

    //zooming map to current location at startup
    double latitude = self.locationManager.location.coordinate.latitude;
    double longitude = self.locationManager.location.coordinate.longitude;
    [self zoom:&latitude :&longitude];

    self.profileButton.image = [[User currentUser] objectForKey:@"profileImage"];

    //setting today's date and the next days of the week for segmented control's titles
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd"];
    NSString *theDate = [dateFormat stringFromDate:currentDate];
    [self.segmentedControl setTitle:theDate forSegmentAtIndex:0];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 1;
    NSDate *nextDay1 = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    NSString *nextDay1Date = [dateFormat stringFromDate:nextDay1];
    [self.segmentedControl setTitle:nextDay1Date forSegmentAtIndex:1];
    NSDate *nextDay2 = [calendar dateByAddingComponents:dayComponent toDate:nextDay1 options:0];
    NSString *nextDay2Date = [dateFormat stringFromDate:nextDay2];
    [self.segmentedControl setTitle:nextDay2Date forSegmentAtIndex:2];
    NSDate *nextDay3 = [calendar dateByAddingComponents:dayComponent toDate:nextDay2 options:0];
    NSString *nextDay3Date = [dateFormat stringFromDate:nextDay3];
    [self.segmentedControl setTitle:nextDay3Date forSegmentAtIndex:3];
    NSDate *nextDay4 = [calendar dateByAddingComponents:dayComponent toDate:nextDay3 options:0];
    NSString *nextDay4Date = [dateFormat stringFromDate:nextDay4];
    [self.segmentedControl setTitle:nextDay4Date forSegmentAtIndex:4];
    NSDate *nextDay5 = [calendar dateByAddingComponents:dayComponent toDate:nextDay4 options:0];
    NSString *nextDay5Date = [dateFormat stringFromDate:nextDay5];
    [self.segmentedControl setTitle:nextDay5Date forSegmentAtIndex:5];
    NSDate *nextDay6 = [calendar dateByAddingComponents:dayComponent toDate:nextDay5 options:0];
    NSString *nextDay6Date = [dateFormat stringFromDate:nextDay6];
    [self.segmentedControl setTitle:nextDay6Date forSegmentAtIndex:6];

    //making segmentedcontrol selected when the view loads
    self.segmentedControl.selected = YES;

    //dismissing keyboard when tapped outside searchBar
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    //download Services from Parse and filter it according to today's event
    [EventLocationDownloader downloadEventLocation:^(NSArray *array)
     {
         self.eventsArray = [NSMutableArray arrayWithArray:array];
         [self filterEventsForDate:self.segmentedControl];
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
        aService.annotation = [[MKPointAnnotation alloc] init];
        aService.annotation.title = [aService objectForKey:@"title"];
        aService.annotation.coordinate = serviceCoordinate;
        [self.mapView addAnnotation:aService.annotation];

    }
}

#pragma Mark - Helper Method to zoom to a defined span on Map

-(void)zoom:(double *)latitude :(double *)logitude
{
    MKCoordinateRegion region;
    region.center.latitude = *latitude;
    region.center.longitude = *logitude;
    region.span.latitudeDelta = 0.05;
    region.span.longitudeDelta = 0.05;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

#pragma Mark - MKMapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    //making the pinAnnotation of user's location draggable
    if (annotation == mapView.userLocation || annotation == self.draggedAnnotation) {
        pinAnnotation.pinColor = MKPinAnnotationColorPurple;
        pinAnnotation.draggable = YES;
    }
    pinAnnotation.canShowCallout = YES;
    pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];

    return pinAnnotation;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    //getting new coordinate from dragged pin annotation
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D newCoordinate = view.annotation.coordinate;
        NSLog(@"dropped at %f,%f", newCoordinate.latitude, newCoordinate.longitude);
        self.draggedAnnotation = [MKPointAnnotation new];
        self.draggedAnnotation.coordinate = newCoordinate;
        self.mapView.showsUserLocation = NO;
        [self.mapView addAnnotation:self.draggedAnnotation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self.locationManager startUpdatingLocation];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //segue to request controller
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

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    for (CLLocation *location in locations) {
//        if (location.verticalAccuracy < 100 && location.horizontalAccuracy < 100)
//        {
////            [self.locationManager stopUpdatingLocation];
////            [self findEventNearby:location];
//        }
//    }
//}


#pragma Mark - Segue to Post Service View Controller

- (IBAction)onAddServiceButtonTapped:(UIBarButtonItem *)sender
{
        UIStoryboard *postStoryBoard = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
        UIViewController *postVC = [postStoryBoard instantiateViewControllerWithIdentifier:@"PostNavBar"];
        [self presentViewController:postVC animated:true completion:nil];
}


- (IBAction)onHistoryButtonTapped:(UIBarButtonItem *)sender
{
    UIStoryboard *postStoryBoard = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    UIViewController *postHistoryVC = [postStoryBoard instantiateViewControllerWithIdentifier:@"PostHistoryVC"];
    [self presentViewController:postHistoryVC animated:true completion:nil];
}



@end
