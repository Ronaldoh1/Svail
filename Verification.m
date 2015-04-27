//
//  Verification.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "Verification.h"
#import <Parse/PFObject+Subclass.h>
#import "User.h"



@implementation Verification

static NSUInteger const kLowestSafetyLevel = 5;
static NSUInteger const kMinimumFBFriendsCount = 10;
static NSUInteger const kMinimumTTFollowersCount = 10;
static NSUInteger const kMinimumLKConnectionsCount = 10;

static NSUInteger const kPointsForReference = 2;
static NSUInteger const kPointsForVerifiedFBAccount = 1;
static NSUInteger const kPointsForVerifiedTTAccount = 1;
static NSUInteger const kPointsForVerifiedLKAccount = 2;



@dynamic references;
@dynamic fbLevel;
@dynamic ttLevel;
@dynamic lkLevel;
@dynamic hasReachedSafeLevel;
@dynamic safetyLevel;
@dynamic phoneVerifyCode;

//don't sythesize parse properties

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
        verification.safetyLevel = 0;
        verification.references = @[];
    }
    return verification;
}

+(NSUInteger)getFBLevelWithNumOfFriends:(NSUInteger)numOfFriends
{
    NSUInteger fbLevel = 0;
    if (numOfFriends >= kMinimumFBFriendsCount) {
        fbLevel = kPointsForVerifiedFBAccount;
    }
    return fbLevel;
}

+(NSUInteger)getTTLevelWithNumOfFollowers:(NSUInteger)numOfFollowers
{
    NSUInteger ttLevel = 0;
    if (numOfFollowers >= kMinimumTTFollowersCount) {
        ttLevel = kPointsForVerifiedTTAccount;
    }
    return ttLevel;
}

+(NSUInteger)getLKLevelWithNumOfConnections:(NSUInteger)numOfConnections
{
    NSUInteger lkLevel = 0;
    if (numOfConnections >= kMinimumLKConnectionsCount) {
        lkLevel = kPointsForVerifiedLKAccount;
    }
    return lkLevel;
}



-(NSInteger)calculateSafetyLevel
{
    return self.references.count * kPointsForReference + self.fbLevel +
            self.ttLevel + self.lkLevel;
}


-(BOOL)hasReachedSafeLevel
{
    return self.safetyLevel >= kLowestSafetyLevel;
}

-(void)sendVerifyCodeToPhoneNumber:(NSString *)phoneNumber
{
    NSUInteger verifyCode = arc4random_uniform(899999) + 100000;
    self.phoneVerifyCode = [NSString stringWithFormat:@"%lu",verifyCode];
    NSString *message = [NSString stringWithFormat:@"Svail sent phone number verification code: %@",self.phoneVerifyCode];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded) {
            [PFCloud callFunctionInBackground:@"sendSMS" withParameters:@{@"toNumber":phoneNumber,
                            @"message": message} block:^(NSString *result, NSError *error)
            {
                if (!error) {
                    NSLog(@"%@",result);
                }
            }];
        }
        
    }];
}


-(BOOL)verifyPhoneNumber:(NSString *)phoneNumber withVerifyCode:(NSString *)verifyCode
{
    if ([verifyCode isEqualToString:self.phoneVerifyCode]) {
        [User currentUser].phoneNumber = phoneNumber;
        [[User currentUser] saveInBackground];
        return true;
    } else {
        return false;
    }
   
}


@end
