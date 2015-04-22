//
//  Referencer.m
//  Svail
//
//  Created by zhenduo zhu on 4/20/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Reference.h"
#import <Parse/PFObject+Subclass.h>

@implementation Reference

@dynamic fromPhoneNumber;
@dynamic userToVerify;

+(void)load{
    [self registerSubclass];
}

+ (NSString *)parseClassName{
    return @"Reference";
}


@end
