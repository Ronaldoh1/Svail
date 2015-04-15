//
//  EventLocationSetter.m
//  Svail
//
//  Created by Mert Akanay on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "EventLocationDownloader.h"

@implementation EventLocationDownloader 

+(void)downloadEventLocation:(void (^)(MKPointAnnotation *))complete
{
    MKPointAnnotation *randomAnnotation;
    double latitude = 38.790752;
    double longtitude = -123.402039;
    CLLocationCoordinate2D makersCoordinate = CLLocationCoordinate2DMake(latitude, longtitude);
    randomAnnotation = [[MKPointAnnotation alloc] init];
    randomAnnotation.title = @"random location";
    randomAnnotation.coordinate = makersCoordinate;

    complete (randomAnnotation);
}


@end
