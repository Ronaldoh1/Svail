//
//  CustomImageView.h
//  Svail
//
//  Created by Mert Akanay on 4/26/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Service.h"

@interface CustomImageView : UIImageView
@property Service *service;
@property User *user;

@end
