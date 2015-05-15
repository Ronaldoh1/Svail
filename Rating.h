//
//  Rating.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "ServiceSlot.h"

@interface Rating : PFObject<PFSubclassing>
//@property NSString *comment;
@property (nonatomic) User *rater;
@property (nonatomic) ServiceSlot *serviceSlot;
@property (nonatomic) double value;

+(NSString *)parseClassName;


@end
