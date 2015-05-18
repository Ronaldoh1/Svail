//
//  PostTableViewCell.h
//  Svail
//
//  Created by zhenduo zhu on 4/27/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"
#import "ServiceSlot.h"

@interface PostTableViewCell : UITableViewCell

@property (nonatomic) Service *service;
@property (nonatomic) UIViewController *vc;




-(void)getServiceImages;

@end
