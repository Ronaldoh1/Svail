//
//  Service.h
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "User.h"

@interface Service : PFObject<PFSubclassing>

@property NSString *title;
@property NSDate *availability;
@property NSNumber *capacity;
@property NSString *category;
@property PFGeoPoint *checkInLocation;
@property BOOL isReserved;
@property NSString *location;
@property NSNumber *price;
@property NSString *provider;
@property NSDate *specificTime;
@property BOOL travel;
@property NSString *description;
@property MKPointAnnotation *annotation;


@end