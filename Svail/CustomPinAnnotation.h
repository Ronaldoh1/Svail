//
//  CustomPinAnnotation.h
//  Svail
//
//  Created by Mert Akanay on 4/29/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <MapKit/MapKit.h>

typedef enum {
    CustomPinAnnotationTypeStandard,
    CustomPinAnnotationTypeDisc,
    CustomPinAnnotationTypeTag,
    CustomPinAnnotationTypeTagStroke
} CustomPinAnnotationType;

@interface CustomPinAnnotation : MKAnnotationView

@property (nonatomic) CustomPinAnnotationType annotationType;

@property (nonatomic, strong) UIColor *annotationColor;

@end
