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
    
    return [NSString stringWithFormat:@"%02lu:%02lu -- %02lu:%02lu", (long)startHour,(long)startMinutes, (long)endHour, (long)endMinutes];
}

-(void)checkIfHasFinishedWithCompletion:(void (^)(BOOL))complete
{
    PFQuery *serviceQuery = [Service query];
    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceQuery getObjectInBackgroundWithId:self.service.objectId block:^(PFObject *service, NSError *error)
    {
        if (!error) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"MM/dd/yy"];
            NSString *timeString = [dateFormatter stringFromDate:self.service.startDate];
            NSUInteger endTime = [self.startTime integerValue] + self.service.durationTime * 3600;
            NSUInteger endHour = (floor)((double)endTime / 60. /60.);
            NSUInteger endMinutes = (endTime - endHour * 60 * 60)/60;
            timeString = [NSString stringWithFormat:@"%@ %02lu:%02lu",timeString,(long)endHour,(long)endMinutes];
            NSDateFormatter *endDateFormatter = [NSDateFormatter new];
            [endDateFormatter setDateFormat:@"MM/dd/yy HH:mm"];
            NSDate *serviceSlotEndDate = [endDateFormatter dateFromString:timeString];
           BOOL hasFinished =  [serviceSlotEndDate compare:[NSDate date]] == NSOrderedAscending;
            complete(hasFinished);
        }
    }];
}

-(void)checkStatusWithCompletion:(void (^)(ServiceSlotStatus))complete
{
    PFQuery *serviceQuery = [Service query];
    serviceQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceQuery getObjectInBackgroundWithId:self.service.objectId block:^(PFObject *service, NSError *error)
    {
        if (!error) {
            NSDateFormatter *serviceDateFormatter = [NSDateFormatter new];
            [serviceDateFormatter setDateFormat:@"MM/dd/yy"];
            
            NSDateFormatter *serviceSlotDateFormatter = [NSDateFormatter new];
            [serviceSlotDateFormatter setDateFormat:@"MM/dd/yy HH:mm"];
            
            NSString *startTimeString = [serviceDateFormatter stringFromDate:self.service.startDate];
            NSUInteger startTime = [self.startTime integerValue];
            NSUInteger startHour = (floor)((double)startTime / 60. /60.);
            NSUInteger startMinutes = (startTime - startHour * 60 * 60)/60;
            startTimeString = [NSString stringWithFormat:@"%@ %02lu:%02lu",startTimeString,(long)startHour,(long)startMinutes];
            NSDate *serviceSlotStartDate = [serviceSlotDateFormatter dateFromString:startTimeString];

            
            NSString *endTimeString = [serviceDateFormatter stringFromDate:self.service.startDate];
            NSUInteger endTime = [self.startTime integerValue] + self.service.durationTime * 3600;
            NSUInteger endHour = (floor)((double)endTime / 60. /60.);
            NSUInteger endMinutes = (endTime - endHour * 60 * 60)/60;
            endTimeString = [NSString stringWithFormat:@"%@ %02lu:%02lu",endTimeString,(long)endHour,(long)endMinutes];
            NSDate *serviceSlotEndDate = [serviceSlotDateFormatter dateFromString:endTimeString];
            
        
           BOOL hasStarted =  [serviceSlotStartDate compare:[NSDate date]] == NSOrderedAscending;
           BOOL hasFinished =  [serviceSlotEndDate compare:[NSDate date]] == NSOrderedAscending;
            
            if (!hasStarted) {
                complete(HasNotStarted);
            } else if (!hasFinished) {
                complete(HasStartedButNotFinished);
            } else {
                complete(HasFinished);
            }
            
        }
    }];
}




@end
