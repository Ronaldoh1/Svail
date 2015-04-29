//
//  ServicePointAnnotation.h
//  Svail
//
//  Created by Mert Akanay on 4/21/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Service.h"
#import "CustomPinAnnotation.h"

@interface CustomPointAnnotation : MKPointAnnotation
@property Service *service;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic) CustomPinAnnotationType type;

@end
