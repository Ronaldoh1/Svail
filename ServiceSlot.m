//
//  ServiceSlot.m
//  Svail
//
//  Created by zhenduo zhu on 4/29/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "ServiceSlot.h"
#import <Parse/PFObject+Subclass.h>

@implementation ServiceSlot

@dynamic service;
@dynamic participants;
@dynamic startTime;


+ (void)load{
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"ServiceSlot";
}

-(NSString *)getStartTimeString
{
    NSUInteger hour = (floor)((double)([self.startTime integerValue]) / 60. /60.);
    NSUInteger minutes = ([self.startTime integerValue] - hour * 60 * 60)/60;
    return [NSString stringWithFormat:@"%02lu : %02lu", hour,minutes];
}

@end
