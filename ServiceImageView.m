//
//  ServiceImageView.m
//  Svail
//
//  Created by zhenduo zhu on 5/10/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "ServiceImageView.h"
#import "LargeServiceImageViewController.h"


@implementation ServiceImageView

-(void)setImage:(UIImage *)image
{
    [super setImage:image];
    self.userInteractionEnabled = true;
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapOnServiceImageView:)];
    tapGesture.numberOfTapsRequired = 1;
    
    [self addGestureRecognizer:tapGesture];
}

-(void)handleTapOnServiceImageView:(UITapGestureRecognizer *)tapGesture
{
   
    UIStoryboard *reservationStoryboard = [UIStoryboard storyboardWithName:@"Reservation" bundle:nil];
    UINavigationController *serviceImageNavVC = [reservationStoryboard instantiateViewControllerWithIdentifier:@"ServiceImageNavVC"];
    LargeServiceImageViewController *largeServiceImageVC = serviceImageNavVC.childViewControllers[0];
    largeServiceImageVC.serviceImage = self.image;
    largeServiceImageVC.title = self.title;
    [self.vc presentViewController:serviceImageNavVC animated:true completion:nil];
}


@end
