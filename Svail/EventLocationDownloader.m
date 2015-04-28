//
//  EventLocationSetter.m
//  Svail
//
//  Created by Mert Akanay on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "EventLocationDownloader.h"

@implementation EventLocationDownloader 

+(void)downloadEventLocationForLocation:(CLLocation *)location withCompletion:(void (^)(NSArray *))complete
{
    PFGeoPoint *newGeoPoint= [PFGeoPoint geoPointWithLocation:location];
    PFQuery *newQuery=[Service query];
    [newQuery whereKey:@"theServiceGeoPoint" nearGeoPoint:newGeoPoint];
    newQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [newQuery findObjectsInBackgroundWithBlock:^(NSArray *services, NSError *error) {

        NSArray *eventsArray = services;

        complete (eventsArray);
    }];
}


@end
