//
//  SelectImageViewController.h
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Service.h"

@interface SelectImageViewController : UIViewController

@property PFGeoPoint *serviceGeoPoint;
@property Service *service;

@end
