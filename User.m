//
//  User.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "User.h"
#import "Service.h"
#import "Rating.h"
#import "Report.h"
#import "Reservation.h"
#import "Reference.h"
#import <Parse/PFObject+Subclass.h>

@implementation User

@dynamic state;
@dynamic city;
@dynamic name;
@dynamic occupation;
@dynamic phoneNumber;
@dynamic profileImage;
@dynamic specialty;
@dynamic gender;
@dynamic verification;
@dynamic isFbUser;
@dynamic numberOfPosts;
@dynamic isPremium;

+ (void)load {
    [self registerSubclass];
}


+(void)checkIfPhoneNumber:(NSString *)phoneNumber hasBeenUsedWithCompletion:(void (^)(User *, NSError *))complete
{
    PFQuery *userQuery = [User query];
    [userQuery whereKey:@"phoneNumber" equalTo:phoneNumber];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error)
    {
        User *user;
        
        if (!error && objects.count > 0) {
            user = (User *)(objects[0]);
        }
        complete(user, error);
    }];
}

-(void)getVerificationInfoWithCompletion:(void (^)(NSError *))complete
{
    
    if (!self.verification) {
        self.verification = [Verification object];
        [self.verification saveInBackground];
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            complete(error);
        }];
    } else {
        PFQuery *query = [User query];
        [query includeKey:@"verification.references"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *user, NSError *error)
        {
            if (error) {
                return;
            }
            self.verification = ((User *)user).verification;
            complete(error);
        }];
    }
}

-(void)deleteUserAndAssociatedDataInBackground
{
    
    PFQuery *serviceQuery = [Service query];
    [serviceQuery whereKey:@"provider" equalTo:self];
    [serviceQuery findObjectsInBackgroundWithBlock:^(NSArray *services, NSError *error)
     {
         if (!error) {
             for (Service *service in services) {
                 [service deleteServiceAndAssociatedData];
             }
         }
     }];
         
    PFQuery *reservationQuery = [Reservation query];
    [reservationQuery whereKey:@"reserver" equalTo:self];
    [reservationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                    NSError *error)
     {
         if (!error) {
             for (Reservation *reservation in objects) {
                 [reservation deleteInBackground];
             }
         }
     }];
    
    
    
    PFQuery *ratingQuery = [Rating query];
    [ratingQuery whereKey:@"rater" equalTo:self];
    [ratingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                    NSError *error)
     {
         if (!error) {
             for (Rating *rating in objects) {
                 [rating deleteInBackground];
             }
         }
     }];
    
    PFQuery *reportQuery = [Report query];
    [reportQuery whereKey:@"reporter" equalTo:self];
    [reportQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                    NSError *error)
     {
         if (!error) {
             for (Report *report in objects) {
                 [report deleteInBackground];
             }
         }
     }];
    
    
    PFQuery *userQuery = [User query];
    [userQuery includeKey:@"verification.references"];
    [userQuery getObjectInBackgroundWithId:self.objectId block:^(PFObject *object, NSError *error)
    {
        if (!error) {
            User *user = (User *)object;
            for (Reference *reference in user.verification.references) {
                [reference deleteInBackground];
            }
            [user.verification deleteInBackground];
            
            [PFCloud callFunctionInBackground:@"deleteUser"
                               withParameters:@{@"userId":self.objectId}
                                        block:^(NSString *result, NSError *error) {
                                            if (!error) {
//                                                NSLog(@"%@",self.name);
                                            }
                                        }];

        }
    }];
    
}




@end
