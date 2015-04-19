//
//  EventLocationSetter.h
//  Svail
//
//  Created by Mert Akanay on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Service.h"

@interface EventLocationDownloader : NSObject <MKMapViewDelegate>

+(void)downloadEventLocation:(void (^)(NSArray *))complete;

@end
