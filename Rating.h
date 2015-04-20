//
//  Rating.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

@interface Rating : PFObject<PFSubclassing>
@property NSString *comment;
@property User *ratee;
@property User *rater;
@property NSNumber *rating;

+(NSString *)parseClassName;


@end
