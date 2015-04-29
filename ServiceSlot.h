//
//  ServiceSlot.h
//  Svail
//
//  Created by zhenduo zhu on 4/29/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//


#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "User.h"
#import "Service.h"

@interface ServiceSlot : PFObject<PFSubclassing>

@property  (nonatomic) Service *service;


@end
