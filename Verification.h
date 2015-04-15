//
//  Verification.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
@interface Verification : PFObject


@property User *requester;
@property NSArray *verifiers;
@property NSNumber *safetyLevel;



@end