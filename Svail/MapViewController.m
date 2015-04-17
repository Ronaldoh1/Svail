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

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *providerPoint;
@property NSArray *eventsArray;
@property NSArray *searchResults;
@property NSMutableArray *filterArray;
@property NSMutableArray *resultsArray;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;

    [EventLocationDownloader downloadEventLocation:^(MKPointAnnotation *annotation)
    {
        self.providerPoint = annotation;

        [self.mapView addAnnotation:self.providerPoint];

    }];

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

-(void)findEventNearby:(CLLocation *)location
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = self.searchBar.text;
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(100.0, 100.0));
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.searchResults = response.mapItems;

        //NEED TO CREATE MAPITEMS ARRAY FROM FILTERARRAY AS IT HAS SERVICE ITEMS

    }];

    NSMutableSet* set1 = [NSMutableSet setWithArray:self.searchResults];
    NSMutableSet* set2 = [NSMutableSet setWithArray:self.filterArray];
    [set1 intersectSet:set2];

    NSArray *resultsArray = [set1 allObjects];
}

- (IBAction)segmentSelected:(UISegmentedControl *)sender
{

    NSString *weekday = [self.segmentedControl titleForSegmentAtIndex:sender.selectedSegmentIndex];

    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyy"];
    date = [formatter dateFromString:@"Apr 7, 2011"];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:units fromDate:date];
    NSInteger eventWeekday = [components weekday];
    NSDateFormatter *eventWeekDay = [[NSDateFormatter alloc]init];
    [eventWeekDay setDateFormat:@"EEE"];

    //download uploaded geopoints from parse and convert them into mapItems

//    if ([eventWeekDay stringFromDate:date] == weekday && [self.eventsArray containsObject:newService])
//    {
//        [self.filterArray addObject:newService];
//    }

}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        if (location.verticalAccuracy < 100 && location.horizontalAccuracy < 100)
        {
//            [self.locationManager stopUpdatingLocation];
            [self findEventNearby:location];
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D newCoordinate = view.annotation.coordinate;
        NSLog(@"dropped at %f,%f", newCoordinate.latitude, newCoordinate.longitude);

    }
}




@end
