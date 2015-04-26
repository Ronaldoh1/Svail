//
//  Purchase.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Purchase.h"
#import <Parse/PFObject+Subclass.h>

@implementation Purchase
@dynamic customer;
@dynamic dateCompleted;
@dynamic isCompleted;
@dynamic provider;


@synthesize images = _images;


+(void)load{
    [self registerSubclass];

}

+ (NSString *)parseClassName{
    return @"Purchase";
}

-(void)setImages:(PFRelation *)images{
    _images = images;
}



@end
