//
//  Purchase.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Image.h"

@interface Purchase : PFObject<PFSubclassing>
@property User *customer;
@property NSDate *dateCompleted;
@property BOOL isCompleted;
@property User *provider;
@property (nonatomic) PFRelation *images;

+(NSString *)parseClassName;


@end
