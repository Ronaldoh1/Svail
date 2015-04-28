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

-(void)getVerificationInfoWithCompletion:(void (^)(NSError *))complete
{
    
    if (!self.verification) {
        self.verification = [Verification object];
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


@end
