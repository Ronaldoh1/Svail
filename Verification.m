//
//  Verification.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Verification.h"
#import <Parse/PFObject+Subclass.h>



@implementation Verification

static NSUInteger const kMinimumFBFriendsCount = 10;
static NSUInteger const kMinimumTTFollowersCount = 10;
static NSUInteger const kMinimumLKConnectionsCount = 10;



@dynamic verifiers;
@dynamic safetyLevel;
@dynamic fbLevel;
@dynamic ttLevel;
@dynamic lkLevel;
@dynamic user;

+(void)load{
    [self registerSubclass];

}

+ (NSString *)parseClassName{
    return @"Verification";
}

//To customize initialization, override object instead of init. If overriding init, other Parse classes cannot use this subclass as pointer or relation property.
+(instancetype)object
{
    Verification *verification = [super object];
    if (verification) {
        verification.fbLevel = 0;
        verification.ttLevel = 0;
        verification.lkLevel = 0;
    }
    return verification;
}

+(NSUInteger)getFBLevelWithNumOfFriends:(NSUInteger)numOfFriends
{
    NSUInteger fbLevel = 0;
    if (numOfFriends >= kMinimumFBFriendsCount) {
        fbLevel = 1;
    }
    return fbLevel;
}

+(NSUInteger)getTTLevelWithNumOfFollowers:(NSUInteger)numOfFollowers
{
    NSUInteger ttLevel = 0;
    if (numOfFollowers >= kMinimumTTFollowersCount) {
        ttLevel = 1;
    }
    return ttLevel;
}

+(NSUInteger)getLKLevelWithNumOfConnections:(NSUInteger)numOfConnections
{
    NSUInteger lkLevel = 0;
    if (numOfConnections >= kMinimumLKConnectionsCount) {
        lkLevel = 1;
    }
    return lkLevel;
}



@end
