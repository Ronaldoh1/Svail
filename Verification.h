//
//  Verification.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

@interface Verification : PFObject<PFSubclassing>

@property NSArray *verifiers;
@property NSNumber *safetyLevel;
@property (nonatomic) NSUInteger fbLevel;
@property (nonatomic) NSUInteger ttLevel;
@property (nonatomic) NSUInteger lkLevel;
@property (nonatomic) User *user;


+(NSString *)parseClassName;

+(NSUInteger)getFBLevelWithNumOfFriends:(NSUInteger)numOfFriends;
+(NSUInteger)getTTLevelWithNumOfFollowers:(NSUInteger)numOfFollowers;
+(NSUInteger)getLKLevelWithNumOfConnections:(NSUInteger)numOfConnections;



@end
