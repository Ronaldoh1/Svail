//
//  Report.h
//  Svail
//
//  Created by zhenduo zhu on 5/12/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Service.h"

@interface Report : PFObject<PFSubclassing>

@property (nonatomic) User *reporter;
@property (nonatomic) User *userReported;
@property (nonatomic) Service *serviceReported;


-(void)handleReportWithCompletion:(void (^)(NSError *))complete;

@end
