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
@property PFGeoPoint *theServiceGeoPoint;
@property NSString *serviceLocationAddress;
@property NSDecimalNumber *price;
@property User *provider;
@property NSDate *startDate;
@property NSDate *endDate;
@property NSMutableArray *startTimes;
@property BOOL travel;
@property NSString *serviceDescription;
@property MKPointAnnotation *annotation;
@property NSMutableArray *participants;
@property double durationTime;
@property (nonatomic) NSArray *imageFiles;
@property (nonatomic) NSArray *serviceSlots;


+(NSString *)parseClassName;


@end