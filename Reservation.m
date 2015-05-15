//
//  Reservation.m
//  Svail
//
//  Created by zhenduo zhu on 5/10/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Reservation.h"
#import <Parse/PFObject+Subclass.h>

@implementation Reservation

@dynamic reserver;
@dynamic serviceSlot;

+ (void)load{
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Reservation";
}

@end
