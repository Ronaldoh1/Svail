//
//  Verification.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Verification.h"

@implementation Verification

@dynamic requester;
@dynamic verifiers;
@dynamic safetyLevel;

+(void)load{
    [self registerSubclass];

}
+ (NSString *)parseClassName{
    return @"Verification";
}

@end
