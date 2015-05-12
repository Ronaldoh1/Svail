//
//  Service.m
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Service.h"
#import "ServiceSlot.h"
#import "Image.h"
#import <Parse/PFObject+Subclass.h>

@implementation Service

const NSUInteger kMaxNumberOfServiceImages = 4;

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
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                 NSError *error)
     {
         if (!error) {
             NSIndexSet *indexSet = [objects indexesOfObjectsPassingTest:^BOOL(ServiceSlot *obj, NSUInteger idx, BOOL *stop) {
                 return obj.participants.count < [self.capacity integerValue];
             }];
             complete([objects objectsAtIndexes:indexSet]);
         }
     }];
    
}

-(void)getServiceImageDataWithCompletion:(void (^)(NSDictionary  *))complete
{
    PFQuery *imagesQuery = [Image query];
    [imagesQuery whereKey:@"service" equalTo:self];
    imagesQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [imagesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                    NSError *error)
     {
         if (!error) {
             for (int i = 0;i < objects.count;i++) {
                 Image *image = objects[i];
                 [image.imageFile getDataInBackgroundWithBlock:^(NSData *data,
                                                                 NSError *error)
                  {
                      if (!error) {
                          complete(@{@(i):data});
                      }
                  }];
             }
         }
     }];
}

-(void)getParticipantsWithCompletion:(void (^)(NSArray *))complete

{
    PFQuery *serviceSlotQuery = [ServiceSlot query];
    [serviceSlotQuery whereKey:@"service" equalTo:self];
    [serviceSlotQuery includeKey:@"participants"];
    serviceSlotQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceSlotQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     
    {
        if (!error) {
            NSMutableArray *participants = [NSMutableArray new];
            for (ServiceSlot *serviceSlot in objects) {
                for (User *participant in serviceSlot.participants) {
                    [participants addObject:participant];
                }
            }
            complete(participants.copy);
        }
    }];
}


-(void)deleteServiceWithCompletion:(void (^)(BOOL))complete;
{
    PFQuery *serviceSlotQuery = [ServiceSlot query];
    [serviceSlotQuery whereKey:@"service" equalTo:self];
    [serviceSlotQuery includeKey:@"service"];
    [serviceSlotQuery includeKey:@"participants"];
    serviceSlotQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [serviceSlotQuery findObjectsInBackgroundWithBlock:^(NSArray *serviceSlots, NSError *error)
     {
         if (!error) {
            __block NSUInteger numOfServiceSlotDeleted = 0;
            for (int i = 0; i < serviceSlots.count; i++) {
                ServiceSlot *serviceSlot = serviceSlots[i];
                if (serviceSlot.participants.count == 0) {
                    [serviceSlot checkStatusWithCompletion:^(ServiceSlotStatus serviceSlotStatus) {
                        
                        if (serviceSlotStatus != HasFinished) {
                            numOfServiceSlotDeleted += 1;
                            [serviceSlot deleteInBackground];
                            [self.startTimes removeObject:serviceSlot.startTime];
                            
                            if (numOfServiceSlotDeleted == serviceSlots.count) {
                                PFQuery *imageQuery = [Image query];
                                [imageQuery whereKey:@"service" equalTo:self];
                                [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *images,NSError *error)
                                 {
                                     if (!error) {
                                         for (Image *image in images) {
                                             [image deleteInBackground];
                                         }
                                     }
                                 }];
                                [self deleteInBackground];
                                complete(true);
                            } else {
                                if (i == self.serviceSlots.count - 1) {
                                    [self saveInBackground];
                                    complete(false);
                                }
                            }
                        } else {
                            if (i == self.serviceSlots.count - 1) {
                                [self saveInBackground];
                                complete(false);
                            }
                        }
                    }];
                } else {
                    if (i == self.serviceSlots.count - 1) {
                        [self saveInBackground];
                        complete(false);
                    }
                }
            }
         }
     
     }];
}




@end
