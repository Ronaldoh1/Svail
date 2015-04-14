//
//  Product.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Product.h"

@implementation Product


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

+ (void)load{
    [self registerSubclass];
}



@end
