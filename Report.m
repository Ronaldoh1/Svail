//
//  Report.m
//  Svail
//
//  Created by zhenduo zhu on 5/12/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Report.h"
#import <Parse/PFObject+Subclass.h>

@implementation Report

static const NSUInteger kMinimumNumOfReportsOfServiceToTriggerAutoDelete = 5;
static const NSUInteger kMinimumNumOfReportsOfUserToTriggerAutoDelete = 5;


@dynamic reporter;
@dynamic userReported;
@dynamic serviceReported;

+ (void)load{
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Report";
}

-(void)findReportsWithSameContentWithCompletion:(void (^)(NSArray *, NSError *))complete
{
    PFQuery *reportQuery = [Report query];
    if (self.userReported) {
        [reportQuery whereKey:@"userReported" equalTo:self.userReported];
    } else if (self.serviceReported) {
        [reportQuery whereKey:@"serviceReported" equalTo:self.serviceReported];
    }
    [reportQuery includeKey:@"reporter"];
    [reportQuery findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                                     NSError *error)
    {
        complete(objects, error);
    }];
}

-(void)handleReportWithCompletion:(void (^)(NSError *))complete
{
   [self findReportsWithSameContentWithCompletion:^(NSArray *reports, NSError *error) {
       if (!error) {
           BOOL userHasReported = false;
           for (Report *report in reports) {
               if ([report.reporter.objectId isEqualToString:self.reporter.objectId]) {
                   userHasReported = true;
                   break;
               }
           }
           if (!userHasReported) {
               
               [self saveInBackground];
               
               if (self.serviceReported && reports.count ==
                   kMinimumNumOfReportsOfServiceToTriggerAutoDelete - 1) {
                   [self.serviceReported deleteServiceAndAssociatedData];
               } else if (self.userReported && reports.count ==
                          kMinimumNumOfReportsOfUserToTriggerAutoDelete - 1) {
                   [self.userReported deleteUserAndAssociatedDataInBackground];
               }
               
               NSString *subject;
               NSString *text;
               if (self.serviceReported) {
                   subject = @"Report of service";
                   text = [NSString stringWithFormat:@"User %@ with id %@ reported service %@ with id %@ has inappropriate content.", self.reporter.name, self.reporter.objectId, self.serviceReported.title, self.serviceReported.objectId];
               } else if (self.userReported) {
                   subject = @"Report of user";
                   text = [NSString stringWithFormat:@"User %@ with id %@ reported user %@ with id %@ has inappropriate profile.", self.reporter.name, self.reporter.objectId, self.userReported.name, self.userReported.objectId];
               }
               
               [PFCloud callFunctionInBackground:@"sendEmailToSvail"
                                  withParameters:@{@"subject":subject,
                                                   @"text":text}
                                           block:^(NSString *result, NSError *error) {
                                               if (!error) {
                                               }
               }];
               
               
           }
       }
       complete(error);
   }];
}


@end
