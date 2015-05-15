//
//  Rating.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Rating.h"
#import <Parse/PFObject+Subclass.h>

@implementation Rating

//@dynamic comment;
@dynamic rater;
@dynamic value;
@dynamic serviceSlot;

+(void)load{
    [self registerSubclass];

}
+ (NSString *)parseClassName{
    return @"Rating";
}

@end
