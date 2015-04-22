//
//  Referencer.h
//  Svail
//
//  Created by zhenduo zhu on 4/20/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

@interface Reference : PFObject<PFSubclassing>

@property (nonatomic) NSString *fromPhoneNumber;
@property (nonatomic) User *userToVerify;

+(NSString *)parseClassName;

@end
