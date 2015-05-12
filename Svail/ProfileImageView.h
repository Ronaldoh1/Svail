//
//  CustomImageView.h
//  Svail
//
//  Created by Mert Akanay on 4/26/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileImageView : UIImageView
@property (nonatomic) User *user;
@property (nonatomic) UIViewController *vc;

@end
