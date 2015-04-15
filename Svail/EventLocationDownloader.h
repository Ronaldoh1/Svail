//
//  EventLocationSetter.h
//  Svail
//
//  Created by Mert Akanay on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EventLocationDownloader : NSObject <MKMapViewDelegate>

+(void)downloadEventLocation:(void (^)(MKPointAnnotation *))complete;

@end
