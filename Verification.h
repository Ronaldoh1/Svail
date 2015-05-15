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
@property NSInteger safetyLevel;
@property (nonatomic) NSUInteger fbLevel;
@property (nonatomic) NSUInteger ttLevel;
@property (nonatomic) NSUInteger lkLevel;
@property (nonatomic) NSString *fbId;
@property (nonatomic) NSString *ttId;
@property (nonatomic) NSString *lkId;
@property (nonatomic) BOOL hasReachedSafeLevel;
@property (nonatomic) NSString *phoneVerifyCode;


+(NSString *)parseClassName;

+(NSUInteger)getFBLevelWithNumOfFriends:(NSUInteger)numOfFriends;
+(NSUInteger)getTTLevelWithNumOfFollowers:(NSUInteger)numOfFollowers;
+(NSUInteger)getLKLevelWithNumOfConnections:(NSUInteger)numOfConnections;


+(void)checkIfFBId:(NSString *)fbId hasBeenUsedWithCompletion:(void (^)(Verification *, NSError *))complete;
+(void)checkIfTTId:(NSString *)ttId hasBeenUsedWithCompletion:(void (^)(Verification *, NSError *))complete;
+(void)checkIfLKId:(NSString *)lkId hasBeenUsedWithCompletion:(void (^)(Verification *, NSError *))complete;


-(void)sendVerifyCodeToPhoneNumber:(NSString *)phoneNumber;
-(BOOL)verifyPhoneNumber:(NSString *)phoneNumber withVerifyCode:(NSString *)verifyCode;

-(NSInteger)calculateSafetyLevel;


@end
