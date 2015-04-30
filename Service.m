//
//  Service.m
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Service.h"
#import "ServiceSlot.h"
#import <Parse/PFObject+Subclass.h>

@implementation Service

@dynamic title;
@dynamic availability;
@dynamic capacity;
@dynamic category;
@dynamic checkInLocation;
@dynamic isReserved;
@dynamic theServiceGeoPoint;
@dynamic price;
@dynamic provider;
@dynamic startDate;
@dynamic endDate;
@dynamic travel;
@dynamic serviceLocationAddress;
@dynamic serviceDescription;
@synthesize annotation;
@dynamic participants;
@dynamic startTimes;
@dynamic durationTime;
@dynamic imageFiles;
@dynamic serviceSlots;


+ (void)load{
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Service";
}


-(void)checkAvailableSlotsWithCompletion:(void (^)(NSArray *))complete
{
    PFQuery *query = [ServiceSlot query];
    [query whereKey:@"service" equalTo:self];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                 NSError *error)
     {
         if (!error) {
             NSIndexSet *indexSet = [objects indexesOfObjectsPassingTest:^BOOL(ServiceSlot *obj, NSUInteger idx, BOOL *stop) {
                 return obj.participants.count <= [self.capacity integerValue];
             }];
             complete([objects objectsAtIndexes:indexSet]);
         }
     }];
    
}




@end
