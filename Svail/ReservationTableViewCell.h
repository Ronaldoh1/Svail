//
//  PurchaseTableViewCell.h
//  Svail
//
//  Created by zhenduo zhu on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reservation.h"

@interface ReservationTableViewCell : UITableViewCell

@property (nonatomic) Reservation *reservation;
@property (nonatomic) UIViewController *vc;

@end
