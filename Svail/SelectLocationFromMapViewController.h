//
//  SelectLocationFromMapViewController.h
//  Svail
//
//  Created by Ronald Hernandez on 4/15/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SelectLocationFromMapViewController : UIViewController
@property PFGeoPoint *serviceGeoPointFromMap;
@property PFGeoPoint *serviceGeoPointToEdit;
@property BOOL editModeLocation;
@property NSString *userLocation;

@end
