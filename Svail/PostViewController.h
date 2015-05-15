//
//  PostViewController.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Service.h"

@interface PostViewController : UIViewController

@property PFGeoPoint *serviceGeoPoint;
@property Service *serviceToEdit;

@end
