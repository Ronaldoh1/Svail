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
@dynamic date;
@dynamic startTime;
@dynamic endTime;


+ (void)load{
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"ServiceSlot";
}

-(NSString *)getTimeSlotString
{
    NSUInteger startHour = (floor)((double)([self.startTime integerValue]) / 60. /60.);
    NSUInteger startMinutes = ([self.startTime integerValue] - startHour * 60 * 60)/60;
    
    
    NSUInteger endTime = [self.startTime integerValue] + self.service.durationTime * 3600;
    NSUInteger endHour = (floor)((double)endTime / 60. /60.);
    NSUInteger endMinutes = (endTime - endHour * 60 * 60)/60;
    
    return [NSString stringWithFormat:@"%02lu:%02lu -- %02lu:%02lu", startHour,startMinutes, endHour, endMinutes];
}

@end
