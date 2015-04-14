//
//  User.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation User
@dynamic state;
@dynamic city;
@dynamic name;
@dynamic numberOfFBFriends;
@dynamic numberOfLinkedInConnections;
@dynamic numberOfTwitterFollowers;
@dynamic occupation;
@dynamic phoneNumber;
@dynamic profileImage;
@dynamic specialty;
@dynamic gender;


+ (void)load {
    [self registerSubclass];
}





@end
