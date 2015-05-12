//
//  Reservation.h
//  Svail
//
//  Created by zhenduo zhu on 5/10/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "ServiceSlot.h"

@interface Reservation : PFObject<PFSubclassing>

@property (nonatomic) User *reserver;
@property (nonatomic) ServiceSlot *serviceSlot;

@end
