//
//  User.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser
@property NSString *state;
@property NSString *city;
@property NSString *name;
@property NSNumber *numberOfFBFriends;
@property NSNumber *numberOfLinkedInConnections;
@property NSNumber *numberOfTwitterFollowers;
@property NSString *occupation;
@property NSString *phoneNumber;
@property PFFile *profileImage;
@property NSString *specialty;
@property NSString *gender;


@end
