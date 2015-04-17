//
//  Service.m
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Service.h"

@implementation Service

@dynamic title;
@dynamic availability;
@dynamic capacity;
@dynamic category;
@dynamic checkInLocation;
@dynamic isReserved;
@dynamic location;
@dynamic price;
@dynamic provider;
@dynamic specificTime;
@dynamic travel;
@dynamic description;
@synthesize annotation;

+ (void)load{
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Service";
}





@end
