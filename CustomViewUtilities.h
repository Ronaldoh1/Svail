//
//  ViewUtilities.h
//  Svail
//
//  Created by zhenduo zhu on 4/26/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomViewUtilities : NSObject


+(void)setupProfileImageView:(UIImageView *)profileImageView WithImage:(UIImage *)image;
+(void)transformToCircleViewFromSquareView:(UIView *)squareImageView;

@end
