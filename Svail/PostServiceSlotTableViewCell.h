//
//  PostServiceSlotTableViewCell.h
//  Svail
//
//  Created by zhenduo zhu on 5/9/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceSlot.h"

@interface PostServiceSlotTableViewCell : UITableViewCell

@property (nonatomic) ServiceSlot *serviceSlot;
@property (nonatomic) Service *service;
@property (nonatomic) UIViewController *vc;

@end
