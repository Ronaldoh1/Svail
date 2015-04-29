//
//  Service.m
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Service.h"
#import <Parse/PFObject+Subclass.h>

@implementation Service

@dynamic title;
@dynamic availability;
@dynamic capacity;
@dynamic category;
@dynamic checkInLocation;
@dynamic isReserved;
@dynamic theServiceGeoPoint;
@dynamic price;
@dynamic provider;
@dynamic startDate;
@dynamic endDate;
@dynamic travel;
@dynamic serviceLocationAddress;
@dynamic serviceDescription;
@synthesize annotation;
@dynamic participants;
@dynamic startTimes;
@dynamic durationTime;
@dynamic imageFiles;


+ (void)load{
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Service";
}







@end
