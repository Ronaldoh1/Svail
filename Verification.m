//
//  Verification.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Verification.h"

@implementation Verification

//static NSNumber *const kMinimumFBFriendsCount = @10;

@dynamic verifiers;
@dynamic safetyLevel;
@dynamic fbLevel;
@dynamic ttLevel;
@dynamic lkLevel;

+(void)load{
    [self registerSubclass];

}
+ (NSString *)parseClassName{
    return @"Verification";
}

-(void)getFBLevelWithNumOfFriends:(NSUInteger)numOfFriends
{
    if (numOfFriends > 9) {
        self.fbLevel = @1;
    } else {
        self.fbLevel = @0;
    }
}

-(void)getTTLevelWithNumOfFriends:(NSUInteger)numOfFollowers
{
    if (numOfFollowers > 9) {
        self.ttLevel = @1;
    } else {
        self.ttLevel = @0;
    }
}

@end
