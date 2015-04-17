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

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *providerPoint;
@property NSMutableArray *eventsArray;
@property NSMutableArray *searchResults;
@property NSMutableArray *filterArray;
@property NSArray *resultsArray;
@property NSMutableArray *annotationArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;

    self.filterArray = [NSMutableArray new];
    self.searchResults = [NSMutableArray new];
    self.annotationArray = [NSMutableArray new];

    self.profileButton.image = [[User currentUser] objectForKey:@"profileImage"];

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

    self.segmentedControl.selected = YES;
    [self filterEventsForDate:self.segmentedControl];

    [EventLocationDownloader downloadEventLocation:^(NSArray *array)
     {
         self.eventsArray = [NSMutableArray arrayWithArray:array];

         for (Service *service in self.eventsArray) {
             service.annotation = [[MKPointAnnotation alloc] init];
             [self.annotationArray addObject:service.annotation];
         }
     }];
}

-(void)addAnnotationToMapFromArray:(NSArray *)array
{
    for (Service *aService in array) {

        PFGeoPoint *serviceGeoPoint = [aService objectForKey:@"theServiceGeoPoint"];
        double latitude = serviceGeoPoint.latitude;
        double longtitude = serviceGeoPoint.longitude;
        CLLocationCoordinate2D serviceCoordinate = CLLocationCoordinate2DMake(latitude, longtitude);
        aService.annotation = [[MKPointAnnotation alloc] init];
        aService.annotation.title = [aService objectForKey:@"title"];
        aService.annotation.coordinate = serviceCoordinate;
        [self.mapView removeAnnotations:self.annotationArray];
        [self.mapView addAnnotation:aService.annotation];

    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    pinAnnotation.canShowCallout = YES;
    pinAnnotation.draggable = YES;
    pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pinAnnotation;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

}


- (IBAction)segmentSelected:(UISegmentedControl *)sender
{
    [self filterEventsForDate:sender];
}

-(void)filterEventsForDate:(UISegmentedControl *)sender
{
    NSString *currentDate = [self.segmentedControl titleForSegmentAtIndex:sender.selectedSegmentIndex];

    for (Service *aService in self.eventsArray) {

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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isEqualToString:@""]) {

        for (Service *aService in self.filterArray) {
            if ([[aService objectForKey:@"title"] containsString:searchBar.text]) {

                [self.searchResults addObject:aService];
            }
        }
    }else{
        self.searchResults = self.filterArray;
    }
    [self addAnnotationToMapFromArray:self.searchResults];

}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self.locationManager startUpdatingLocation];
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D newCoordinate = view.annotation.coordinate;
        NSLog(@"dropped at %f,%f", newCoordinate.latitude, newCoordinate.longitude);
        MKPointAnnotation *newAnnotation = [MKPointAnnotation new];
        newAnnotation.coordinate = newCoordinate;
        self.mapView.showsUserLocation = NO;
        [self.mapView addAnnotation:newAnnotation];
    }
}

- (IBAction)onAddServiceButtonTapped:(UIBarButtonItem *)sender
{
        UIStoryboard *postStoryBoard = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
        UIViewController *postVC = [postStoryBoard instantiateViewControllerWithIdentifier:@"PostNavBar"];
        [self presentViewController:postVC animated:true completion:nil];
}



@end
