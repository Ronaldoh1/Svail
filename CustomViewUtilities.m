//
//  ViewUtilities.m
//  Svail
//
//  Created by zhenduo zhu on 4/26/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "CustomViewUtilities.h"

@implementation CustomViewUtilities

+(void) setupProfileImageView:(UIImageView *)profileImageView WithImage:(UIImage *)image
{
    profileImageView.image = image;
    [CustomViewUtilities transformToCircleViewFromSquareView:profileImageView];
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapOnProfileImageView:)];
    tapGesture.numberOfTapsRequired = 1;

    [profileImageView addGestureRecognizer:tapGesture];
}

+(void)transformToCircleViewFromSquareView:(UIView *)squareImageView
{
    squareImageView.layer.cornerRadius = squareImageView.frame.size.height / 2;
    squareImageView.layer.masksToBounds = YES;
    squareImageView.layer.borderWidth = 2.0;
    squareImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(void)handleTapOnProfileImageView:(UITapGestureRecognizer *)tapGesture
{
    
    
}

@end
