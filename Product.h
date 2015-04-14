//
//  Product.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "User.h"

@interface Product : PFProduct

@property NSDate *availability;
@property NSNumber *capacity;
@property NSString *category;
@property PFGeoPoint *checkInLocation;
@property BOOL isReserved;
@property NSString *location;
@property NSNumber *price;
@property User *provider;
@property NSDate *specificTime;
@property BOOL travel;



@end
