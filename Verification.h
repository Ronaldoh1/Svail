//
//  Verification.h
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>

@interface Verification : PFObject<PFSubclassing>

@property NSArray *references;
@property NSNumber *safetyLevel;
@property (nonatomic) NSUInteger fbLevel;
@property (nonatomic) NSUInteger ttLevel;
@property (nonatomic) NSUInteger lkLevel;


+(NSString *)parseClassName;

+(NSUInteger)getFBLevelWithNumOfFriends:(NSUInteger)numOfFriends;
+(NSUInteger)getTTLevelWithNumOfFollowers:(NSUInteger)numOfFollowers;
+(NSUInteger)getLKLevelWithNumOfConnections:(NSUInteger)numOfConnections;



@end
