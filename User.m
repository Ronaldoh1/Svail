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


+ (void)load {
    [self registerSubclass];
}

//-(void)getVerificationRecordWithCompletion:(void (^)())complete
//{
//    
//    if (!self.verification) {
//        self.verification = [Verification object];
//        [self saveInBackground];
//    } else {
//        PFQuery *query = [User query];
//        [query includeKey:@"verification.references"];
//        [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *user, NSError *error)
//         {
//    }
//}


@end
