//
//  PickTimeSlotViewController.h
//  Svail
//
//  Created by zhenduo zhu on 4/29/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"
#import "ServiceSlot.h"
#import "ReviewReservationViewController.h"

@interface PickTimeSlotViewController : UIViewController

@property (nonatomic) Service *service;
@property (nonatomic) ReviewReservationViewController *reviewVC;

@end
